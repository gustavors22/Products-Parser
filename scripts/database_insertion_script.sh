#!/bin/bash

# Script to download and insert data from multiple JSON files into a database

# Define database credentials
DB_USER="root"
DB_PASSWORD="root"
DB_HOST="127.0.0.1"
DB_NAME="products_db"
TABLE_NAME="products"

# Define function to insert data into database
function insert_data() {
    local file=$1
    local limit=100
    local i=0

    while read line; do
        if (( $i == $limit )); then
            break
        fi

        compact_json=$(echo $line | jq -c '.')

        eval "data=$compact_json" # Convert string to JSON object

        # Parse JSON data to extract values
        code=${data.code}
        status=${data.status}
        imported_t=$(date -u +%s)
        url=${data.url}
        creator=${data.creator}
        created_t=${data.created_t}
        last_modified_t=${data.last_modified_t}
        product_name=${data.product_name}
        quantity=${data.quantity}
        brands=${data.brands}
        categories=${data.categories}
        labels=${data.labels}
        cities=${data.cities}
        purchase_places=${data.purchase_places}
        stores=${data.stores}
        ingredients_text=${data.ingredients_text}
        traces=${data.traces}
        serving_size=${data.serving_size}
        serving_quantity=${data.serving_quantity}
        nutriscore_score=${data.nutriscore_score}
        nutriscore_grade=${data.nutriscore_grade}
        main_category=${data.main_category}
        image_url=${data.image_url}

        # Insert data into database
        mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -e \
        "INSERT INTO $TABLE_NAME (code, status, imported_t, url, creator, created_t, last_modified_t, product_name, quantity, brands, categories, labels, cities, purchase_places, stores, ingredients_text, traces, serving_size, serving_quantity, nutriscore_score, nutriscore_grade, main_category, image_url) VALUES ('$code', '$status', '$imported_t', '$url', '$creator', '$created_t', '$last_modified_t', '$product_name', '$quantity', '$brands', '$categories', '$labels', '$cities', '$purchase_places', '$stores', '$ingredients_text', '$traces', '$serving_size', '$serving_quantity', '$nutriscore_score', '$nutriscore_grade', '$main_category', '$image_url');"

        i=$((i+1))
    done < $file

    # Insert file name into json_imported table
    mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -e \
    "INSERT INTO json_inserted (file_name) VALUES ('$file');"
}

# Loop through each file, download and extract the JSON data, and insert into database
for i in {1..9}; do
    #check if file has imported into database before in the json_inserted table
    if [ $(mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -e "SELECT * FROM json_inserted WHERE file_name = 'products_0$i.json';" | wc -l) -gt 1 ]; then
        echo "File products_0$i.json has already been imported into database"
        continue
    fi

    # Download and extract JSON data
    url="https://challenges.coode.sh/food/data/json/products_0$i.json.gz"
    echo "Downloading $url"
    php -r "copy('$url', 'products_0$i.json.gz');"
    # Wait download to complete
    sleep 10
    echo "Extracting JSON data"
    gunzip products_0$i.json.gz
    # Insert data into database
    echo "Inserting data into database"
    insert_data products_0$i.json
    # delete file
    rm products_0$i.json
    # Wait for 5 seconds before processing the next file
    sleep 5
done
