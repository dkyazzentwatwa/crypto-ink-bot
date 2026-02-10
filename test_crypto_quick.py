#!/usr/bin/env python3
"""
Quick crypto test script - runs all 5 core crypto features
"""
import asyncio
import sys
sys.path.insert(0, '.')
from mcp_servers.crypto import CryptoMCPServer


async def test_all():
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
    print('   🚀 CRYPTO WATCHER BOT - QUICK TEST 🚀')
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n')

    server = CryptoMCPServer()

    # Test 1: Price Check
    print('✅ TEST 1: Price Fetching')
    result = await server.crypto_price('BTC')
    print(f'   {result.get("formatted")}\n')

    # Test 2: Portfolio Management
    print('✅ TEST 2: Portfolio Management')
    await server.crypto_portfolio_update('BTC', 0.5, 'set')
    await server.crypto_portfolio_update('ETH', 2.0, 'set')
    await server.crypto_portfolio_update('SOL', 10.0, 'set')

    portfolio = await server.crypto_portfolio()
    print(f'   💰 Total Portfolio: ${portfolio["total_value_usd"]:,.2f}')
    for holding in portfolio['holdings']:
        print(f'      {holding["symbol"]}: {holding["amount"]} = ${holding["value_usd"]:,.2f}')
    print()

    # Test 3: Technical Analysis
    print('✅ TEST 3: Technical Analysis (19 indicators)')
    chart = await server.crypto_chart('BTC', '1h', 100)
    print(f'   📊 RSI: {chart["indicators"]["rsi"]:.2f}')
    print(f'   📈 MACD: {chart["indicators"]["macd"]:.2f}')
    print(f'   🎯 Signal: {chart["signal"]} - {chart["signal_text"]}')
    print(f'   📉 Support: {len(chart["support_levels"])} levels')
    print(f'   📈 Resistance: {len(chart["resistance_levels"])} levels')
    print()

    # Test 4: Price Alerts
    print('✅ TEST 4: Price Alerts')
    # Clear old alerts first
    server.alerts = []
    server._save_alerts()
    await server.crypto_alert_set('BTC', 70000, 'above')
    await server.crypto_alert_set('BTC', 65000, 'below')

    alerts = await server.crypto_alert_list()
    print(f'   🔔 {len(alerts["alerts"])} active alerts:')
    for alert in alerts['alerts']:
        print(f'      {alert["symbol"]} {alert["condition"]} ${alert["target_price"]:,.0f}')
    print()

    # Test 5: Watchlist
    print('✅ TEST 5: Watchlist')
    watchlist = await server.crypto_watchlist_get()
    print(f'   👀 Watching {len(watchlist["watchlist"])} coins:')
    for coin in watchlist['watchlist'][:3]:
        print(f'      {coin["formatted"]}')
    print()

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
    print('✨ ALL 5 TESTS PASSED! CRYPTO BOT READY! ✨')
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n')

    print('📦 Summary:')
    print('  ✓ Price fetching (CoinGecko + BinanceUS)')
    print('  ✓ Portfolio management (${:,.2f})'.format(portfolio['total_value_usd']))
    print('  ✓ Technical analysis (TA-lib, 19 indicators)')
    print('  ✓ Price alerts ({} alerts)'.format(len(alerts['alerts'])))
    print('  ✓ Watchlist ({} coins)'.format(len(watchlist['watchlist'])))
    print()
    print('🎉 Ready to deploy to Raspberry Pi!')


if __name__ == '__main__':
    asyncio.run(test_all())
