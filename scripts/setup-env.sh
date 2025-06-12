#!/bin/bash

# Anamny Environment Setup Script
# This script helps set up environment variables for different environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to generate random secret key
generate_secret_key() {
    openssl rand -hex 32
}

# Function to generate random password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to create environment file
create_env_file() {
    local env_file=$1
    local environment=$2
    
    print_info "Creating $env_file for $environment environment..."
    
    # Prompt for required values
    echo "Please provide the following information:"
    
    if [ "$environment" = "production" ]; then
        read -p "Enter your domain name (e.g., yourdomain.com): " DOMAIN_NAME
        read -p "Enter Digital Ocean server IP: " SERVER_IP
    fi
    
    read -p "Enter Gemini API key: " GEMINI_API_KEY
    
    if [ -z "$GEMINI_API_KEY" ]; then
        print_error "Gemini API key is required!"
        exit 1
    fi
    
    # Generate secure values
    SECRET_KEY=$(generate_secret_key)
    POSTGRES_PASSWORD=$(generate_password)
    
    # Create .env file
    cat > "$env_file" << EOF
# Anamny Health Tracker - $environment Environment
# Generated on $(date)

# Security
SECRET_KEY=$SECRET_KEY

# Database
POSTGRES_DB=anamny_db
POSTGRES_USER=anamny_user
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
DATABASE_URL=postgresql://anamny_user:$POSTGRES_PASSWORD@postgres:5432/anamny_db

# AI/Chat
GEMINI_API_KEY=$GEMINI_API_KEY
GOOGLE_API_KEY=$GEMINI_API_KEY

# Application
ENVIRONMENT=$environment
EOF

    if [ "$environment" = "production" ]; then
        cat >> "$env_file" << EOF

# Production specific
API_URL=https://$DOMAIN_NAME/api
FRONTEND_URL=https://$DOMAIN_NAME
ALLOWED_HOSTS=$DOMAIN_NAME,www.$DOMAIN_NAME,$SERVER_IP
CORS_ORIGINS=https://$DOMAIN_NAME,https://www.$DOMAIN_NAME

# Email (configure with your email service)
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_FROM=noreply@$DOMAIN_NAME
MAIL_PORT=587
MAIL_SERVER=smtp.gmail.com
MAIL_FROM_NAME=Anamny Health Tracker
EOF
    else
        cat >> "$env_file" << EOF

# Development specific
API_URL=http://localhost:8000
FRONTEND_URL=http://localhost:3000
ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ORIGINS=http://localhost:3000,http://localhost:8081

# Email (development)
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_FROM=noreply@localhost
MAIL_PORT=587
MAIL_SERVER=smtp.gmail.com
MAIL_FROM_NAME=Anamny Health Tracker
EOF
    fi
    
    print_info "Environment file created: $env_file"
    print_warning "Keep this file secure and never commit it to version control!"
    
    # Set appropriate permissions
    chmod 600 "$env_file"
    print_info "File permissions set to 600 (owner read/write only)"
}

# Main script
main() {
    print_info "Anamny Environment Setup"
    echo "=========================="
    
    echo "Select environment:"
    echo "1) Development (.env)"
    echo "2) Production (.env.prod)"
    echo "3) Both"
    read -p "Enter choice [1-3]: " choice
    
    case $choice in
        1)
            create_env_file ".env" "development"
            ;;
        2)
            create_env_file ".env.prod" "production"
            ;;
        3)
            create_env_file ".env" "development"
            create_env_file ".env.prod" "production"
            ;;
        *)
            print_error "Invalid choice!"
            exit 1
            ;;
    esac
    
    print_info "Setup complete!"
    echo ""
    print_warning "Next steps:"
    echo "1. Review and update the generated .env file(s)"
    echo "2. Configure your email settings if needed"
    echo "3. For production: Set up SSL certificates"
    echo "4. For production: Configure your domain DNS"
}

# Check if running as root in production
if [ "$EUID" -eq 0 ] && [ "$1" = "production" ]; then
    print_warning "Running as root. Consider creating a dedicated user for the application."
fi

# Run main function
main "$@"
