````markdown name=DEPLOYMENT.md
# Fashion Try-On Platform - Deployment Guide

Complete deployment guide for the Ethical Fashion Try-On Platform.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Local Development](#local-development)
3. [Docker Deployment](#docker-deployment)
4. [Cloud Deployment](#cloud-deployment)
5. [Production Configuration](#production-configuration)
6. [Monitoring & Logs](#monitoring--logs)
7. [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Start

### Windows
```cmd
git clone https://github.com/victormwendwahope-hue/Fashion.git
cd Fashion
setup.bat
venv\Scripts\activate
uvicorn app:app --reload
```

### Linux/macOS
```bash
git clone https://github.com/victormwendwahope-hue/Fashion.git
cd Fashion
chmod +x setup.sh
./setup.sh
source venv/bin/activate
uvicorn app:app --reload
```

### Docker
```bash
docker-compose up -d
# Access at http://localhost:8000
```

---

## 💻 Local Development

### Prerequisites
- Python 3.9+
- pip
- Git

### Setup Steps

#### 1. Clone Repository
```bash
git clone https://github.com/victormwendwahope-hue/Fashion.git
cd Fashion
```

#### 2. Run Setup Script
**Windows:**
```cmd
setup.bat
```

**Linux/macOS:**
```bash
chmod +x setup.sh
./setup.sh
```

This automatically:
- Creates virtual environment
- Installs all dependencies
- Generates JWT secret key
- Creates .env file

#### 3. Configure Environment
Edit `.env` with your API keys:
```bash
nano .env
```

Required variables:
```env
REPLICATE_API_TOKEN=your_token_here
JWT_SECRET_KEY=your_generated_key
ENVIRONMENT=development
```

#### 4. Initialize Database
```bash
python seed_garments.py
```

#### 5. Run Application
```bash
uvicorn app:app --reload
```

Access at: `http://localhost:8000`

---

## 🐳 Docker Deployment

### Prerequisites
- Docker
- Docker Compose

### One-Command Deployment

```bash
docker-compose up -d
```

This starts:
- FastAPI application (port 8000)
- PostgreSQL database (port 5432)
- Redis cache (port 6379)
- Nginx reverse proxy (ports 80, 443)

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f db
docker-compose logs -f redis
```

### Stop Services
```bash
docker-compose down

# Remove volumes (WARNING: deletes data)
docker-compose down -v
```

### Rebuild Images
```bash
docker-compose build --no-cache
docker-compose up -d
```

---

## ☁️ Cloud Deployment

### Heroku

#### 1. Login to Heroku
```bash
heroku login
```

#### 2. Create App
```bash
heroku create your-app-name
```

#### 3. Set Environment Variables
```bash
heroku config:set REPLICATE_API_TOKEN=your_token -a your-app-name
heroku config:set JWT_SECRET_KEY=your_secret -a your-app-name
heroku config:set ENVIRONMENT=production -a your-app-name
heroku config:set DATABASE_URL=postgresql://... -a your-app-name
```

#### 4. Deploy
```bash
git push heroku main
```

#### 5. Check Logs
```bash
heroku logs --tail -a your-app-name
```

### AWS Elastic Beanstalk

#### 1. Install EB CLI
```bash
pip install awsebcli --upgrade --user
```

#### 2. Initialize
```bash
eb init -p docker fashion-app
```

#### 3. Create Environment
```bash
eb create fashion-env
```

#### 4. Deploy
```bash
eb deploy
```

### Google Cloud Run

#### 1. Build Image
```bash
gcloud builds submit --tag gcr.io/PROJECT_ID/fashion-app
```

#### 2. Deploy
```bash
gcloud run deploy fashion-app \
  --image gcr.io/PROJECT_ID/fashion-app \
  --platform managed \
  --region us-central1 \
  --set-env-vars REPLICATE_API_TOKEN=your_token,JWT_SECRET_KEY=your_secret
```

### Azure Container Instances

#### 1. Create Registry
```bash
az acr create --resource-group myGroup --name fashionregistry --sku Basic
```

#### 2. Build Image
```bash
az acr build --registry fashionregistry --image fashion-app:latest .
```

#### 3. Deploy
```bash
az container create \
  --resource-group myGroup \
  --name fashion-container \
  --image fashionregistry.azurecr.io/fashion-app:latest \
  --environment-variables REPLICATE_API_TOKEN=your_token
```

---

## ⚙️ Production Configuration

### Environment Variables

```env
# ==================== Core ====================
ENVIRONMENT=production
DEBUG=false

# ==================== Database ====================
DATABASE_URL=postgresql://user:password@host:5432/fashion_db

# ==================== JWT ====================
JWT_SECRET_KEY=your-secure-key-generate-with-secrets.token_urlsafe
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# ==================== API Keys ====================
REPLICATE_API_TOKEN=your_replicate_token
AGE_VERIFICATION_SERVICE=mock  # or real service

# ==================== Security ====================
HTTPS_ONLY=true
SECURE_COOKIES=true

# ==================== File Upload ====================
MAX_FILE_SIZE_MB=50
ALLOWED_IMAGE_TYPES=image/jpeg,image/png,image/webp

# ==================== Rate Limiting ====================
RATE_LIMIT_TRY_ON=5/minute
RATE_LIMIT_AUTH=10/hour
RATE_LIMIT_UPLOAD=20/hour

# ==================== CORS ====================
ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# ==================== Storage ====================
STORAGE_TYPE=s3  # or local
AWS_S3_BUCKET=your-bucket
AWS_S3_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret

# ==================== Logging ====================
LOG_LEVEL=INFO
```

### Production Checklist

- [ ] Change JWT_SECRET_KEY to secure value
- [ ] Set HTTPS_ONLY=true
- [ ] Set SECURE_COOKIES=true
- [ ] Use PostgreSQL (not SQLite)
- [ ] Configure S3 storage
- [ ] Set real age verification service
- [ ] Configure CORS for your domain
- [ ] Set up SSL/TLS certificates
- [ ] Configure monitoring and alerts
- [ ] Set up automated backups
- [ ] Configure rate limiting
- [ ] Enable audit logging
- [ ] Set up error tracking (e.g., Sentry)

---

## 📊 Monitoring & Logs

### Application Logs
```bash
# View logs
tail -f app.log

# Filter by level
grep ERROR app.log
grep WARNING app.log

# Search by user
grep "user_id=123" app.log
```

### Database Monitoring

#### PostgreSQL Query Logs
```bash
# Enable query logging
ALTER SYSTEM SET log_min_duration_statement = 1000;  # Log queries > 1s
SELECT pg_reload_conf();
```

#### Check Connections
```bash
SELECT count(*) FROM pg_stat_activity;
```

### Health Check
```bash
curl http://localhost:8000/health
```

### Metrics & Analytics

#### Database Statistics
```sql
-- User registrations
SELECT DATE(created_at), COUNT(*) FROM users GROUP BY DATE(created_at);

-- Try-on usage
SELECT try_on_mode, COUNT(*) FROM generated_images GROUP BY try_on_mode;

-- Safety events
SELECT event_type, COUNT(*) FROM audit_logs GROUP BY event_type;

-- Most used garments
SELECT garment_id, COUNT(*) FROM generated_images GROUP BY garment_id;
```

---

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Find process using port 8000
lsof -i :8000

# Kill process
kill -9 <PID>
```

### Database Connection Error
```bash
# Check PostgreSQL is running
pg_isready -h localhost

# Verify credentials
psql -U fashion_user -d fashion_db -h localhost
```

### Memory Issues
```bash
# Check memory usage
free -h
docker stats

# Increase Docker memory in docker-compose.yml:
deploy:
  resources:
    limits:
      memory: 2G
```

### SSL/TLS Errors

#### Generate Self-Signed Certificate (Development)
```bash
openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365
```

#### For Production
Use Let's Encrypt with Certbot:
```bash
certbot certonly --standalone -d yourdomain.com
```

### API Rate Limiting Issues
If requests are blocked, adjust in `.env`:
```env
RATE_LIMIT_TRY_ON=10/minute
RATE_LIMIT_AUTH=20/hour
```

### Replicate API Errors

#### Check API Token
```bash
curl -H "Authorization: Token $REPLICATE_API_TOKEN" https://api.replicate.com/v1/account
```

#### Common Errors
- **401 Unauthorized**: Check API token
- **429 Too Many Requests**: Wait or upgrade plan
- **503 Service Unavailable**: Replicate API is down

### Image Processing Failures

#### NudeNet Issues
```bash
# Clear model cache
rm -rf ~/.cache/torch/hub

# Reinstall package
pip install --force-reinstall nudenet
```

#### MediaPipe Issues
```bash
# Reinstall with specific version
pip install mediapipe==0.10.9
```

---

## 📞 Support

### Documentation
- API Docs: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`
- GitHub: https://github.com/victormwendwahope-hue/Fashion

### Reporting Issues
1. Check troubleshooting section
2. Review application logs
3. Open issue on GitHub with:
   - Error message
   - Log output
   - Steps to reproduce
   - Environment details

---

## 🔐 Security Notes

### API Key Management
- Never commit `.env` to repository
- Rotate keys regularly
- Use secrets manager in production
- Monitor key usage

### Database Security
- Use strong passwords
- Enable SSL for PostgreSQL
- Restrict network access
- Regular backups
- Monitor access logs

### HTTPS/TLS
- Always use HTTPS in production
- Use valid SSL certificates
- Enable HSTS headers
- Redirect HTTP to HTTPS

---

**Last Updated:** January 2024
**Version:** 2.0.0
````
