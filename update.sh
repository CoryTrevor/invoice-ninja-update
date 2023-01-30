#!/bin/bash

### Update Invoice Ninja ###

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
version_from_file=$(cat public_html/VERSION.txt)
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

# Create update directory
mkdir -p update

# Move zip file
mv invoiceninja.zip update/

# Unzip the file
echo "Extracting zip file, this can take while..."
unzip -qq update/invoiceninja.zip -d update
rm update/invoiceninja.zip

# Copy the .env file and the public/storage folder to the update directory
echo "Backing up config, logo and PDF files..."
cp public_html/.env update/
cp -r public_html/public/storage update/public/

# Uncomment the line below if you want to preserve the logs
# cp -r public_html/storage/logs update/

# Uncomment and edit the line below to add any other folders or files that you'd like to keep 
# cp -r public_html/foldertokeep update/

# Copy folders and files from latest version to public_html, delete any obsolete files
echo "Copying $version files..."
rsync -a --recursive --exclude='update' --delete --force update/ public_html/    

# Update config
echo "Updating config and clearing caches..."
/usr/local/php81/bin/php-cli public_html/artisan clear-compiled
/usr/local/php81/bin/php-cli public_html/artisan route:clear
/usr/local/php81/bin/php-cli public_html/artisan view:clear
/usr/local/php81/bin/php-cli public_html/artisan migrate --force
/usr/local/php81/bin/php-cli public_html/artisan optimize

# Remove update folder
echo "Cleaning up temp update directory..."
rm -rf update   

# Check if the contents of VERSION.txt match the latest version number
check_version_from_file=$(cat public_html/VERSION.txt)
check_version_from_file=$(echo "$check_version_from_file" | sed 's/^/v/')
if [ "$check_version_from_file" = "$version" ]; then
  echo -e "Invoice Ninja successfully updated! \nInstalled version: $check_version_from_file"
else
  echo -e "Update failed! \nInstalled version: $check_version_from_file \nLatest version: $version"
fi
