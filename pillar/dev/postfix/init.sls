# Postfix configuration. We should use a reliable mail relay (with SPF / DKIM)
# on production system.
#
# On dev - we redirect everything to mailcatcher, which runs on localhost, port 1025

postfix:
  relay:

    # Location of the relay host
    # Optional, default: no value
    host: "127.0.0.1:1025"

    # Username for relay host SMTP authorization
    # Optional, default: no value
    user:

    # Password for relay host SMTP authorization
    # Optional, default: no value
    api_key: