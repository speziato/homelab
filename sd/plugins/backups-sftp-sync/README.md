# Backups SFTP sync

This is a plugin to copy a S3 bucket's contents to an SFTP endpoint, encrypting data before transfer.

It's based on rclone.

## Caveats

The crypt passwords that are placed in the config file for rclone need to be obscure using `rclone obscure`. See more in [rclone docs](https://rclone.org/crypt/).

You can run something like:

```bash
RCLONE_CRYPT_PASSWORD_CLEAR=$(openssl rand -base64 32)
RCLONE_CRYPT_SALT_CLEAR=$(openssl rand -base64 24)
RCLONE_CRYPT_PASSWORD=$(echo $RCLONE_CRYPT_PASSWORD_CLEAR | podman run -it --rm rclone/rclone obscure -)
RCLONE_CRYPT_SALT=$(echo $RCLONE_CRYPT_SALT_CLEAR | podman run -it --rm rclone/rclone obscure -)
```
