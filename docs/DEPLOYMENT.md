# GitHub Secrets Configuration

This document explains how to configure GitHub Secrets for automated deployment to Digital Ocean.

## Required GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions, then add the following secrets:

### Digital Ocean Server Access

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `DO_HOST` | Your Digital Ocean server IP address | `192.168.1.100` |
| `DO_USERNAME` | SSH username (usually `root` or `anamny`) | `anamny` |
| `DO_SSH_KEY` | Private SSH key for server access | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `DO_PORT` | SSH port (optional, defaults to 22) | `22` |

### Application Environment Variables

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `GEMINI_API_KEY` | Google Gemini API key for AI functionality | `kJDZFUAD214HSAD23ha9df-B` |
| `SECRET_KEY` | Application secret key (generate with OpenSSL) | `a1b2c3d4e5f6...` |
| `POSTGRES_PASSWORD` | Database password | `secure_random_password` |

## Setting Up SSH Key

1. **Generate SSH key pair on your local machine:**
   ```bash
   ssh-keygen -t ed25519 -C "github-actions@yourdomain.com" -f ~/.ssh/anamny_deploy
   ```

2. **Copy public key to your Digital Ocean server:**
   ```bash
   ssh-copy-id -i ~/.ssh/anamny_deploy.pub user@your-server-ip
   ```

3. **Add private key to GitHub Secrets:**
   - Copy the content of `~/.ssh/anamny_deploy` (private key)
   - Add it as `DO_SSH_KEY` secret in GitHub

## Digital Ocean Server Setup

### Option 1: Automated Setup (Recommended)

1. **Create a fresh Ubuntu 22.04 droplet on Digital Ocean**

2. **Connect to your server:**
   ```bash
   ssh root@your-server-ip
   ```

3. **Download and run the deployment script:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/hayshin/anamny/main/scripts/deploy-digitalocean.sh -o deploy.sh
   chmod +x deploy.sh
   sudo ./deploy.sh
   ```

4. **The script will:**
   - Install Docker and dependencies
   - Create application user
   - Setup firewall and security
   - Clone your repository
   - Configure environment variables
   - Deploy the application

### Option 2: Manual Setup

1. **Update system and install Docker:**
   ```bash
   apt update && apt upgrade -y
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   ```

2. **Create application directory:**
   ```bash
   mkdir -p /opt/anamny
   cd /opt/anamny
   git clone https://github.com/hayshin/anamny.git .
   ```

3. **Setup environment variables:**
   ```bash
   ./scripts/setup-env.sh
   ```

4. **Deploy application:**
   ```bash
   docker compose -f docker-compose.prod.yml up -d --build
   ```

## Environment Variables Management

### Production Environment (.env.prod)

Create a `.env.prod` file on your server with the following variables:

```env
# Security
SECRET_KEY=your_generated_secret_key_here

# Database
POSTGRES_DB=anamny_db
POSTGRES_USER=anamny_user
POSTGRES_PASSWORD=your_secure_database_password
DATABASE_URL=postgresql://anamny_user:your_secure_database_password@postgres:5432/anamny_db

# AI/Chat
GEMINI_API_KEY=your_gemini_api_key_here
GOOGLE_API_KEY=your_gemini_api_key_here

# Application
ENVIRONMENT=production
API_URL=https://yourdomain.com/api
FRONTEND_URL=https://yourdomain.com
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com,your.server.ip
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Email (configure with your email service)
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_app_password
MAIL_FROM=noreply@yourdomain.com
MAIL_PORT=587
MAIL_SERVER=smtp.gmail.com
MAIL_FROM_NAME=Anamny Health Tracker
```

### Generating Secure Values

1. **Secret Key:**
   ```bash
   openssl rand -hex 32
   ```

2. **Database Password:**
   ```bash
   openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
   ```

## Security Best Practices

### Server Security

1. **Firewall Configuration:**
   ```bash
   ufw default deny incoming
   ufw default allow outgoing
   ufw allow 22/tcp
   ufw allow 80/tcp
   ufw allow 443/tcp
   ufw enable
   ```

2. **Fail2ban Setup:**
   ```bash
   apt install fail2ban
   systemctl enable fail2ban
   systemctl start fail2ban
   ```

3. **SSL Certificate (Let's Encrypt):**
   ```bash
   apt install certbot python3-certbot-nginx
   certbot --nginx -d yourdomain.com
   ```

### Application Security

1. **Use strong, randomly generated passwords**
2. **Keep API keys secure and rotate them regularly**
3. **Use HTTPS in production**
4. **Regular security updates**
5. **Monitor logs for suspicious activity**

## Deployment Workflow

1. **Push to main branch** → Triggers GitHub Actions
2. **Tests run** → Ensures code quality
3. **Images build** → Creates production Docker images
4. **Deploy to server** → Updates running application
5. **Health checks** → Verifies deployment success

## Monitoring and Maintenance

### Check Application Status
```bash
cd /opt/anamny
docker compose -f docker-compose.prod.yml ps
docker compose -f docker-compose.prod.yml logs
```

### Update Application
```bash
cd /opt/anamny
git pull origin main
docker compose -f docker-compose.prod.yml up -d --build
```

### Backup Database
```bash
docker compose -f docker-compose.prod.yml exec postgres pg_dump -U anamny_user anamny_db > backup.sql
```

### View Logs
```bash
docker compose -f docker-compose.prod.yml logs -f server
docker compose -f docker-compose.prod.yml logs -f client
```

## Troubleshooting

### Common Issues

1. **Permission denied errors:**
   ```bash
   chown -R anamny:anamny /opt/anamny
   ```

2. **Port already in use:**
   ```bash
   docker compose -f docker-compose.prod.yml down
   docker compose -f docker-compose.prod.yml up -d
   ```

3. **SSL certificate issues:**
   ```bash
   certbot renew --dry-run
   ```

4. **Database connection issues:**
   - Check environment variables
   - Verify database is running
   - Check firewall settings

### Health Checks

- **Application:** `http://your-domain.com/health`
- **API Documentation:** `http://your-domain.com/docs`
- **Database:** Check with `docker compose logs postgres`

## Support

For issues or questions:
1. Check the application logs
2. Review this documentation
3. Check GitHub Issues
4. Contact the development team
