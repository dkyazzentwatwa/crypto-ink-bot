# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Branch: `claude/crypto-watcher-bot-nbxGO` - Crypto Watcher Bot**

This is Project Inkling **completely transformed into a crypto watcher bot** with professional technical analysis capabilities. It is:

**A fully local AI crypto companion that:**
- 📊 **Tracks cryptocurrency prices** via ccxt (Binance primary) + CoinGecko fallback with 60s auto-refresh
- 📈 **Analyzes charts** using TA-lib (19 indicators: RSI, MACD, Bollinger Bands, SMA/EMA, patterns, support/resistance, volume indicators)
- 💰 **Manages crypto portfolios** with real-time valuation and holdings breakdown
- 🔔 **Sets price alerts** with automated checking (above/below thresholds)
- 💎 **Speaks fluent crypto slang** (gm, wagmi, ngmi, fren, ser, hodl, degen, diamond hands, paper hands, moon, pump, dump, etc.)
- 😎 **Has crypto-specific moods** - 7 moods tied to market sentiment (BULLISH, BEARISH, MOON, REKT, HODL, FOMO, DIAMOND_HANDS) + 10 base moods
- 🤖 **Uses local AI** - Anthropic/OpenAI/Gemini/Ollama APIs with automatic fallback (no cloud dependencies except APIs)
- 🛠️ **Exposes 9 MCP tools** for crypto operations (price, chart, portfolio, watchlist, alerts)
- ⏰ **Automated updates** via scheduler (morning crypto briefings, hourly price checks, TA updates)
- 💻 **Two interfaces** - Web UI (browser-based) and SSH chat mode (terminal-based)
- 🖥️ **E-ink display** with crypto-focused layout (BTC price in header, portfolio value in footer, WiFi signal)
- 🏃 **Runs on Raspberry Pi Zero 2W** with 250x122 e-ink display (portable, battery-powered)

**What Makes This Special:**
- **No task management** - Original task features completely removed/replaced with crypto tracking
- **Real technical analysis** - Uses TA-lib for professional indicators, not just price display
- **Crypto bro personality** - AI genuinely speaks like a crypto enthusiast with natural slang
- **Autonomous behavior** - Can spontaneously share market insights based on price movements and moods
- **Offline-capable** - All processing local except API calls for crypto data
- **Battery-aware** - Mood changes based on battery level (sleepy when low, energetic when charging)

**Key Files:**
- **CRYPTO_BOT.md** - Complete transformation guide (585 lines, detailed architecture)
- **CRYPTO_QUICK_START.md** - 5-minute quick start guide (180 lines)
- **core/crypto_watcher.py** - Price fetching, OHLCV data (312 lines)
- **core/crypto_ta.py** - Technical analysis engine (361 lines)
- **mcp_servers/crypto.py** - MCP server with 9 crypto tools (521 lines)

**Note**: This is a **complete transformation**, not a fork with dual functionality. All task management features have been removed and replaced with cryptocurrency tracking.

## Commands

### Pi Client (Python)
```bash
# IMPORTANT: Always use the virtual environment
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run in SSH chat mode (mock display for development)
python main.py --mode ssh

# Run web UI mode (browser at http://localhost:8081)
python main.py --mode web

# Run display demo
python main.py --mode demo

# Run with debug output
INKLING_DEBUG=1 python main.py --mode ssh

# Run tests
pytest
pytest -xvs core/test_crypto.py  # Single test file
pytest --cov=core --cov-report=html  # With coverage

# Syntax check (before committing)
python -m py_compile <file>.py
```

### Environment Variables

**Option 1: Use .env file (Recommended)**

Create a `.env` file in the project directory:

```bash
cp .env.example .env
nano .env
```

Then add your keys:

```bash
# AI Provider API Keys
ANTHROPIC_API_KEY=sk-ant-your-key-here
OPENAI_API_KEY=sk-your-key-here
GOOGLE_API_KEY=your-google-api-key-here
OLLAMA_API_KEY=your-ollama-api-key-here

# Optional
COMPOSIO_API_KEY=your-composio-key-here
SERVER_PW=your-web-password-here
INKLING_DEBUG=1  # Enable debug logging
INKLING_NO_DISPLAY_ECHO=1  # Disable ASCII display output in terminal/logs
```

**Option 2: Export manually**

```bash
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...
export GOOGLE_API_KEY=...
export OLLAMA_API_KEY=...
export COMPOSIO_API_KEY=...
export INKLING_DEBUG=1  # Enable detailed logging
export INKLING_NO_DISPLAY_ECHO=1  # Disable ASCII display output in terminal/logs
```

## Quick Crypto Reference

**Most Used Commands:**
```bash
/price BTC              # Check Bitcoin price
/chart ETH 1h          # Ethereum TA analysis (1-hour timeframe)
/portfolio             # Show portfolio value
/add BTC 0.01          # Add 0.01 BTC to portfolio
/watch                 # Show watchlist with prices
/alert BTC 70000 above # Alert when BTC goes above $70k
/top gainers           # Show top gaining coins
```

**Crypto Moods** (triggers personality changes):
- **BULLISH** 📈 - Prices going up (>5% gain)
- **BEARISH** 📉 - Prices going down (>5% loss)
- **MOON** 🚀 - Massive gains (>10% pump)
- **REKT** 💀 - Massive losses (>10% dump)
- **HODL** 💎 - Holding steady/consolidating
- **FOMO** 😱 - Fear of missing out on gains
- **DIAMOND_HANDS** 💎🙌 - Strong conviction holding

**Data Files** (all in `~/.inkling/`):
- `crypto_portfolio.json` - Your holdings ({"BTC": 0.5, "ETH": 2.3})
- `crypto_watchlist.json` - Watched coins (["BTC", "ETH", "SOL"])
- `crypto_alerts.json` - Price alerts (symbol, price, direction, triggered)

**Key Modules:**
- `core/crypto_watcher.py` - Price fetching (CryptoWatcher, CryptoPrice)
- `core/crypto_ta.py` - TA indicators (CryptoTA, TAIndicators, Signal)
- `mcp_servers/crypto.py` - 9 MCP tools for AI integration

**Testing:**
```bash
python core/test_crypto.py              # Full crypto test suite
pytest -xvs core/test_crypto.py::test_fetch_price  # Single test
INKLING_DEBUG=1 python main.py --mode ssh          # Debug mode
```

**No API Keys Required** for basic functionality:
- CoinGecko API is free (no key needed)
- Binance via ccxt (public endpoints, no auth)
- TA-lib calculations are local
- Rate limits: CoinGecko free tier = 10-30 calls/minute

## Architecture

### Pi Client Flow
```
main.py → Inkling class
    ├── DisplayManager (core/display.py) - E-ink abstraction (V3/V4/Mock)
    ├── Personality (core/personality.py) - Mood state machine (17 moods) + XP/leveling
    ├── Brain (core/brain.py) - Multi-provider AI with fallback (Anthropic/OpenAI/Gemini/Ollama)
    ├── CryptoWatcher (core/crypto_watcher.py) - Live price tracking, OHLCV data
    ├── CryptoTA (core/crypto_ta.py) - Technical analysis with TA-lib (19 indicators)
    ├── ScheduledTaskManager (core/scheduler.py) - Cron-style scheduling (crypto briefings)
    ├── Heartbeat (core/heartbeat.py) - Autonomous behaviors (price checks, mood triggers)
    └── MCPClient (core/mcp_client.py) - Model Context Protocol tool integration

modes/
    ├── ssh_chat.py - Terminal interaction with crypto commands
    └── web_chat.py - Bottle-based web UI with crypto charts and portfolio view

mcp_servers/
    ├── crypto.py - Crypto tools (price, chart, portfolio, alerts, watchlist) [9 tools]
    ├── system.py - System utilities (curl, df, free, uptime, ps, ping) [6 tools]
    └── filesystem.py - Optional file operations (read/write/list/search) [5 tools]
```

### Key Design Patterns

**Removed Features**: This is a **complete transformation** from the original Project Inkling. The following features have been removed:

**Task Management** (completely removed):
- No `/tasks`, `/task`, `/done`, `/cancel`, `/delete` commands
- No `TaskManager` class or `tasks.db` database
- No task-related MCP tools (task_create, task_list, etc.)
- No Kanban board in web UI
- **Replaced with**: Crypto tracking, portfolio management, price alerts

**Social Features** (removed in earlier version):
- No Conservatory social backend or P2P features
- No social commands (/dream, /fish, /telegram, /queue, /identity)
- No cloud synchronization
- `Identity` class (core/crypto.py) still exists but is unused (legacy code)

**New Focus**: Cryptocurrency tracking, technical analysis, portfolio management, price alerts, and crypto bro AI personality

**Multi-provider AI**: `Brain` tries Anthropic first, falls back to OpenAI, Ollama, or Gemini. All use async clients with retry logic and token budgeting.

**Conversation Persistence**: `Brain` automatically saves conversation history to `~/.inkling/conversation.json`:
- Saves after each message exchange
- Loads on startup to preserve context across restarts
- Limits to last 100 messages to prevent unbounded growth
- Deleted when user runs `/clear` command
- JSON format for human readability and debugging

**Display Rate Limiting**: E-ink displays damage with frequent refreshes. `DisplayManager` enforces minimum intervals:
- V3: 0.5s (supports partial refresh)
- V4: 5.0s (full refresh only)
- Mock: 0.5s (development)

**Display Text Rendering**: The display uses pixel-based word wrapping (`core/ui.py`):
- `word_wrap_pixels()` measures actual text width using `textbbox()` for accurate wrapping
- Handles variable-width fonts correctly
- Long words break with hyphens when they exceed max width
- Prevents text cutoff issues that occur with character-based wrapping
- Old `word_wrap()` function kept for backward compatibility (terminal output)

**Crypto-Focused UI**: The display uses a component-based layout system (`core/ui.py`):
- `HeaderBar`: Name prompt, **BTC price** (live), mood, uptime (14px)
- `MessagePanel`: Full-width message area with centered, pixel-accurate word-wrapped AI responses (86px, ~40 chars/line, 6 lines max)
- `FooterBar`: Face, level, **portfolio value**, system stats (mem/cpu/temp), WiFi signal bars, mode (22px)
  - Format: `(^_^) | L5 HODLR | $12.3k | 54%mem 1%cpu 43° | ▂▄▆█ WiFi | SSH`
- Auto-pagination: Long responses (>6 lines) automatically split into pages with 3-second transitions
- **Crypto animations**: Price pumps trigger excited faces, dumps trigger sad faces
- **Live updates**: BTC price and portfolio refresh every 60 seconds automatically

**Web UI Architecture** (`modes/web_chat.py`):
- Bottle web framework serving HTML templates (loaded from `modes/web/templates/*.html`)
- Single-page app with async/await JavaScript
- Modular command handlers in `modes/web/commands/` (see Command Handler Architecture below)
- Routes:
  - `/` - Main chat interface with crypto command shortcuts
  - `/settings` - Personality, AI config, and appearance settings
  - `/crypto` - Portfolio view with live prices and charts (planned/optional)
  - `/files` - File browser with multiple storage locations (see Storage Locations below)
- API endpoints: `/api/chat`, `/api/command`, `/api/settings`, `/api/state`, `/api/crypto/*`, `/api/files/*`
- Theme persistence: All 13 themes (10 pastel + 3 dark) must be defined in all templates
- Settings changes:
  - Personality traits: Applied immediately (no restart)
  - AI configuration: Saved to `config.local.yml`, requires restart
  - Theme: Saved to localStorage (`inklingTheme` key)
- **Crypto UI Features**:
  - Quick price check buttons (BTC, ETH, SOL)
  - Portfolio value display in header
  - Live price ticker (auto-refreshes every 60s)
  - Alert status indicators

**Web UI Template Structure**:
- Templates loaded from external files: `modes/web/templates/`
  - `main.html` - Chat interface with crypto shortcuts (805 lines)
  - `settings.html` - Settings page (personality, AI, theme) (700 lines)
  - `files.html` - File browser for crypto data and logs (874 lines)
  - `login.html` - Login page (40 lines)
  - `tasks.html` - Legacy Kanban board (1282 lines, not used in crypto version)
- CSS themes defined inline with `[data-theme="name"]` selectors
- JavaScript loads theme from `localStorage.getItem('inklingTheme')` and applies via `document.documentElement.setAttribute('data-theme', theme)`
- **Theme Consistency**: All templates must have identical theme definitions (cream, pink, mint, lavender, peach, sky, butter, rose, sage, periwinkle, dark, midnight, charcoal)
- Navigation should use `display: flex; justify-content: space-between; align-items: center` on header for consistent right-aligned nav

**Web UI Command Handler Architecture**:
- Modular command handlers in `modes/web/commands/` (crypto-focused)
- Base class: `CommandHandler` (`__init__.py`) provides access to web_mode components
  - Properties: `personality`, `display`, `brain`, `scheduler`, `_loop`, `_config`
  - Helper: `_get_face_str()` for emoji face strings
- Command modules (9 total):
  - `crypto.py` - price, chart, watch, portfolio, add, remove, alert, alerts, top
  - `play.py` - walk, dance, exercise, play, pet, rest, energy, focus
  - `info.py` - help, mood, traits, level, prestige, stats, history, thoughts
  - `session.py` - ask, clear
  - `system.py` - system, config, bash, wifi, btcfg, wifiscan, backup
  - `scheduler.py` - schedule (list/enable/disable)
  - `display.py` - face, faces, refresh, screensaver, darkmode
  - `utilities.py` - memory, settings
- Main file contains thin wrappers (2-3 lines) that delegate to handler instances
- Pattern: `def _cmd_price(self, args: str) -> Dict[str, Any]: return self._crypto_cmds.price(args)`
- Handlers return `Dict[str, Any]` with keys: `response`, `face`, `status`, optionally `error`
- Crypto handlers use `async with CryptoWatcher()` for API calls

### Storage Locations

Project Inkling supports multiple storage locations for user files:

**Inkling Data Directory** (`~/.inkling/`):
- Default location for all Inkling-managed data
- Contains: tasks.db, conversation.json, memory.db, logs, configs
- Always available

**SD Card** (optional):
- External storage for large files, backups, exports
- Auto-detected at `/media/pi/*` or `/mnt/*`, or configured manually
- Requires configuration in `config.yml` under `storage.sd_card`
- Configure in `config.local.yml`:
  ```yaml
  storage:
    sd_card:
      enabled: true
      path: "auto"  # or "/media/pi/SD_CARD" for specific path
  ```

**Filesystem MCP Access**:
- AI can access both locations via separate MCP server instances
- `filesystem-inkling` - Tools for .inkling directory (fs_list, fs_read, fs_write, fs_search, fs_info)
- `filesystem-sd` - Tools for SD card (same tool set, different base path)
- Enable in `config.yml` under `mcp.servers.*`
- Example configuration:
  ```yaml
  mcp:
    servers:
      filesystem-inkling:
        command: "python"
        args: ["mcp_servers/filesystem.py", "/home/pi/.inkling"]
      filesystem-sd:
        command: "python"
        args: ["mcp_servers/filesystem.py", "/media/pi/SD_CARD"]
  ```

**Web UI /files Page**:
- Storage selector dropdown to switch between locations
- Same browse/view/download functionality for both
- File type restrictions apply to all storage locations (.txt, .md, .csv, .json, .log)
- Auto-disables SD card option if not available

### Crypto Tracking System

**CryptoWatcher** (`core/crypto_watcher.py`): Live cryptocurrency price tracking
- **Data Sources**: Binance (primary via ccxt), CoinGecko (fallback)
- **Caching**: 30s TTL for prices, reduces API rate limits
- **Price Data**: USD price, 24h change %, volume, market cap
- **OHLCV**: Historical candlestick data for TA analysis (1m to 1d timeframes)
- **Portfolio Valuation**: Real-time portfolio worth calculation
- **Symbol Mapping**: 50+ coins (BTC, ETH, SOL, DOGE, MATIC, LINK, etc.)

**CryptoTA** (`core/crypto_ta.py`): Professional technical analysis using TA-lib
- **Trend Indicators**: SMA (20, 50, 200), EMA (12, 26), trend lines
- **Momentum Indicators**: RSI (14), MACD (12, 26, 9), Stochastic
- **Volatility Indicators**: Bollinger Bands (20, 2), ATR (14)
- **Volume Indicators**: OBV (On Balance Volume), A/D (Accumulation/Distribution)
- **Pattern Detection**: Hammer, shooting star, engulfing, doji, morning/evening star
- **Support/Resistance**: Cluster-based S/R level detection
- **Trading Signals**: STRONG_BUY, BUY, NEUTRAL, SELL, STRONG_SELL (with crypto bro messages)

**MCP Server** (`mcp_servers/crypto.py`): 9 crypto tools for AI via Model Context Protocol
- `crypto_price` - Get current price with mood indicators (pumping/dumping/hodl)
- `crypto_chart` - TA indicators, signals, patterns, S/R levels
- `crypto_portfolio` - Portfolio valuation and holdings breakdown
- `crypto_portfolio_update` - Update holdings (set/add/remove coins)
- `crypto_alert_set` - Set price alerts (above/below threshold)
- `crypto_alert_list` - List active alerts
- `crypto_alert_check` - Check if alerts triggered
- `crypto_watchlist_get` - Get watchlist with live prices
- `crypto_top` - Top gainers/losers by 24h change
- Enable in `config.yml` under `mcp.servers.crypto`

**Slash Commands**:
- `/price <symbol>` - Check current price (e.g., `/price BTC`)
- `/chart <symbol> [timeframe]` - TA indicators and patterns (e.g., `/chart ETH 1h`)
- `/watch` - List watchlist with live prices and 24h changes
- `/portfolio` - Show portfolio value and holdings breakdown
- `/add <symbol> <amount>` - Add coin to portfolio
- `/remove <symbol> <amount>` - Remove coin from portfolio
- `/alert <symbol> <price> <above|below>` - Set price alert
- `/alerts` - List all active price alerts
- `/top [gainers|losers]` - Show top moving coins

**Data Files** (`~/.inkling/`):
- `crypto_portfolio.json` - Holdings ({"BTC": 0.5, "ETH": 2.3})
- `crypto_watchlist.json` - Watched coins (["BTC", "ETH", "SOL"])
- `crypto_alerts.json` - Active alerts ([{symbol, price, direction, triggered}])

**Display Integration**:
- **Header**: Live BTC price updates every 60s
- **Footer**: Total portfolio value in USD
- **Mood Changes**: Price pumps/dumps trigger crypto moods (BULLISH, MOON, REKT)

### Scheduler System (Cron-Style Scheduling)

**ScheduledTaskManager** (`core/scheduler.py`): Time-based task scheduling with exact times
- Uses `schedule` library for cron-like functionality
- Integrates with Heartbeat (checked every 60 seconds)
- Tasks run at exact times (e.g., "daily at 2:30 PM")
- Stored in `config.yml` under `scheduler.tasks`

**Schedule Expressions**:
- Daily: `every().day.at('14:30')` - Run at 2:30 PM every day
- Hourly: `every().hour` - Run every hour on the hour
- Weekly: `every().monday.at('09:00')` - Run every Monday at 9 AM
- Interval: `every(5).minutes` - Run every 5 minutes

**Built-in Actions** (crypto-focused scheduled tasks):
- `morning_crypto_briefing` - BTC/ETH prices, top movers, portfolio summary (7 AM)
- `hourly_price_check` - Check watchlist prices and trigger alerts (every hour)
- `ta_analysis_update` - Run TA analysis on portfolio coins (every 4 hours)
- `portfolio_snapshot` - Save portfolio value for historical tracking (daily at midnight)
- `nightly_backup` - Backup crypto data (portfolio, alerts, watchlist) to SD card (3 AM)
- `system_health_check` - Monitor disk/memory/temp (2 AM)
- `weekly_cleanup` - Prune old price cache, archive triggered alerts (Sunday 2 AM)

**Full Guide**: See `docs/BACKGROUND_TASKS.md` and `docs/QUICK_START_BACKGROUND_TASKS.md`

**Slash Commands**:
- `/schedule` or `/schedule list` - List all scheduled tasks with next run times
- `/schedule enable <name>` - Enable a scheduled task
- `/schedule disable <name>` - Disable a scheduled task

**Configuration** (in `config.yml`):
```yaml
scheduler:
  enabled: true
  tasks:
    - name: "morning_summary"
      schedule: "every().day.at('08:00')"
      action: "daily_summary"
      enabled: true
    - name: "weekly_cleanup"
      schedule: "every().sunday.at('02:00')"
      action: "weekly_cleanup"
      enabled: true
```

**Adding Custom Actions**: Register actions in main.py:
```python
async def my_custom_action():
    # Your action code here
    pass

scheduler.register_action("my_action", my_custom_action)
```

### System Tools MCP Server

**SystemMCPServer** (`mcp_servers/system.py`): Lightweight Linux utility tools via MCP
- AI can use system commands without shell access
- Safe wrappers with validation and timeouts
- Enable in `config.yml` under `mcp.servers.system`

**Available Tools** (6 total):

1. **curl** - Make HTTP requests
   - Inputs: url (required), method (GET/POST), headers, body
   - Security: HTTP/HTTPS only, 1MB response limit, 5s timeout
   - Use: Check website status, fetch data, API calls

2. **df** - Disk space usage
   - Input: path (optional, default /)
   - Output: total/used/free space in GB, percent used

3. **free** - Memory usage
   - Output: RAM and swap (total/used/available in MB, percent)

4. **uptime** - System uptime
   - Output: uptime string, load averages (1/5/15 min)

5. **ps** - Process listing
   - Inputs: filter (name substring), limit (default 10)
   - Output: PID, name, CPU%, memory%, command
   - Sorted by CPU usage descending

6. **ping** - Network connectivity
   - Input: host (hostname or IP)
   - Output: reachable (bool), latency (ms), IP address
   - Tests ports 80 and 443 (HTTP/HTTPS)

**Dependencies**: Requires `psutil>=5.9.0` and `requests>=2.31.0`

**Token Budget**: ~50-100 tokens per tool × 6 = 300-600 tokens (well within 20-tool limit)

### Remote Access (Ngrok)

**Status**: Fully implemented and supported

Project Inkling supports secure remote access via ngrok tunneling. Access the web UI from anywhere while keeping the device local.

**Setup**:

1. Add to `config.local.yml`:
```yaml
network:
  ngrok:
    enabled: true
    auth_token: "your_ngrok_token"  # Optional, for custom domains
```

2. Set password protection (recommended for public URLs):
```bash
export SERVER_PW="your-secure-password"
```

3. Start web mode:
```bash
python main.py --mode web
```

You'll see:
```
🌐 Ngrok tunnel: https://xxxx.ngrok.io
🔐 Password protection enabled
```

**Security**:
- Always use `SERVER_PW` when ngrok is enabled
- Ngrok free tier has session limits (~2 hours)
- Paid ngrok plans support custom domains and longer sessions
- Web UI requires password authentication when `SERVER_PW` is set

### Remote Claude Code (SSH Bridge)

**Status**: Fully implemented (config-only, no code changes needed)

Inkling can control Claude Code running on your MacBook via SSH. This gives the AI access to
Bash, Read, Write, Edit, Grep, and Glob tools on your Mac through natural conversation.

**Architecture**: Inkling's MCP client spawns `ssh` as a subprocess → SSH connects to Mac →
runs `claude mcp serve` → stdio piped back over encrypted SSH tunnel.

**Quick Setup**:
1. Enable Remote Login on Mac (System Settings → Sharing)
2. Generate SSH key on Pi: `ssh-keygen -t ed25519 -f ~/.ssh/inkling_macbook -N ""`
3. Copy key to Mac: `ssh-copy-id -i ~/.ssh/inkling_macbook.pub user@YourMac.local`
4. Add SSH host alias to `~/.ssh/config` on Pi
5. Add to `config.local.yml`:
```yaml
mcp:
  servers:
    macbook-claude:
      command: "ssh"
      args: ["macbook", "claude", "mcp", "serve"]
```

**Security**: Ed25519 key auth, forced command restriction in `authorized_keys`,
optional dedicated macOS user, firewall to Pi's IP only.

**Full guide**: See `docs/guides/REMOTE_CLAUDE_CODE.md`

**Limitation**: No MCP passthrough — only Claude Code's built-in tools are exposed,
not other MCP servers configured on your Mac. Bridge those individually via separate SSH entries.

### WiFi Configuration (BTBerryWifi)

**Status**: Fully implemented and supported

Project Inkling supports WiFi configuration via Bluetooth for portable use. Uses BTBerryWifi for BLE-based network setup without keyboard/monitor.

**Setup**:

1. Install BTBerryWifi on Raspberry Pi:
```bash
curl -L https://raw.githubusercontent.com/nksan/Rpi-SetWiFi-viaBluetooth/main/btwifisetInstall.sh | bash
```

2. Download mobile app:
   - iOS: https://apps.apple.com/app/btberrywifi/id6479825660
   - Android: https://play.google.com/store/apps/details?id=com.bluetoothwifisetup

3. Service behavior:
   - Runs automatically for 15 minutes on boot
   - Can be started manually with `/btcfg` command
   - Times out after 15 minutes to conserve battery

**WiFi Commands**:
- `/wifi` - Show current WiFi status, saved networks, IP address, BLE service status
- `/btcfg` - Start BLE configuration service for 15 minutes
- `/wifiscan` - Scan for nearby WiFi networks with signal strength and security

**Display Integration**:
- WiFi signal bars shown in footer: `▂▄▆█` (excellent), `▂▄▆` (good), `▂▄` (fair), `▂` (poor), `○` (very poor)
- Automatically updates when network changes
- DisplayContext includes `wifi_ssid` and `wifi_signal` fields

**Implementation Files**:
- `core/wifi_utils.py` - WiFi utility functions (get_current_wifi, scan_networks, start_btcfg, etc.)
- `core/commands.py` - Command definitions (wifi, btcfg, wifiscan)
- `modes/ssh_chat.py` - SSH command handlers (cmd_wifi, cmd_btcfg, cmd_wifiscan)
- `modes/web_chat.py` - Web command handlers (_cmd_wifi, _cmd_btcfg, _cmd_wifiscan)
- `core/ui.py` - Display integration (DisplayContext, FooterBar)
- `core/display.py` - WiFi status retrieval in render loop

**Use Cases**:
- Travel: Configure WiFi at hotels, airports, friend's houses
- Network switching: Easily switch between home, work, mobile hotspot
- Headless setup: No keyboard/monitor needed for network configuration

### Available Slash Commands

All commands defined in `core/commands.py` and available in both SSH and web modes (35 total):

**Crypto Commands** (9 core features):
- `/price <symbol>` - Check current price for a cryptocurrency (e.g., `/price BTC`)
- `/chart <symbol> [timeframe]` - Show TA indicators and patterns (e.g., `/chart ETH 1h`)
- `/watch` - List watched cryptocurrencies with live prices
- `/portfolio` - Show portfolio value and holdings breakdown
- `/add <symbol> <amount>` - Add coin to portfolio (e.g., `/add BTC 0.5`)
- `/remove <symbol> <amount>` - Remove coin from portfolio
- `/alert <symbol> <price> <above|below>` - Set price alert (e.g., `/alert BTC 70000 above`)
- `/alerts` - List all active price alerts
- `/top [gainers|losers]` - Show top gaining/losing coins

**Info & Status**:
- `/help` - Show all available commands
- `/level` - Show XP, progression, and achievements
- `/prestige` - Reset level with XP bonus (prestige system)
- `/stats` - Show AI token usage statistics
- `/history` - Show recent conversation messages
- `/thoughts` - Show recent autonomous thoughts
- `/memory` - Show memory stats and entries

**Personality**:
- `/mood` - Show current mood and intensity (includes crypto moods: BULLISH, BEARISH, MOON, REKT, HODL, FOMO, DIAMOND_HANDS)
- `/energy` - Show energy level (0-100%)
- `/traits` - Show personality traits (curiosity, cheerfulness, verbosity, playfulness, empathy, independence)

**Play Commands** (award XP):
- `/walk` - Go for a walk (+3 XP, boosts energy)
- `/dance` - Dance around (+5 XP, boosts energy)
- `/exercise` - Exercise and stretch (+5 XP, boosts energy)
- `/play` - Play with a toy (+4 XP, boosts mood)
- `/pet` - Get petted (+3 XP, boosts mood)
- `/rest` - Take a short rest (+2 XP, calms down)
- `/focus` - Manage focus/pomodoro sessions

**Scheduler**:
- `/schedule` or `/schedule list` - List all scheduled tasks (morning briefings, price checks, backups)
- `/schedule enable <name>` - Enable a scheduled task
- `/schedule disable <name>` - Disable a scheduled task

**System**:
- `/system` - Show system stats (CPU, memory, temp, uptime)
- `/config` - Show AI configuration (model, provider, token limits)
- `/bash <command>` - Run a shell command (requires permission)
- `/settings` - Show current settings (SSH mode)
- `/backup` - Create backup of crypto data (portfolio, alerts, watchlist)

**WiFi**:
- `/wifi` - Show WiFi status, saved networks, signal strength
- `/btcfg` - Start BLE WiFi configuration service (15 min timeout)
- `/wifiscan` - Scan for nearby WiFi networks with signal strength

**Display**:
- `/face <name>` - Test a face expression (e.g., `/face bullish`)
- `/faces` - List all available faces
- `/refresh` - Force display refresh (respects rate limits)
- `/screensaver` - Toggle screensaver on/off
- `/darkmode` - Toggle dark mode (inverted display)

**Session** (SSH only):
- `/ask <message>` - Explicit chat command (use AI brain)
- `/clear` - Clear conversation history (deletes conversation.json)
- `/quit` or `/exit` - Exit SSH chat session

### Autonomous Behaviors (Heartbeat System)

**Heartbeat** (`core/heartbeat.py`): Makes Inkling "alive" with autonomous actions
- Tick interval: Configurable (default 60s)
- Behavior types (can be toggled):
  - **Mood behaviors**: Reach out when lonely, suggest activities when bored
  - **Time behaviors**: Morning greetings, evening wind-down
  - **Maintenance**: Memory pruning, task reminders
- Quiet hours: Suppress spontaneous messages (default 11pm-7am)
- Enable/disable in `config.yml` under `heartbeat.*`
- Integrates with Scheduler to check for scheduled tasks

## Configuration

Copy `config.yml` to `config.local.yml` for local overrides. Key settings:
- `device.name`: Device name (editable via web UI)
- `display.type`: `auto`, `v3`, `v4`, or `mock`
- `ai.primary`: `anthropic`, `openai`, `gemini`, or `ollama`
- `ai.anthropic.model`: Model selection (claude-haiku-4-5/claude-sonnet-4-5/claude-opus-4-5)
- `ai.openai.model`: Model selection (gpt-5-mini/gpt-5.2)
- `ai.gemini.model`: Model selection (gemini-2.0-flash-exp/gemini-1.5-flash/gemini-1.5-pro)
- `ai.ollama.model`: Model selection (qwen3-coder-next/kimi-k2.5/ministral-3:8b-cloud/rnj-1:8b-cloud/nemotron-3-nano:30b-cloud/gemini-3-flash-preview:cloud/glm-4.7:cloud/gpt-oss:120b-cloud/gpt-oss:20b-cloud)
- `ai.ollama.base_url`: Ollama API URL (default: https://ollama.com/api for cloud, http://localhost:11434/api for local)
- `ai.budget.daily_tokens`: Daily token limit (default 10000)
- `ai.budget.per_request_max`: Max tokens per request (default 500)
- `personality.*`: Base trait values (curiosity, cheerfulness, verbosity, playfulness, empathy, independence - 0.0-1.0)
- `heartbeat.enabled`: Enable autonomous behaviors (default true)
- `heartbeat.tick_interval`: Check interval in seconds (default 60)
- `heartbeat.enable_mood_behaviors`: Mood-driven actions (default true)
- `heartbeat.enable_time_behaviors`: Time-based greetings (default true)
- `heartbeat.quiet_hours_start/end`: Suppress spontaneous messages (default 23-7)
- `scheduler.enabled`: Enable cron-style scheduled tasks (default true)
- `scheduler.tasks`: List of scheduled tasks with name, schedule, action, enabled
- `mcp.enabled`: Enable Model Context Protocol servers (default true)
- `mcp.max_tools`: Maximum tools to load (default 20, OpenAI limit 128)
- `mcp.servers.*`: Configure MCP servers (tasks, system, filesystem, etc.)
- `network.ngrok.enabled`: Enable ngrok tunnel for remote access (default false)
- `network.ngrok.auth_token`: Ngrok auth token for custom domains (optional)

**Web UI Settings** (`http://localhost:8081/settings`):
- **Instant Apply** (no restart): Device name, personality traits (6 sliders), color theme
- **Requires Restart**: AI provider, model selection, token limits
- All changes automatically saved to `config.local.yml`

## Core Modules Reference

| Module | Purpose | Key Classes/Functions |
|--------|---------|----------------------|
| **Crypto Modules** | | |
| `core/crypto_watcher.py` | Live price tracking | `CryptoWatcher`, `CryptoPrice`, OHLCV data, Binance/CoinGecko APIs |
| `core/crypto_ta.py` | Technical analysis | `CryptoTA`, `TAIndicators`, `Signal`, pattern detection, S/R levels |
| `core/test_crypto.py` | Crypto test suite | Comprehensive tests for price, OHLCV, TA, patterns, portfolio |
| `mcp_servers/crypto.py` | Crypto MCP tools | 9 tools: price, chart, portfolio, watchlist, alerts, top coins |
| **Core AI & Personality** | | |
| `core/brain.py` | Multi-provider AI | `Brain` class, async chat, token budgeting, conversation persistence |
| `core/personality.py` | Mood & traits | `Personality`, 17 moods (10 base + 7 crypto), crypto bro system prompt |
| `core/progression.py` | XP & leveling | `Progression`, `XPSource` enum, achievements, prestige |
| `core/memory.py` | Conversation memory | Summarization, context pruning, semantic search |
| **System & Display** | | |
| `core/display.py` | E-ink abstraction | `DisplayManager`, V3/V4/Mock drivers, rate limiting |
| `core/ui.py` | Display layout | `HeaderBar` (BTC price), `FooterBar` (portfolio), `MessagePanel`, crypto animations |
| `core/commands.py` | Slash commands | 35 commands (9 crypto, 26 utility), category grouping |
| **Automation** | | |
| `core/heartbeat.py` | Autonomous behaviors | `Heartbeat`, mood-based actions, time-based triggers |
| `core/scheduler.py` | Cron-style scheduling | `ScheduledTaskManager`, crypto briefings, price checks |
| **Network & Storage** | | |
| `core/wifi_utils.py` | WiFi management | `get_current_wifi()`, `scan_networks()`, `start_btcfg()`, signal bars |
| `core/storage.py` | Storage detection | SD card detection, storage availability, backup paths |
| `core/mcp_client.py` | MCP tool integration | `MCPClient`, tool discovery, async tool calls, 20-tool limit |
| **Legacy/Unused** | | |
| `core/crypto.py` | Identity (unused) | `Identity`, Ed25519 keypair - legacy from removed social features |
| **Other MCP Servers** | | |
| `mcp_servers/system.py` | System tools MCP | curl, df, free, uptime, ps, ping utilities |
| `mcp_servers/filesystem.py` | Filesystem MCP | File operations (list, read, write, search, info) |

## Database & File Storage

**Local Data Directory** (`~/.inkling/`):
- **Crypto Data** (JSON files managed by CryptoMCPServer):
  - `crypto_portfolio.json`: Portfolio holdings (symbol → amount mapping)
  - `crypto_watchlist.json`: Watched coins list (default: BTC, ETH, SOL)
  - `crypto_alerts.json`: Active price alerts (symbol, price, direction, triggered status)
- **AI & Personality** (managed by Brain/Personality):
  - `conversation.json`: Chat history (last 100 messages, auto-saved after each message)
  - `personality.json`: Personality state (traits, mood, XP, level, social stats)
  - `memory.db`: Conversation summaries (SQLite, created by Memory)
- **Legacy** (no longer used but may exist):
  - `tasks.db`: Task manager storage (from pre-crypto version)

## Important Implementation Notes

**Display Text Rendering**:
- AI response text in `MessagePanel` uses `word_wrap_pixels()` for pixel-accurate wrapping
- Measures actual text width using `textbbox()` to handle variable-width fonts
- Long words break with hyphens when exceeding max width
- Text is centered both horizontally (per line) and vertically (as block)
- Auto-pagination: `display.show_message_paginated()` splits long messages into pages with 3-second delay

**Face Preference**:
- E-ink displays (V3/V4): Use ASCII faces from `FACES` (better rendering on e-ink)
- Mock/Web displays: Use Unicode faces from `UNICODE_FACES` (prettier appearance)
- Set via `DisplayManager._prefer_ascii_faces`

**Async/Sync Bridge**: Web mode (`web_chat.py`) runs Bottle in a thread with an async event loop. Use `asyncio.run_coroutine_threadsafe()` to call async methods from sync Bottle handlers.

**Personality State**: `Personality` class tracks:
- `traits`: Editable via settings (curiosity, cheerfulness, verbosity, playfulness, empathy, independence)
- `mood`: Runtime state machine with **17 moods**:
  - **Base moods** (10): happy, excited, curious, bored, sad, sleepy, grateful, lonely, intense, cool
  - **Crypto moods** (7): BULLISH, BEARISH, MOON, REKT, HODL, FOMO, DIAMOND_HANDS
- `progression`: XP/leveling system with achievements and prestige
- **Crypto personality**: System prompt includes crypto bro language, slang, emojis (🚀📈📉💀💎🙌)

**Crypto Slang Glossary** (used by AI in responses):
- **gm** - Good morning (crypto greeting)
- **wagmi** - We're All Gonna Make It (bullish sentiment)
- **ngmi** - Not Gonna Make It (bearish sentiment, used for bad decisions)
- **fren** / **ser** - Friend / Sir (casual crypto speak)
- **hodl** - Hold On for Dear Life (holding coins long-term)
- **diamond hands** 💎🙌 - Strong conviction, won't sell
- **paper hands** 📄🙌 - Weak conviction, sells on dips
- **moon** 🚀 - Massive price increase
- **pump** / **dump** - Sharp price increase / decrease
- **degen** - Degenerate trader (high-risk, aggressive trading)
- **ape in** - Buy aggressively without research
- **rekt** - Wrecked, massive losses
- **shill** - Promote a coin heavily
- **fud** - Fear, Uncertainty, Doubt (negative news/sentiment)
- **dyor** - Do Your Own Research
- **btfd** - Buy The F***ing Dip
- **whale** 🐋 - Large holder with market influence
- **bag holder** - Stuck holding coins at a loss
- **to the moon** 🚀🌙 - Expecting massive gains
- **lambo when?** 🏎️ - When will we get rich?

**Crypto Data Updates**:
- Prices cached for 30s (TTL), auto-refresh every 60s on display
- Portfolio valuation calculated on-demand using live prices
- TA indicators require 100+ candles for accuracy (RSI, MACD need history)
- Alerts checked every scheduler tick (configurable, default 60s)

**Config File Management**: When saving settings via web UI:
1. Load existing `config.local.yml` (or create empty dict)
2. Update only changed sections (`device.name`, `personality.*`, `ai.*`)
3. Write back with `yaml.dump()` preserving other settings
4. AI settings require restart; personality changes apply immediately

**MCP Integration**: Inkling can use external tools via Model Context Protocol
- Built-in servers:
  - `crypto` (crypto tracking) - Python-based, 9 tools, always available
  - `system` (Linux utilities) - Python-based, 6 safe tools
  - `filesystem` (file operations) - Python-based, optional (see docs/guides/FILESYSTEM_MCP.md)
- Third-party servers: Composio (500+ app integrations), fetch, memory, brave-search, etc.
- **Composio integration**: Google Calendar, Gmail, Google Sheets, Notion, GitHub, Slack, etc.
  - HTTP transport with SSE (Server-Sent Events) support
  - Set `COMPOSIO_API_KEY` environment variable
  - Enable in `config.yml` under `mcp.servers.composio`
- **Remote Claude Code**: SSH bridge to Claude Code on MacBook (see docs/guides/REMOTE_CLAUDE_CODE.md)
  - Exposes Bash, Read, Write, Edit, Grep, Glob on remote Mac
  - Ed25519 key auth with forced command hardening
  - Config-only setup: `command: "ssh"`, `args: ["macbook", "claude", "mcp", "serve"]`
- **Tool limiting**: Set `mcp.max_tools` to limit total tools (default: 20)
  - Built-in tools prioritized over third-party
  - OpenAI has hard limit of 128 tools
- Enable in `config.yml` under `mcp.servers.*`

**Web UI Template Structure** (`modes/web_chat.py`):
- Templates are embedded as string constants (HTML_TEMPLATE, SETTINGS_TEMPLATE, TASKS_TEMPLATE, FILES_TEMPLATE)
- Use Bottle's `template()` function with simple variable substitution: `{{name}}`, `{{int(value)}}`
- JavaScript in templates uses async/await for API calls
- Theme support via CSS variables and `data-theme` attribute
- **Theme Consistency Critical**: All 13 themes must be defined identically in all templates
- Keep templates self-contained (inline CSS and JS)
- When adding new routes, define template constant then use: `template(YOUR_TEMPLATE, name=self.personality.name, ...)`

## Common Development Patterns

**Adding a New Crypto Command**:
1. Add command metadata to `COMMANDS` list in `core/commands.py` with category "crypto"
2. Implement handler method in mode files:
   - SSH: `async def cmd_mycommand(self, args: str = "") -> None` in `modes/ssh_chat.py`
   - Web: `def _cmd_mycommand(self, args: str = "") -> Dict[str, Any]` in `modes/web_chat.py`
3. Command handlers are auto-detected using `inspect.signature()`:
   - If handler has `args` parameter without default value, args are passed automatically
   - No need to maintain hardcoded list of commands that need args
4. Web handler returns `Dict[str, Any]` with keys: `response`, `face`, `status`, optionally `error`
5. For crypto commands, use `CryptoWatcher` context manager for API calls:
   ```python
   async with CryptoWatcher() as watcher:
       price = await watcher.get_price("BTC")
   ```

**Adding a New Crypto MCP Tool**:
1. Add tool method to `CryptoMCPServer` in `mcp_servers/crypto.py`
2. Add tool schema to `get_tool_schemas()` method
3. Add tool to `call_tool()` dispatcher
4. Brain will auto-discover on startup if `mcp.enabled: true`
5. Example pattern:
   ```python
   async def crypto_my_tool(self, symbol: str) -> Dict[str, Any]:
       async with CryptoWatcher() as watcher:
           data = await watcher.get_something(symbol)
           return {"result": data}
   ```

**Adding a New Technical Indicator**:
1. Add indicator calculation to `CryptoTA` class in `core/crypto_ta.py`
2. Add indicator field to `TAIndicators` dataclass
3. Update `calculate_indicators()` to compute new indicator
4. Update `get_signal()` to incorporate new indicator into trading signal
5. Add indicator to `format_indicators()` for display
6. Requires TA-lib installed: `pip install TA-Lib`

**Adding a New Crypto Mood**:
1. Add mood to `Mood` enum in `core/personality.py`
2. Add face mapping in `MOOD_FACES` dict
3. Add energy level in `MOOD_ENERGY` dict
4. Update `get_system_prompt_context()` with mood description
5. Add transition logic in `Personality._natural_mood_decay()` if needed
6. Optionally add crypto-specific triggers (e.g., price pump → MOON mood)

**Adding a New XP Source**:
1. Add enum value to `XPSource` in `core/progression.py`
2. Define XP amount in `XP_REWARDS` dict
3. Call `personality.progression.award_xp(XPSource.YOUR_SOURCE)` when event occurs
4. Optionally add achievement in `ACHIEVEMENTS` dict
5. Examples: crypto trade executed, alert triggered, streak maintained

**Triggering Mood Changes from Price Action**:
1. Fetch price using `CryptoWatcher.get_price()`
2. Check price change percentage: `price.price_change_24h`
3. Call `personality.on_success()` for pumps (positive change)
4. Call `personality.on_failure()` for dumps (negative change)
5. For extreme moves, set mood directly:
   ```python
   if price.price_change_24h > 10:
       personality.mood.set_mood(Mood.MOON, 0.9)
   elif price.price_change_24h < -10:
       personality.mood.set_mood(Mood.REKT, 0.9)
   ```

**Adding a New Web UI Theme**:
1. Add theme definition to ALL templates (HTML_TEMPLATE, SETTINGS_TEMPLATE, TASKS_TEMPLATE, FILES_TEMPLATE)
2. Format: `[data-theme="name"] { --bg: #color; --text: #color; --border: #color; --muted: #color; --accent: #color; }`
3. Add option to Settings page theme dropdown
4. Test theme persistence across all pages

**Modifying Web UI**:
1. For existing pages: Edit template constant in `modes/web_chat.py`
2. For new pages: Create template constant, add route with `@self._app.route()`
3. API endpoints: Add route with JSON response using `response.content_type = "application/json"`
4. Test with `python main.py --mode web` and visit `http://localhost:8081`

## Troubleshooting

**Import Errors**:
- Always activate venv: `source .venv/bin/activate`
- Reinstall dependencies: `pip install -r requirements.txt`

**Display Not Working**:
- Check `config.local.yml` has `display.type: mock` for development
- For real hardware, ensure SPI is enabled and display connected properly

**AI Not Responding**:
- Verify API key in `config.local.yml` or environment variable
- Check token budget not exceeded: use `/stats` command
- Enable debug mode: `INKLING_DEBUG=1 python main.py --mode ssh`

**Web UI Not Loading**:
- Check port 8081 is not in use
- Verify Bottle is installed: `pip show bottle`
- Check browser console for JavaScript errors

**Theme Not Persisting**:
- Verify all templates have identical theme definitions (13 total)
- Check browser localStorage for `inklingTheme` key
- Clear browser cache and retry

**Task Manager Not Working**:
- Ensure MCP is enabled: `mcp.enabled: true` in config
- Check tasks server configured: `mcp.servers.tasks` exists
- Verify `~/.inkling/tasks.db` has write permissions

**Conversation History Lost**:
- Check `~/.inkling/conversation.json` exists and has write permissions
- Verify `Brain.save_messages()` is called after chat responses
- Enable debug mode to see save/load messages

**WiFi Not Working**:
- Check interface name: `ip link show` (should show `wlan0`)
- Verify WiFi adapter is enabled: `sudo rfkill list` (should not show "Soft blocked")
- BTBerryWifi not installed: Run installation script (see WiFi Configuration section)
- Permission denied on scan: `/wifiscan` requires sudo permissions for `iwlist`
- BLE service won't start: Check Bluetooth is enabled (`sudo systemctl status bluetooth`)

**WiFi Display Not Updating**:
- Display refresh rate limited (V3: 0.5s, V4: 5.0s)
- WiFi check is non-blocking and fails gracefully
- Check logs for WiFi utility errors: `INKLING_DEBUG=1 python main.py --mode ssh`

**Crypto Features Not Working**:
- Check API keys not required (CoinGecko is free, no key needed)
- Test price fetching: `python core/test_crypto.py`
- Verify ccxt installed: `pip show ccxt`
- Check CoinGecko rate limits: 10-30 calls/minute for free tier
- TA-lib not installed: `brew install ta-lib` (macOS) or `sudo apt install libta-lib-dev` (Linux), then `pip install TA-Lib`
- Enable debug mode: `INKLING_DEBUG=1 python main.py --mode ssh`

**Price Data Inaccurate**:
- Binance API may be blocked in some regions (automatically falls back to CoinGecko)
- CoinGecko free tier has 5-minute price delays
- Check cache TTL: Default 30s, may show stale data briefly
- Force refresh: Use `/refresh` command or restart
- Symbol not found: Use standard symbols (BTC not BITCOIN, ETH not ETHER)

**TA Indicators Not Showing**:
- Requires 100+ candles for accurate calculation (RSI, MACD need historical data)
- Check timeframe: 1m/5m/15m/1h/4h/1d (default 1h)
- Verify TA-lib installed: `python -c "import talib; print('OK')"`
- Some indicators may be None if insufficient data
- Pattern detection needs at least 50 candles

**Portfolio Not Calculating**:
- Check portfolio file exists: `~/.inkling/crypto_portfolio.json`
- Verify JSON format: `{"BTC": 0.5, "ETH": 2.3}` (symbol → amount)
- Use `/add` command to add first coins
- Portfolio value requires live prices (may fail if API down)
- Check logs: `tail -f ~/.inkling/logs/inkling.log`

**Alerts Not Triggering**:
- Alerts checked every scheduler tick (default 60s)
- Check scheduler enabled: `scheduler.enabled: true` in config
- Verify alerts file: `~/.inkling/crypto_alerts.json`
- Use `/alerts` to see all alerts and their status
- Triggered alerts stay in list until manually removed (shows "✓ TRIGGERED" status)

## Testing Crypto Features

**Quick smoke test:**
```bash
# Activate venv
source .venv/bin/activate

# Test price fetching (runs all crypto tests)
python core/test_crypto.py

# Test specific module
pytest -xvs core/test_crypto.py::test_fetch_price
pytest -xvs core/test_crypto.py::test_ta_indicators
pytest -xvs core/test_crypto.py::test_portfolio_valuation

# SSH mode - interactive testing
python main.py --mode ssh
> /price BTC          # Check Bitcoin price
> /chart ETH 1h       # TA analysis on Ethereum 1-hour chart
> /add BTC 0.01       # Add 0.01 BTC to portfolio
> /portfolio          # See portfolio value
> /watch              # Check watchlist prices
> /alert BTC 70000 above  # Set alert for BTC above $70k
> /alerts             # List all alerts
> /top gainers        # Show top gaining coins

# Web mode - browser testing
python main.py --mode web
# Visit http://localhost:8081
# Use same commands in chat interface
```

**Manual API testing:**
```python
# Test CryptoWatcher directly
import asyncio
from core.crypto_watcher import CryptoWatcher

async def test():
    async with CryptoWatcher() as watcher:
        price = await watcher.get_price("BTC")
        print(f"BTC: ${price.price_usd:,.2f} ({price.price_change_24h:+.2f}%)")
        print(f"Mood: {price.mood}")

asyncio.run(test())

# Test CryptoTA
from core.crypto_ta import CryptoTA
ta = CryptoTA()
# Requires OHLCV data first
```

**Enable crypto MCP tools:**
```yaml
# config.local.yml
mcp:
  enabled: true
  max_tools: 20
  servers:
    crypto:
      command: "python"
      args: ["mcp_servers/crypto.py"]
```

**Check crypto data files:**
```bash
# View portfolio
cat ~/.inkling/crypto_portfolio.json

# View watchlist
cat ~/.inkling/crypto_watchlist.json

# View alerts
cat ~/.inkling/crypto_alerts.json

# View logs
tail -f ~/.inkling/logs/inkling.log | grep -i crypto
```

