# hydroxide_container
Docker container to run [hydroxide](https://github.com/emersion/hydroxide). In addition [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) with [acme-companion](https://github.com/nginx-proxy/acme-companion) is used to generate SSL certificates and use them.

## Prerequisites
- Docker
- [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy)*
- [acme-companion](https://github.com/nginx-proxy/acme-companion)*
- OPTIONAL. A Docker network where the nginx containers are. See *line 18 of container.sh*.
- A domain pointing to the container.
- Opening ports 587, 993 and 8088.

\* It is not necessary, although it is recommended. If it is not used, the ports and the startup script will have to be changed later.

## Instructions
In short, you must first run the container, configure the hydroxide user and generate the certificates. With all this you can run the container normally. Using the *container.sh* script automates many tasks.

### 1. Create and execute the image
First, you have to modify the variables in **lines 5 and 6 of the container.sh** file with the domain and the email used in Let's Encrypt.\
Then with the following commands the image is created and the container runs.

```bash
./container.sh build
./container.sh run
```

### 2. Connect hydroxide to Proton
The following command will prompt for the Proton user, password and 2FA (if needed). This will generate a key that will need to be saved, this is the password to connect to hydroxide. **This key will not be stored anywhere.**
```bash
./container.sh auth
```
If you want more information about this, see the [hydroxide project readme](https://github.com/emersion/hydroxide/blob/master/README.md#installing).

### 3. Using the SSL certificates
At this point acme-companion will have done its job and the certificates will have been generated.\
Now you must modify **line 7 of the container.sh** file with the *host* path where acme-companion leaves the certificates.

### 4. Final execution
Finally, it is necessary to recreate the container.
```bash
docker stop hydroxide
docker rm hydroxide
./container.sh run
```

## Acknowledgments 
- Simon Ser for [hydroxide](https://github.com/emersion/hydroxide)
- Harley Lang for [their Docker implementation](https://github.com/harleylang/hydroxide-docker)
- Lily Cohen for sharing [her Docker implementation with Tailscale](https://gist.github.com/lilithmooncohen/70cfebeedac63e9057eb9c29b6f494af#file-hydroxide_tailscale-md)
