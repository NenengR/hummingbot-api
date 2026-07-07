#!/bin/bash
set -e

# Create required directory structure
mkdir -p bots/credentials/master_account/connectors
mkdir -p bots/instances bots/conf/controllers bots/conf/scripts bots/data bots/archived

# Generate minimal conf_client.yml if not present
if [ ! -f bots/credentials/master_account/conf_client.yml ]; then
cat > bots/credentials/master_account/conf_client.yml << 'YAML'
instance_id: railway_hummingbot_api
fetch_pairs_from_all_exchanges: false
log_level: INFO
debug_console: false
strategy_report_interval: 900.0
logger_override_whitelist:
- hummingbot.strategy.arbitrage
- hummingbot.strategy.cross_exchange_market_making
- conf
kill_switch_mode: {}
autofill_import: disabled
mqtt_bridge:
  mqtt_host: ${BROKER_HOST:-localhost}
  mqtt_port: ${BROKER_PORT:-1883}
  mqtt_username: ''
  mqtt_password: ''
  mqtt_namespace: hbot
  mqtt_ssl: false
  mqtt_logger: true
  mqtt_notifier: true
  mqtt_commands: true
  mqtt_events: true
  mqtt_external_events: true
  mqtt_autostart: true
send_error_logs: true
db_mode:
  db_engine: sqlite
balance_asset_limit: {}
manual_gas_price: 50.0
gateway:
  gateway_api_host: localhost
  gateway_api_port: '15888'
  gateway_use_ssl: false
anonymized_metrics_mode:
  anonymized_metrics_interval_min: 15.0
rate_oracle_source:
  name: gate_io
global_token:
  global_token_name: USDT
  global_token_symbol: $
rate_limits_share_pct: 100.0
commands_timeout:
  create_command_timeout: 10.0
  other_commands_timeout: 30.0
tables_format: psql
paper_trade:
  paper_trade_exchanges:
  - binance
  - kucoin
  - gate_io
  paper_trade_account_balance:
    BTC: 1.0
    USDT: 1000.0
    ETH: 10.0
    USDC: 1000.0
color:
  top_pane: '#000000'
  bottom_pane: '#000000'
  output_pane: '#262626'
  input_pane: '#1C1C1C'
  logs_pane: '#121212'
  terminal_primary: '#5FFFD7'
  primary_label: '#5FFFD7'
  secondary_label: '#FFFFFF'
  success_label: '#5FFFD7'
  warning_label: '#FFFF00'
  info_label: '#5FD7FF'
  error_label: '#FF0000'
  gold_label: '#FFD700'
  silver_label: '#C0C0C0'
  bronze_label: '#CD7F32'
tick_size: 1.0
market_data_collection:
  market_data_collection_enabled: false
  market_data_collection_interval: 60
  market_data_collection_depth: 20
YAML
fi

# Generate minimal fee overrides if not present
if [ ! -f bots/credentials/master_account/conf_fee_overrides.yml ]; then
cat > bots/credentials/master_account/conf_fee_overrides.yml << 'YAML'
########################################
###   Fee overrides configurations   ###
########################################
YAML
fi

# Generate minimal logging config if not present
if [ ! -f bots/credentials/master_account/hummingbot_logs.yml ]; then
cat > bots/credentials/master_account/hummingbot_logs.yml << 'YAML'
---
version: 1
template_version: 12
formatters:
  brief:
    format: '%(asctime)s %(levelname)s %(name)s: %(message)s'
handlers:
  console:
    class: logging.StreamHandler
    formatter: brief
    stream: ext://sys.stdout
root:
  level: INFO
  handlers:
  - console
YAML
fi

echo "[entrypoint] Credentials directory initialized"

# Start the application
exec uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
