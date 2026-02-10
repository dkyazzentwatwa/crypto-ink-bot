# Crypto Watcher Bot - Deployment Checklist

**Status**: ✅ **ALL TESTS PASSED** - Ready for Pi deployment

## What Was Tested (Mac)

### ✅ Test Results Summary
All 5 core features tested and working:

1. **Price Fetching** ✅
   - CoinGecko fallback working
   - BinanceUS for OHLCV data working
   - Multiple coin price fetching working
   - Format: `BTC $69,773.73 (-1.61%) 📉`

2. **Portfolio Management** ✅
   - Add/remove/set operations working
   - Real-time valuation working
   - Test portfolio: $39,895.34 (0.5 BTC + 2.0 ETH + 10 SOL)
   - Data stored in `~/.inkling/crypto_portfolio.json`

3. **Technical Analysis** ✅
   - TA-lib integration working
   - 19 indicators calculating correctly (RSI, MACD, BB, SMA, EMA, ATR, OBV, etc.)
   - Support/resistance detection working
   - Pattern detection working
   - Trading signals working: SELL - "Might dump, ngl"

4. **Price Alerts** ✅
   - Alert creation working
   - Alert storage working
   - Data stored in `~/.inkling/crypto_alerts.json`
   - Test alerts: BTC above $70k, BTC below $65k

5. **Watchlist** ✅
   - Default watchlist: BTC, ETH, SOL
   - Live price updates working
   - Data stored in `~/.inkling/crypto_watchlist.json`

### Changes Made for Mac Testing

**File**: `core/crypto_watcher.py`
- Changed default exchange from `binance` to `binanceus` (line 84)
- Added fallback exchange support (kraken, coinbase, bybit)
- **Action for Pi**: Binance might work on Pi, but BinanceUS is safer

## Pre-Deployment Checklist

### 1. Pi Setup
- [ ] Raspberry Pi Zero 2W ready
- [ ] 250x122 e-ink display connected
- [ ] SD card with Raspberry Pi OS
- [ ] WiFi configured (or BTBerryWifi ready)

### 2. System Dependencies (on Pi)
```bash
# Install TA-Lib system library
sudo apt-get update
sudo apt-get install -y build-essential wget
wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
tar -xzf ta-lib-0.4.0-src.tar.gz
cd ta-lib/
./configure --prefix=/usr
make
sudo make install
sudo ldconfig
```

### 3. Python Setup (on Pi)
```bash
cd /home/pi/crypto-ink-bot
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 4. Configuration
```bash
# Create .env file
cp .env.example .env
nano .env
```

Add your API keys:
```bash
ANTHROPIC_API_KEY=sk-ant-your-key-here
# Or use OpenAI, Gemini, Ollama
```

### 5. Test on Pi
```bash
# Quick test
source .venv/bin/activate
python test_crypto_quick.py

# Full test suite
python core/test_crypto.py

# SSH mode (mock display)
python main.py --mode ssh

# Try crypto commands
/price BTC
/chart BTC
/portfolio
```

### 6. Enable MCP Crypto Tools
Edit `config.local.yml`:
```yaml
mcp:
  enabled: true
  servers:
    crypto:
      command: "python"
      args: ["mcp_servers/crypto.py"]
```

### 7. Enable Scheduler (Optional)
Edit `config.local.yml`:
```yaml
scheduler:
  enabled: true
  tasks:
    - name: "morning_crypto_briefing"
      schedule: "every().day.at('07:00')"
      action: "crypto_briefing"
      enabled: true
```

## Testing Quick Reference

### Quick Test Script
```bash
source .venv/bin/activate
python test_crypto_quick.py
```

### Manual Testing
```python
import asyncio
from core.crypto_watcher import CryptoWatcher

async def test():
    async with CryptoWatcher() as watcher:
        price = await watcher.get_price('BTC')
        print(f'BTC: ${price.price_usd:,.2f}')

asyncio.run(test())
```

### SSH Mode Commands
```bash
python main.py --mode ssh

/price BTC              # Check Bitcoin price
/chart ETH 1h          # Ethereum TA analysis
/add BTC 0.01          # Add to portfolio
/portfolio             # View portfolio
/alert BTC 70000 above # Set alert
/watch                 # View watchlist
```

## Known Issues & Solutions

### Issue: Binance Blocked (451 error)
- **Solution**: Using BinanceUS as default
- **Fallback**: Kraken, Coinbase also configured

### Issue: TA-Lib import error
- **Solution**: Install system library first (see step 2)
- **Check**: `python -c "import talib; print('OK')"`

### Issue: No API keys required
- **Fact**: CoinGecko is free, no key needed
- **Fact**: BinanceUS public endpoints, no auth
- **Fact**: TA-lib calculations are local

### Issue: Rate limits
- **CoinGecko**: 10-30 calls/minute (free tier)
- **BinanceUS**: 1200 requests/minute
- **Built-in**: 30s cache TTL, 60s refresh rate

## Post-Deployment Verification

### Check Logs
```bash
tail -f ~/.inkling/logs/inkling.log | grep -i crypto
```

### Check Data Files
```bash
ls -lh ~/.inkling/crypto_*
cat ~/.inkling/crypto_portfolio.json
cat ~/.inkling/crypto_watchlist.json
cat ~/.inkling/crypto_alerts.json
```

### Monitor System
```bash
# CPU/Memory
htop

# Display refresh
# Check for errors in SSH mode output
```

## Ready to Deploy! 🚀

✅ All crypto features tested and working on Mac
✅ BinanceUS configured as primary exchange
✅ TA-lib with 19 indicators confirmed working
✅ Portfolio management verified
✅ Price alerts functional
✅ Watchlist operational

**Next steps**:
1. Copy code to Pi
2. Follow Pre-Deployment Checklist
3. Run test_crypto_quick.py on Pi
4. Start in SSH mode first
5. Test with real display

**Need help?** See:
- CRYPTO_BOT.md (complete guide)
- CRYPTO_QUICK_START.md (5-minute setup)
- CLAUDE.md (developer reference)
