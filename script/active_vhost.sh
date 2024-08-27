#!/bin/bash

# Percorso al file JSON
JSON_FILE="/tmp/config/domains.json"

# Processa ogni entry nel JSON
jq -r '.[]' "$JSON_FILE" | while read -r server; do
    server_active=$(echo "$server" | jq '.Active')
    server_name=$(echo "$server" | jq '.ServerName')

    # Crea il file di configurazione sostituendo ${domain_name} nel template
    if [ "$server_active" != "false" ] && [ "$server_active" != "null" ]; then
        a2ensite $server_name.conf
        echo "Il vHost denominato '$server_name' è stato attivato con successo. È ora completamente operativo."
    else
        echo "Attenzione: il server identificato con il nome '$server_name' non è attualmente attivo poiché l'opzione 'Active' è impostata su 'false'. Si prega di controllare la configurazione per abilitarlo."
    fi
done