#!/bin/bash

# Percorso al file JSON
JSON_FILE="/tmp/config/domains.json"

# Processa ogni entry nel JSON
jq -c '.[]' "$JSON_FILE" | while read -r server; do
    server_active=$(echo "$server" | jq '.Active')
    server_name=$(echo "$server" | jq '.ServerName')

    # Crea il file di configurazione sostituendo ${domain_name} nel template
    if [ "$server_active" == "false" ]; then
        a2dissite $server_name.conf
        echo "Il vHost denominato '$server_name' è stato attivato con successo. È ora completamente operativo."
    else
        a2ensite $server_name.conf
        echo "Attenzione: il server identificato con il nome '$server_name' non è attualmente attivo poiché l'opzione 'Active' è impostata su 'false'. Si prega di controllare la configurazione per abilitarlo."

        folder_path=$(echo /var/www/$server_name | sed 's/"//g')
        # Verifica se la cartella esiste
        if [ -d $folder_path ]; then
            echo "La cartella $folder_path esiste già."
        else
            echo "La cartella $folder_path non esiste. Creazione in corso..."
            mkdir -p $folder_path

            # Crea un file index.html vuoto nella nuova cartella
            touch $folder_path/index.html
            echo "<!DOCTYPE html><html><head><title>Pagina di Benvenuto per $server_name</title></head><body><h1>Benvenuto in $server_name!</h1></body></html>" > "$folder_path/index.html"
            echo "Cartella e file index.html creati con successo."
        fi
    fi
done