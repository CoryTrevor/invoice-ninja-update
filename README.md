# Invoice-Ninja-Update
Bash script for updates

<b>Instructions</b>  

Read disclaimer and notes below  
Add update.sh file in the same directory as the public_html folder (not inside it)  
To run: bash update.sh  

<b>Disclaimer</b>  

The script has not been tested in different environments  
Always do a full backup of your installation before running any updates

 
<b>Notes</b>  

The script assumes the Invoice Ninja files are directly inside public_html and not in a subfolder.  
If your public folder has a different name or you use a different folder structure, update the script accordingly.  
  
  
For the commands in the '# Update config' section it assumes PHP8.1 is in /usr/local/php81/bin/php-cli  
This is necessary on my server as the default php-cli version is PHP7.4 but if your default is PHP8.1 then it could just use 'php' for those commands rather than specifying the PHP8.1 directory.
