## Send files and directory securely using SCP
- Basic usage: `$> scp [OPTION] [user@]SRC_HOST:]file1 [user@]DEST_HOST:]file2`
    * [`OPTION`](https://linux.die.net/man/1/scp) - scp options such as cipher, ssh configuration, ssh port, limit, recursive copy …etc.
    * `[user@]SRC_HOST:]file1` - Source file
    * `[user@]DEST_HOST:]file2` - Destination file
    * `-P` - Specifies the remote host ssh port
    * `-p` - Preserves files modification and access times.
    * `-q` - Use this option if you want to suppress the progress meter and non-error messages
    * `-C` - This option forces scp to compress the data as it is sent to the destination machine.
    * `-r` - This option tells scp to copy directories recursively.

## Copy file from local to remote
- Send single file `$> scp backup.sql root@103.157.96.147:/home/backup/`
- Send multiple files `$> scp backup.sql db.sql root@103.157.96.147:/home/backup/`
- Send directory `$> scp -r /var/backup db.sql root@103.157.96.147:/home/backup/`

## Copy file from remote to local
- Receive file `$> scp root@103.157.96.147:/var/backup.sql /home/backup`
- Receive directory `$> scp -r root@103.157.96.147:/var/backup /home/backup`

## Copy between remotes
- Send file `$> scp root@host1.com:/var/file.txt root@host2.com:/home/files`
- Send directory `$> scp -r root@host1.com:/var/backup root@host2.com:/home/backup`