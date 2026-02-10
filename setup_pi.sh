#!/bin/bash
# Crypto Ink Bot - Raspberry Pi Setup Script
# Run this after transferring files to Pi

set -e  # Exit on error

echo "=================================="
echo "  Crypto Ink Bot - Pi Setup"
echo "=================================="
echo ""

# 1. Install system dependencies
echo "Step 1: Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y python3-venv python3-pip libta-lib0 libta-lib0-dev build-essential

# 2. Create virtual environment
echo ""
echo "Step 2: Creating virtual environment..."
python3 -m venv .venv

# 3. Activate venv
echo ""
echo "Step 3: Activating virtual environment..."
source .venv/bin/activate

# 4. Upgrade pip
echo ""
echo "Step 4: Upgrading pip..."
pip install --upgrade pip

# 5. Install Python dependencies
echo ""
echo "Step 5: Installing Python dependencies..."
pip install -r requirements.txt

# 6. Install GPIO libraries
echo ""
echo "Step 6: Installing GPIO libraries..."
pip install RPi.GPIO lgpio

# 7. Copy waveshare library from working inkling-bot (if available)
echo ""
echo "Step 7: Installing Waveshare e-ink library..."
if [ -d "$HOME/cypher/inkling-bot/.venv/lib/python3.11/site-packages/waveshare_epd" ]; then
    echo "  Copying from existing inkling-bot installation..."
    SITE_PACKAGES=$(python -c "import site; print(site.getsitepackages()[0])")
    cp -r $HOME/cypher/inkling-bot/.venv/lib/python3.*/site-packages/waveshare_epd* "$SITE_PACKAGES/"
    echo "  ✓ Waveshare library copied"
elif [ -d "/usr/local/lib/python3.11/dist-packages/waveshare_epd" ]; then
    echo "  Copying from system installation..."
    SITE_PACKAGES=$(python -c "import site; print(site.getsitepackages()[0])")
    cp -r /usr/local/lib/python3.*/dist-packages/waveshare_epd* "$SITE_PACKAGES/"
    echo "  ✓ Waveshare library copied"
else
    echo "  Installing from GitHub (this may take a while)..."
    pip install git+https://github.com/waveshareteam/e-Paper.git#subdirectory=RaspberryPi_JetsonNano/python || {
        echo "  ⚠ Waveshare install failed - will copy manually if needed"
    }
fi

# 8. Test imports
echo ""
echo "Step 8: Testing imports..."
python -c "import talib; print('  ✓ TA-Lib OK')"
python -c "import waveshare_epd; print('  ✓ Waveshare OK')" || echo "  ⚠ Waveshare not found (display may not work)"
python -c "import RPi.GPIO; print('  ✓ RPi.GPIO OK')"
python -c "import ccxt; print('  ✓ CCXT OK')"
python -c "import anthropic; print('  ✓ Anthropic OK')"

# 9. Create .env file if it doesn't exist
echo ""
echo "Step 9: Checking .env file..."
if [ ! -f .env ]; then
    echo "  Creating .env from example..."
    cp .env.example .env
    echo "  ⚠ Edit .env and add your API keys!"
else
    echo "  ✓ .env already exists"
fi

# 10. Create config.local.yml if it doesn't exist
echo ""
echo "Step 10: Checking config.local.yml..."
if [ ! -f config.local.yml ]; then
    echo "  Creating config.local.yml..."
    cat > config.local.yml << 'EOF'
# Local configuration overrides
device:
  name: "inkling"

display:
  dark_mode: true
  height: 122
  min_refresh_interval: 1.0
  pagination_loop_seconds: 5.0
  partial_refresh: true

ai:
  primary: anthropic  # or openai, gemini, ollama
  budget:
    daily_tokens: 100000
    per_request_max: 5000

mcp:
  enabled: true
  servers:
    crypto:
      command: "python"
      args: ["mcp_servers/crypto.py"]
    system:
      command: "python"
      args: ["mcp_servers/system.py"]
EOF
    echo "  ✓ config.local.yml created"
else
    echo "  ✓ config.local.yml already exists"
fi

# Done!
echo ""
echo "=================================="
echo "  ✓ Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Edit .env and add your API keys:"
echo "     nano .env"
echo ""
echo "  2. Test the bot:"
echo "     source .venv/bin/activate"
echo "     python test_crypto_quick.py"
echo ""
echo "  3. Run in SSH mode:"
echo "     python main.py --mode ssh"
echo ""
echo "  4. Try crypto commands:"
echo "     /price BTC"
echo "     /chart BTC"
echo "     /portfolio"
echo ""
