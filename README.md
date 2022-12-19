<h3>Invoice Ninja Updates</h3>
A bash script for updates to avoid PHP timeouts or using GitHub + Composer.

<b>Disclaimer</b>  

The script has not been tested in different environments  
Always do a full backup of your installation before running any updates

 
<b>Notes</b>  

The script assumes the Invoice Ninja files are directly inside public_html and not in a subfolder.  
If your public folder has a different name or you use a different folder structure, update the script accordingly.  
  
  
For the commands in the '# Update config' section it assumes PHP8.1 is in /usr/local/php81/bin/php-cli  
Make sure to update that part with the PHP8.1 directory of your server or if the default php-cli is PHP8.1 then you could just use 'php' rather than specifying the directory.
  
<b>Instructions</b>  

Add update.sh file in the same directory as the public_html folder (not inside it)  
To run: bash update.sh  
