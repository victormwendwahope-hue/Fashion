#!/bin/bash

# ============================================================================
# Fashion Try-On Platform - Setup Script
# ============================================================================
# Usage: chmod +x setup.sh && ./setup.sh
# This script sets up the complete development environment
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Fashion Try-On Platform - Setup${NC}"
echo -e "${BLUE}========================================${NC}\n"

# ============================================================================
# Check Python Installation
# ============================================================================
echo -e "${YELLOW}[1/6] Checking Python installation...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 not found. Please install Python 3.9 or higher.${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo -e "${GREEN}✓ Python ${PYTHON_VERSION} found${NC}\n"

# ============================================================================
# Create Virtual Environment
# ============================================================================
echo -e "${YELLOW}[2/6] Creating virtual environment...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}✓ Virtual environment already exists${NC}"
fi

# Activate virtual environment
source venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}\n"

# ============================================================================
# Upgrade pip
# ============================================================================
echo -e "${YELLOW}[3/6] Upgrading pip...${NC}"
pip install --upgrade pip setuptools wheel > /dev/null 2>&1
echo -e "${GREEN}✓ pip upgraded${NC}\n"

# ============================================================================
# Install Dependencies
# ============================================================================
echo -e "${YELLOW}[4/6] Installing dependencies...${NC}"
pip install \
    fastapi==0.104.1 \
    uvicorn[standard]==0.24.0 \
    python-multipart==0.0.6 \
    pillow==10.1.0 \
    replicate==0.20.0 \
    nudenet==2.0.8 \
    opencv-python-headless==4.8.1.78 \
    mediapipe==0.10.9 \
    rembg==2.0.57 \
    requests==2.31.0 \
    sqlalchemy==2.0.23 \
    python-jose[cryptography]==3.3.0 \
    passlib[bcrypt]==1.7.4 \
    python-dotenv==1.0.0 \
    pydantic==2.5.0 \
    pydantic-settings==2.1.0 \
    slowapi==0.1.9 \
    boto3==1.28.85

echo -e "${GREEN}✓ All dependencies installed${NC}\n"

# ============================================================================
# Setup Environment Configuration
# ============================================================================
echo -e "${YELLOW}[5/6] Setting up environment configuration...${NC}"
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created from .env.example${NC}"
    echo -e "${YELLOW}  Please edit .env and add your API keys:${NC}"
    echo -e "${YELLOW}    - REPLICATE_API_TOKEN (required)${NC}"
    echo -e "${YELLOW}    - JWT_SECRET_KEY (generate one below)${NC}\n"
else
    echo -e "${GREEN}✓ .env file already exists${NC}\n"
fi

# ============================================================================
# Generate JWT Secret
# ============================================================================
echo -e "${YELLOW}[6/6] Generating JWT Secret Key...${NC}"
JWT_SECRET=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
echo -e "${GREEN}✓ Generated JWT_SECRET_KEY:${NC}"
echo -e "${BLUE}  ${JWT_SECRET}${NC}"
echo -e "${YELLOW}  → Add this to your .env file as JWT_SECRET_KEY${NC}\n"

# ============================================================================
# Display Summary
# ============================================================================
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${BLUE}Next Steps:${NC}"
echo -e "  1. Activate virtual environment:"
echo -e "     ${YELLOW}source venv/bin/activate${NC}"
echo -e ""
echo -e "  2. Edit .env file:"
echo -e "     ${YELLOW}nano .env${NC}"
echo -e "     - Add REPLICATE_API_TOKEN from https://replicate.com/account/api-tokens"
echo -e "     - Add JWT_SECRET_KEY (generated above)"
echo -e ""
echo -e "  3. Run the application:"
echo -e "     ${YELLOW}uvicorn app:app --reload${NC}"
echo -e "     or"
echo -e "     ${YELLOW}python app.py${NC}"
echo -e ""
echo -e "  4. Open API documentation:"
echo -e "     ${YELLOW}http://localhost:8000/docs${NC}"
echo -e ""
echo -e "${GREEN}Documentation: Check README.md for full details${NC}\n"
