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
        code=$(echo $line | jq '.code' | tr -d '"')
        status="published"
        imported_t=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        url=$(echo $line | jq '.url')
        creator=$(echo $line | jq '.creator')
        created_t=$(echo $line | jq '.created_t')
        last_modified_t=$(echo $line | jq '.last_modified_t')
        product_name=$(echo $line | jq '.product_name')
        quantity=$(echo $line | jq '.quantity')
        brands=$(echo $line | jq '.brands')
        categories=$(echo $line | jq '.categories')
        labels=$(echo $line | jq '.labels')
        cities=$(echo $line | jq '.cities')
        purchase_places=$(echo $line | jq '.purchase_places')
        stores=$(echo $line | jq '.stores')
        ingredients_text=$(echo $line | jq '.ingredients_text')
        traces=$(echo $line | jq '.traces')
        serving_size=$(echo $line | jq '.serving_size')
        serving_quantity=$(echo $line | jq '.serving_quantity')
        nutriscore_score=$(echo $line | jq '.nutriscore_score')
        nutriscore_grade=$(echo $line | jq '.nutriscore_grade')
        main_category=$(echo $line | jq '.main_category')
        image_url=$(echo $line | jq '.image_url')

        # Insert data into database if code is not null
        if [ $(echo $line | jq '.code' | tr -d '"') ]; then
            mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -e \
            "INSERT INTO $TABLE_NAME (code, status, imported_t, url, creator, created_t, last_modified_t, product_name, quantity, brands, categories, labels, cities, purchase_places, stores, ingredients_text, traces, serving_size, serving_quantity, nutriscore_score, nutriscore_grade, main_category, image_url) VALUES ('$code', '$status', '$imported_t', '$url', '$creator', '$created_t', '$last_modified_t', '$product_name', '$quantity', '$brands', '$categories', '$labels', '$cities', '$purchase_places', '$stores', '$ingredients_text', '$traces', '$serving_size', '$serving_quantity', '$nutriscore_score', '$nutriscore_grade', '$main_category', '$image_url');"
        fi

        i=$((i+1))
    done < $file

    # Insert file name into json_imported table
    mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -e \
    "INSERT INTO json_inserted (file_name) VALUES ('$file');"
}

# Save in cron_executations table the time the script was executed
mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -e \
"INSERT INTO cron_executations (runned_at) VALUES (NOW());"

# Get file names from index.txt
FILES=$(curl -s https://challenges.coode.sh/food/data/json/index.txt)
FILES_ARRAY=($FILES)

# Loop through each file, download and extract the JSON data, and insert into database
for file in "${FILES_ARRAY[@]}"; do
    filename=$(basename $file .json.gz)
    #check if file has imported into database before in the json_inserted table
    if [ $(mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME -e "SELECT * FROM json_inserted WHERE file_name = '$filename.json';" | wc -l) -gt 1 ]; then
        echo "File $filename.json has already been imported into database"
        continue
    fi

    # Download and extract JSON data
    url="https://challenges.coode.sh/food/data/json/$filename.json.gz"
    echo "Downloading $url"
    php -r "copy('$url', '$filename.json.gz');"
    # Wait download to complete
    sleep 10
    echo "Extracting JSON data"
    gunzip $filename.json.gz
    # Insert data into database
    echo "Inserting data into database"
    insert_data $filename.json
    # delete file
    rm $filename.json
    # Wait for 5 seconds before processing the next file
    sleep 5
done
