#!/bin/bash

# Anamny Digital Ocean Deployment Script
# This script sets up the application on a fresh Digital Ocean droplet

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root"
        print_info "Please run: sudo ./deploy-digitalocean.sh"
        exit 1
    fi
}

# Function to update system
update_system() {
    print_step "Updating system packages..."
    apt-get update
    apt-get upgrade -y
    apt-get install -y curl wget git ufw fail2ban
}

# Function to install Docker
install_docker() {
    print_step "Installing Docker..."
    
    # Remove old versions
    apt-get remove -y docker docker-engine docker.io containerd runc || true
    
    # Install prerequisites
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Add Docker repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Start and enable Docker
    systemctl start docker
    systemctl enable docker
    
    print_info "Docker installed successfully"
}

# Function to create application user
create_app_user() {
    print_step "Creating application user..."
    
    if ! id "anamny" &>/dev/null; then
        useradd -m -s /bin/bash anamny
        usermod -aG docker anamny
        print_info "User 'anamny' created and added to docker group"
    else
        print_info "User 'anamny' already exists"
    fi
}

# Function to setup firewall
setup_firewall() {
    print_step "Setting up firewall..."
    
    # Reset UFW to defaults
    ufw --force reset
    
    # Default policies
    ufw default deny incoming
    ufw default allow outgoing
    
    # Allow SSH (adjust port if you use non-standard)
    ufw allow 22/tcp
    
    # Allow HTTP and HTTPS
    ufw allow 80/tcp
    ufw allow 443/tcp
    
    # Enable firewall
    ufw --force enable
    
    print_info "Firewall configured successfully"
}

# Function to setup fail2ban
setup_fail2ban() {
    print_step "Setting up Fail2ban..."
    
    cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3

[nginx-http-auth]
enabled = true
port = http,https
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3

[nginx-limit-req]
enabled = true
port = http,https
filter = nginx-limit-req
logpath = /var/log/nginx/error.log
maxretry = 5
EOF

    systemctl restart fail2ban
    systemctl enable fail2ban
    
    print_info "Fail2ban configured successfully"
}

# Function to clone repository
clone_repository() {
    print_step "Cloning application repository..."
    
    # Create application directory
    mkdir -p /opt/anamny
    cd /opt
    
    # Clone repository
    if [ -d "anamny/.git" ]; then
        print_info "Repository already exists, pulling latest changes..."
        cd anamny
        git pull origin main
    else
        print_info "Cloning repository..."
        git clone https://github.com/hayshin/anamny.git
        cd anamny
    fi
    
    # Set ownership
    chown -R anamny:anamny /opt/anamny
    
    print_info "Repository cloned successfully"
}

# Function to setup environment
setup_environment() {
    print_step "Setting up environment variables..."
    
    cd /opt/anamny
    
    if [ ! -f ".env.prod" ]; then
        print_warning "Production environment file not found!"
        print_info "Please run the environment setup script:"
        print_info "sudo -u anamny ./scripts/setup-env.sh"
        print_info "Or manually create .env.prod file"
        return 1
    fi
    
    # Copy production environment
    cp .env.prod .env
    chown anamny:anamny .env
    chmod 600 .env
    
    print_info "Environment configured successfully"
}

# Function to setup SSL (Let's Encrypt)
setup_ssl() {
    print_step "Setting up SSL certificates..."
    
    read -p "Do you want to set up SSL with Let's Encrypt? (y/n): " setup_ssl
    if [ "$setup_ssl" = "y" ] || [ "$setup_ssl" = "Y" ]; then
        read -p "Enter your domain name: " domain
        read -p "Enter your email for Let's Encrypt: " email
        
        # Install certbot
        apt-get install -y certbot python3-certbot-nginx
        
        # Create initial nginx config
        mkdir -p /opt/anamny/nginx/ssl
        
        # Get SSL certificate
        certbot --nginx -d "$domain" --email "$email" --agree-tos --non-interactive
        
        # Setup auto-renewal
        (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
        
        print_info "SSL configured for $domain"
    else
        print_info "Skipping SSL setup"
    fi
}

# Function to create systemd service
create_systemd_service() {
    print_step "Creating systemd service..."
    
    cat > /etc/systemd/system/anamny.service << EOF
[Unit]
Description=Anamny Health Tracker
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/anamny
ExecStart=/usr/bin/docker compose -f docker-compose.prod.yml up -d
ExecStop=/usr/bin/docker compose -f docker-compose.prod.yml down
TimeoutStartSec=0
User=anamny
Group=anamny

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable anamny.service
    
    print_info "Systemd service created successfully"
}

# Function to deploy application
deploy_application() {
    print_step "Deploying application..."
    
    cd /opt/anamny
    
    # Build and start containers
    sudo -u anamny docker compose -f docker-compose.prod.yml up -d --build
    
    # Wait for services to start
    sleep 30
    
    # Run database migrations
    sudo -u anamny docker compose -f docker-compose.prod.yml exec -T server alembic upgrade head
    
    print_info "Application deployed successfully"
}

# Function to show status
show_status() {
    print_step "Checking application status..."
    
    cd /opt/anamny
    sudo -u anamny docker compose -f docker-compose.prod.yml ps
    
    echo ""
    print_info "Application URLs:"
    echo "Frontend: http://$(curl -s ifconfig.me)"
    echo "API Docs: http://$(curl -s ifconfig.me)/docs"
    echo "Health Check: http://$(curl -s ifconfig.me)/health"
}

# Main deployment function
main() {
    print_info "Anamny Digital Ocean Deployment"
    echo "================================"
    
    check_root
    
    echo "This script will:"
    echo "1. Update system packages"
    echo "2. Install Docker"
    echo "3. Create application user"
    echo "4. Setup firewall and security"
    echo "5. Clone application repository"
    echo "6. Setup environment variables"
    echo "7. Configure SSL (optional)"
    echo "8. Deploy application"
    echo ""
    
    read -p "Do you want to continue? (y/n): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        print_info "Deployment cancelled"
        exit 0
    fi
    
    update_system
    install_docker
    create_app_user
    setup_firewall
    setup_fail2ban
    clone_repository
    
    if setup_environment; then
        setup_ssl
        create_systemd_service
        deploy_application
        show_status
        
        echo ""
        print_info "Deployment completed successfully!"
        print_warning "Next steps:"
        echo "1. Configure your domain DNS to point to this server"
        echo "2. Update your GitHub repository secrets for automated deployments"
        echo "3. Test the application thoroughly"
        echo "4. Setup monitoring and backups"
    else
        print_error "Environment setup failed. Please configure .env.prod and run:"
        print_info "cd /opt/anamny && sudo -u anamny docker compose -f docker-compose.prod.yml up -d --build"
    fi
}

# Run main function
main "$@"
