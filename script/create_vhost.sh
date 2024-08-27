#!/bin/bash

# Percorso al file JSON
JSON_FILE="/tmp/config/domains.json"

# Percorso al template del file vhost
VHOST_TEMPLATE="/tmp/templates/vhost.tpl"

# Cartella dove i file saranno creati
SITES_AVAILABLE_DIR="/etc/apache2/sites-available"

# Processa ogni entry nel JSON
jq -r '.[] | .ServerName' "$JSON_FILE" | while read -r server_name; do
    # Determina il path del file di configurazione
    CONFIG_FILE="$SITES_AVAILABLE_DIR/$server_name.conf"

    # Crea il file di configurazione sostituendo ${domain_name} nel template
    if [ -f "$VHOST_TEMPLATE" ]; then
        sed "s/\${domain_name}/$server_name/g" "$VHOST_TEMPLATE" > "$CONFIG_FILE"
        echo "File creato: $CONFIG_FILE"
    else
        echo "Template vhost.tpl non trovato."
    fi
done
