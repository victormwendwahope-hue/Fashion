@echo off
REM ============================================================================
REM Fashion Try-On Platform - Windows Setup Script
REM ============================================================================
REM Usage: setup.bat
REM This script sets up the complete development environment on Windows
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ========================================
echo Fashion Try-On Platform - Setup
echo ========================================
echo.

REM ============================================================================
REM Check Python Installation
REM ============================================================================
echo [1/6] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found. Please install Python 3.9 or higher.
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [OK] Python %PYTHON_VERSION% found
echo.

REM ============================================================================
REM Create Virtual Environment
REM ============================================================================
echo [2/6] Creating virtual environment...
if not exist "venv" (
    python -m venv venv
    echo [OK] Virtual environment created
) else (
    echo [OK] Virtual environment already exists
)

call venv\Scripts\activate.bat
echo [OK] Virtual environment activated
echo.

REM ============================================================================
REM Upgrade pip
REM ============================================================================
echo [3/6] Upgrading pip...
python -m pip install --upgrade pip setuptools wheel >nul 2>&1
echo [OK] pip upgraded
echo.

REM ============================================================================
REM Install Dependencies
REM ============================================================================
echo [4/6] Installing dependencies...
echo This may take a few minutes...
pip install ^
    fastapi==0.104.1 ^
    uvicorn[standard]==0.24.0 ^
    python-multipart==0.0.6 ^
    pillow==10.1.0 ^
    replicate==0.20.0 ^
    nudenet==2.0.8 ^
    opencv-python-headless==4.8.1.78 ^
    mediapipe==0.10.9 ^
    rembg==2.0.57 ^
    requests==2.31.0 ^
    sqlalchemy==2.0.23 ^
    python-jose[cryptography]==3.3.0 ^
    passlib[bcrypt]==1.7.4 ^
    python-dotenv==1.0.0 ^
    pydantic==2.5.0 ^
    pydantic-settings==2.1.0 ^
    slowapi==0.1.9 ^
    boto3==1.28.85

echo [OK] All dependencies installed
echo.

REM ============================================================================
REM Setup Environment Configuration
REM ============================================================================
echo [5/6] Setting up environment configuration...
if not exist ".env" (
    copy .env.example .env >nul
    echo [OK] .env file created from .env.example
    echo Please edit .env and add your API keys:
    echo   - REPLICATE_API_TOKEN (required)
    echo   - JWT_SECRET_KEY (generate one below)
    echo.
) else (
    echo [OK] .env file already exists
    echo.
)

REM ============================================================================
REM Generate JWT Secret
REM ============================================================================
echo [6/6] Generating JWT Secret Key...
for /f "delims=" %%i in ('python -c "import secrets; print(secrets.token_urlsafe(32))"') do set JWT_SECRET=%%i
echo [OK] Generated JWT_SECRET_KEY:
echo %JWT_SECRET%
echo Add this to your .env file as JWT_SECRET_KEY
echo.

REM ============================================================================
REM Display Summary
REM ============================================================================
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next Steps:
echo   1. Edit .env file with your API keys
echo      - REPLICATE_API_TOKEN: https://replicate.com/account/api-tokens
echo      - JWT_SECRET_KEY: %JWT_SECRET%
echo.
echo   2. Run the application:
echo      uvicorn app:app --reload
echo.
echo   3. Open API documentation:
echo      http://localhost:8000/docs
echo.
echo Documentation: Check README.md for full details
echo.
pause
