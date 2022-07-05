## Send file via rsync
- Install rsync `$> sudo apt install rsync`
- Basic usage `$> rsync [options] [source] [destination]`
- List options:
    * `a` - archive mode
    * `v` - shows details of the copying process
    * `p` - shows the progress bar
    * `r` - copies data recursively
    * `z` - compresses data
    * `q` - suppress output

## Local copy
- Send single file\
`$> rsync /var/file1.txt /home/documents`

- Send multiple files\
`$> rsync /var/file2.txt /var/file3.txt /home/documents`

- Send files any file by extension\
`$> rsync /var/*.zip /home/documents`

- Send folder
    * Copy directory /var/www\
    `$> rsync -av /var/www /home`

    * Copy any content inside /var/www\
    `$> rsync -av /var/www/ /home/apps`
    
- Exclude files\
`$> rsync -a --exclude="*.zip" /var/www/ /home/apps`

## Send file over SSH
- `$> rsync -v /var/dbdump.db.gz 103.157.96.147:/home/`
- `$> rsync -avzh -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress /var/dbdump.db.gz 103.157.96.147:/home/`