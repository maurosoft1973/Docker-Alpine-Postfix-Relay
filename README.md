# Postfix Relay Docker image running on Alpine Linux

[![Docker Automated build](https://img.shields.io/docker/automated/maurosoft1973/alpine-postfix-relay.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-postfix-relay/)
[![Docker Pulls](https://img.shields.io/docker/pulls/maurosoft1973/alpine-postfix-relay.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-postfix-relay/)
[![Docker Stars](https://img.shields.io/docker/stars/maurosoft1973/alpine-postfix-relay.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-postfix-relay/)

[![Alpine Version](https://img.shields.io/badge/Alpine%20version-v3.15.0-green.svg?style=for-the-badge)](https://alpinelinux.org/)
[![Postfix Relay Version](https://img.shields.io/docker/v/maurosoft1973/alpine-postfix-relay?sort=semver&style=for-the-badge)](https://www.postfix.net)

This Docker image [(maurosoft1973/alpine-postfix-relay)](https://hub.docker.com/r/maurosoft1973/alpine-postfix-relay/) is based on the minimal [Alpine Linux](https://alpinelinux.org/) with [Postfix Version v3.6.6-r0](https://www.postfix.net).

##### Alpine Version 3.15.0 (Released Nov 24 2021)
##### Postfix Version 3.6.6-r0 (Released 2022-04-21 10:13:08)

----

## What is Postfix?
Postfix is a free and open-source mail transfer agent (MTA) that routes and delivers electronic mail.

Postfix attempts to be fast, easy to administer, and secure.

## Architectures

* ```:aarch64``` - 64 bit ARM
* ```:armhf```   - 32 bit ARM v6
* ```:armv7```   - 32 bit ARM v7
* ```:ppc64le``` - 64 bit PowerPC
* ```:x86```     - 32 bit Intel/AMD
* ```:x86_64```  - 64 bit Intel/AMD (x86_64/amd64)

## Tags

* ```:latest```         latest branch based (Automatic Architecture Selection)
* ```:aarch64```        latest 64 bit ARM
* ```:armhf```          latest 32 bit ARM v6
* ```:armv7```          latest 32 bit ARM v7
* ```:ppc64le```        latest 64 bit PowerPC
* ```:x86```            latest 32 bit Intel/AMD
* ```:x86_64```         latest 64 bit Intel/AMD
* ```:test```           test branch based (Automatic Architecture Selection)
* ```:test-aarch64```   test 64 bit ARM
* ```:test-armhf```     test 32 bit ARM v6
* ```:test-armv7```     test 32 bit ARM v7
* ```:test-ppc64le```   test 64 bit PowerPC
* ```:test-x86```       test 32 bit Intel/AMD
* ```:test-x86_64```    test 64 bit Intel/AMD
* ```:3.15.0``` 3.15.0 branch based (Automatic Architecture Selection)
* ```:3.15.0-aarch64```   3.15.0 64 bit ARM
* ```:3.15.0-armhf```     3.15.0 32 bit ARM v6
* ```:3.15.0-armv7```     3.15.0 32 bit ARM v7
* ```:3.15.0-ppc64le```   3.15.0 64 bit PowerPC
* ```:3.15.0-x86```       3.15.0 32 bit Intel/AMD
* ```:3.15.0-x86_64```    3.15.0 64 bit Intel/AMD
* ```:3.15.0-3.6.6-r0``` 3.15.0-3.6.6-r0 branch based (Automatic Architecture Selection)
* ```:3.15.0-3.6.6-r0-aarch64```   3.15.0 64 bit ARM
* ```:3.15.0-3.6.6-r0-armhf```     3.15.0 32 bit ARM v6
* ```:3.15.0-3.6.6-r0-armv7```     3.15.0 32 bit ARM v7
* ```:3.15.0-3.6.6-r0-ppc64le```   3.15.0 64 bit PowerPC
* ```:3.15.0-3.6.6-r0-x86```       3.15.0 32 bit Intel/AMD
* ```:3.15.0-3.6.6-r0-x86_64```    3.15.0 64 bit Intel/AMD

## Layers & Sizes

| Version                                                                               | Size                                                                                                                 |
|---------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| ![Version](https://img.shields.io/badge/version-amd64-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-postfix-relay/latest?style=for-the-badge)  |
| ![Version](https://img.shields.io/badge/version-armv6-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-postfix-relay/armhf?style=for-the-badge)   |
| ![Version](https://img.shields.io/badge/version-armv7-blue.svg?style=for-the-badge)   | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-postfix-relay/armv7?style=for-the-badge)   |
| ![Version](https://img.shields.io/badge/version-ppc64le-blue.svg?style=for-the-badge) | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-postfix-relay/ppc64le?style=for-the-badge) |
| ![Version](https://img.shields.io/badge/version-x86-blue.svg?style=for-the-badge)     | ![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-postfix-relay/x86?style=for-the-badge)     |

## Howto use this image?

This image creates containers that allow you to send e-mails via your e-mail address (ex. gmail).

## Environment Variables:

### Main Postfix Relay parameters:
* `LC_ALL`: default locale (default en_GB.UTF-8)
* `TIMEZONE`: default timezone (default Europe/Brussels)
* `SMTP_SENDER_NAME`: the name displayed in the from header (also from name)
* `SMTP_RELAY_HOST`: the smtp server will forward mail
* `SMTP_RELAY_PORT`: the port of relay host
* `SMTP_RELAY_LOGIN`: user for login the relay host
* `SMTP_RELAY_PASSWORD`: password for login the relay host
* `RECIPIENT_RESTRICTIONS`: the recipients address to delivery email (default empty -> all recipient address)
* `ACCEPTED_NETWORKS`: the address ip authorized to send email (default 192.168.0.0/16 172.17.0.0/16 172.16.0.0/12 10.0.0.0/8)
* `SMTP_USE_TLS`: Enabling TLS in the Postfix SMTP Client (default no)
* `SMTP_TLS_SECURITY_LEVEL`: The default SMTP TLS security level for the Postfix SMTP client (default may)
* `SMTP_DEBUG_PEER_LIST`: For help with troubleshooting, Postfix can increase logging for particular hosts that you might be having problems with. debug_peer_list specifies a list of one or more hosts, domains, or regular expression patterns whose logging should be increased by the degree specified in debug_peer_level (default: 0.0.0.0 -> none)
* `SMTP_DEBUG_PEER_LEVEL`: debug level (default 3)

## Example of use


### 1. Create a container with account gmail,without 2FA enabled, and it's listen on all network interfaces and port 25
```sh
SMTP_GMAIL_LOGIN=youremail
SMTP_GMAIL_PASSORD=yourpassword

docker run -d -p 0.0.0.0:25:25 \
       --name alpine-postfix-relay-to-gmail \
       -e SMTP_RELAY_HOST=smtp.gmail.com \
       -e SMTP_RELAY_PORT=465 \
       -e SMTP_RELAY_LOGIN=${SMTP_GMAIL_LOGIN} \
       -e SMTP_RELAY_PASSWORD=${SMTP_GMAIL_PASSWORD} \
       maurosoft1973/alpine-postfix-relay
```

### 2. Create a container with account gmail,without 2FA enabled, and it's listen on all network interfaces and port 25 and 587
```sh
SMTP_GMAIL_LOGIN=youremail
SMTP_GMAIL_PASSORD=yourpassword

docker run -d -p 0.0.0.0:25:25 -p 0.0.0.0:587:587 \
       --name alpine-postfix-relay-to-gmail \
       -e SMTP_RELAY_HOST=smtp.gmail.com \
       -e SMTP_RELAY_PORT=465 \
       -e SMTP_RELAY_LOGIN=${SMTP_GMAIL_LOGIN} \
       -e SMTP_RELAY_PASSWORD=${SMTP_GMAIL_PASSWORD} \
       maurosoft1973/alpine-postfix-relay
```

### 3. Create a container with account gmail,with 2FA enabled, and it's listen on all network interfaces and port 25 and 587
First, you create an account [Google apppasswords](https://myaccount.google.com/apppasswords) for allow send email. The password is automatically generated

Please copy the password and paste into SMTP_GMAIL_PASSORD

```sh
SMTP_GMAIL_LOGIN=youremail
SMTP_GMAIL_PASSORD=automaticpasswordgenerated

docker run -d -p 0.0.0.0:25:25 -p 0.0.0.0:587:587 \
       --name alpine-postfix-relay-to-gmail \
       -e SMTP_RELAY_HOST=smtp.gmail.com \
       -e SMTP_RELAY_PORT=465 \
       -e SMTP_RELAY_LOGIN=${SMTP_GMAIL_LOGIN} \
       -e SMTP_RELAY_PASSWORD=${SMTP_GMAIL_PASSWORD} \
       maurosoft1973/alpine-postfix-relay
```

***
###### Last Update 08.05.2022 09:39:26