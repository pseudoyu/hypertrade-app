# HyperTrade

"CoreWriter-powered Hyperliquid terminal: pro strategies, vaults & CEX-grade mobile trading"

## **How does it work?**

HyperTrade delivers a complete Hyperliquid trading ecosystem through deep technical integration:

**Advanced Trading Terminal**: We've built a full-featured terminal using Hyperliquid's Rust SDK and CoreWriter for asset custody. Beyond basic trading, we enable one-click strategy deployment (funding arbitrage, market making, smart money copying), real-time P&L tracking, and multi-account management. Our CoreWriter integration handles both direct trading and vault portfolio optimization, allowing users to seamlessly switch between spot/perp positions and vault investments.

**Strategy Execution Engine**: Our Rust/Tokio backend powers automated strategies with SeaORM + Redis for state management. We subscribe to AllMids for atomic price feeds, calculate spreads, monitor LSR signals, and track whale wallets. The system executes funding rate arbitrage, cross-margin strategies, and vault rebalancing while enforcing multi-level risk controls (position limits, drawdown protection, latency monitoring). Users can run multiple strategies simultaneously with isolated risk profiles.

**Mobile-First Super App**: Built with Flutter, our app delivers everything from basic trading to complex portfolio management. Features include advanced charting with TradingView integration, push notifications for trade signals, one-tap strategy deployment, vault performance analytics, and social trading features (copy trading, strategy sharing). We've optimized WebSocket connections for sub-second updates even on 4G, making professional perp trading truly mobile.
