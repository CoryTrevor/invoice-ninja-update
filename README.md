# Invoice-Ninja-Update
Bash script for updates

Add update.sh file one directory above public_html  
To run: bash update.sh  
  
Disclaimer: 
Always do a full backup before running updates
Script has not been tested in different environments
 
Notes:  
The script assumes the Invoice Ninja files are directly inside public_html and not in a subfolder. If your public folder has a different name or you use a differnent folder structuree, update the script accordingly.  
  
  
For the # Update config code section it assumes PHP8.1 is in /usr/local/php81/bin/php-cli. This is only necessary on my server as the default php-cli version is PHP7.4 but if your default is PHP8.1 then it could just use 'php' for those commands rather than specifying the PHP8.1 directory.
