# Transfer file via netcat
Netcat is just a single executable, and works across all platforms.
Be warned that file transfers using netcat are not encrypted.

## Transfer file using netcat
- On the receiving end running\
`$> nc -l -p 1234 > file.sql`

- On the sending end running\
`$> nc -w 3 193.168.195.171 1234 < backup.sql`


## Using compression
- Install compressor\
`apt-get install ncompress`

- On the receiving end running\
`$> nc -l -p 1234 | uncompress -c | tar xvfp -`

- On the sending end running\
`$> tar cfp - /var/backup/ | compress -c | nc -w 3 193.168.195.171 1234`


## Transfer disk
- On the sending end running
`dd if=/dev/hda3 | gzip -9 | nc -l 3333`

- On the receiving end running
`nc 193.168.195.171 3333 | pv -b > hdImage.img.gz`