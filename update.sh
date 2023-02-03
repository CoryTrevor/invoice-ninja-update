#!/bin/bash

### Update Invoice Ninja ###

###-------- Define Installation Variables --------###

# Name of directory that Invoice Ninja installation is inside
parent_dir="public_html"

# Name of temp update directory
update_dir="invoiceninja_temp_update"

# If you need to specify a path for php-cli replace 'php' below with the path e.g. '/usr/local/php81/bin/php-cli'
php_cli_cmd="php"

###---------------- Begin Update ----------------###

# Query GitHub for the latest release
url=$(curl --fail -sL -o /dev/null -w %{url_effective} https://github.com/invoiceninja/invoiceninja/releases/latest)

# Check if the curl command was successful
if [ $? -ne 0 ]; then
  # The curl command failed, so print an error message and exit
  echo "Error: Failed to query GitHub for the latest release."
  exit 1
fi

# Extract the version number from the URL
version=$(echo "$url" | grep -oE '[^/]+$')

# Check if the contents of VERSION.txt match the latest version number
version_from_file=$(cat $parent_dir/VERSION.txt)
version_from_file=$(echo "$version_from_file" | sed 's/^/v/')
if [ "$version_from_file" = "$version" ]; then
  echo -e "Latest version already installed! \nInstalled version: $version_from_file \nLatest version: $version"
  exit 1
else
  echo "Downloading latest release $version"
fi

# Construct the download URL for the zip file
zip_url="https://github.com/invoiceninja/invoiceninja/releases/download/$version/invoiceninja.zip"

# Download the release
curl --fail -L --location-trusted -O "$zip_url" -o invoiceninja.zip

# Check if the curl command was successful
if [ $? -ne 0 ]; then
  # The curl command failed, so print an error message and exit
  echo "Error: Failed to download the latest release."
  exit 1
fi

# Create temp update directory
mkdir -p "$update_dir"

# Move zip file
mv invoiceninja.zip "$update_dir/"

# Unzip the file
echo "Extracting zip file, this can take while..."
unzip -qq $update_dir/invoiceninja.zip -d "$update_dir"
rm "$update_dir/invoiceninja.zip"

# Copy the .env file, public/storage folder & snappdf to the update directory
echo "Backing up config, logo, PDF files & snappdf versions"
cp "$parent_dir/.env" "$update_dir/"
cp -r "$parent_dir/public/storage" "$update_dir/public/"
cp -r "$parent_dir/vendor/beganovich/snappdf/versions" "$update_dir/vendor/beganovich/snappdf/"

# Comment out the line below if you don't want to preserve the logs
cp -r "$parent_dir/storage/logs" "$update_dir/storage/"

# Uncomment and edit the lines below to add any other folders or files that you'd like to keep 
# cp -r "$parent_dir/foldertokeep" "$update_dir/"
# cp "$parent_dir/filetokeep" "$update_dir/"

# Copy folders and files from latest version to $parent_dir, delete any obsolete files
echo "Copying $version files..."
rsync -a --recursive --exclude="$update_dir" --delete --force "$update_dir/" "$parent_dir/"


# Update config
echo "Updating config and clearing caches..."
$php_cli_cmd "$parent_dir/artisan" clear-compiled
$php_cli_cmd "$parent_dir/artisan" route:clear
$php_cli_cmd "$parent_dir/artisan" view:clear
$php_cli_cmd "$parent_dir/artisan" migrate --force
$php_cli_cmd "$parent_dir/artisan" optimize

# Remove temp update folder
echo "Cleaning up temp update directory..."
rm -rf "$update_dir"

# Check if the contents of VERSION.txt match the latest version number
check_version_from_file=$(cat $parent_dir/VERSION.txt)
check_version_from_file=$(echo "$check_version_from_file" | sed 's/^/v/')
if [ "$check_version_from_file" = "$version" ]; then
  echo -e "Invoice Ninja successfully updated! \nInstalled version: $check_version_from_file"
else
  echo -e "Update failed! \nInstalled version: $check_version_from_file \nLatest version: $version"
fi
