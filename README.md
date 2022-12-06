# CakePHP - packaged by Daktela

## What is CakePHP?

CakePHP is an open source PHP framework for web application development.

## Overview of CakePHP

Trademarks: This software listing is packaged by Daktela. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement. 

### TL;DR

#### Local workspace
You can start local workspace by running:

```plaintext
$ mkdir ~/myapp && cd ~/myapp
$ curl -LO https://raw.githubusercontent.com/Daktela/cake/dev/example/docker-compose.yml?token=GHSAT0AAAAAAB2TWMNWZOR2B6TQNMKRCHM6Y4DIATQ
$ docker-compose up
```
Access your local workspace on: http://localhost:8000

Warning: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options for the MariaDB container for a more secure deployment. 


#### Project command examples

##### Create new CakePHP project with CakePHP version 4.2.0
`$ docker-compose exec myapp project create-and-up 4.2.0`

##### Fix folders permissions
`$ docker-compose exec myapp project permissions`

##### Start only NGINX and PHP
`$ docker-compose exec myapp project serve`

##### Run migrations, composer and serve
`$ docker-compose exec myapp project up`
