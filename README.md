# Testing Environments

Ready to run testing environments for k3k-signaling and k3k-controller

Just a simple `sudo docker-compose up -d` away. Maybe one day even rootless.
You might need to restart Janus with `sudo docker-compose restart janus` because docker-compose does not wait for rabbitmq to be fully booted before starting janus, janus just ignores rabbitmq if it can not connect.

## Controller

You can run the latest controller with the `docker-compose.controller.yaml` file. Per default this uses the provided keycloak. You can set different settings using the env vars or by changing the config file `controller/config.toml`

## Frontend

You can run the latest frontend with the `docker-compose.frontend.yaml` file. Per default it tries to use a local backend deployed at localhost:8000

## GitLab Container Registry

In order to compose the some containers, your docker needs to have access to the heinlein-video container registry.
You can login your docker daemon to the repository by creating an access token.

Create an access token for the heinlein-video package/container registry:

1. Navigate in gitlab to your `profile` > `Access Tokens`
2. Create a new token with `read_registry` & `write_registry` scope
3. Copy the access token string
4. run `docker login git.heinlein-video.de:5050 -u <username> -p <access token string>`

## Rabbit MQ

ManagementURL: http://localhost:8280
Username: guest
Password: guest

## Turn

Static Auth Secret: k3k

## Keycloack

You can use the provided keycloak in docker-compose.oidc.yml or use a central one.

Admin User: admin
Admin Password: admin

A test user with credentials test and test is created upon start.

# Metrics

To also start the metrics stuff run:
docker-compose -f docker-compose.yaml -f docker-compose.metrics.yaml up -d

This starts
Prometheus and Grafana and node-exporter

## Grafana

HTTP Port: 9000
User/Password: admin:admin

# Postman

1. Import the collection into Postman.
2. Click onto the Controller collection, select the Authoritazion tab and scroll down to Get a new Access Token
3. Login to keycloack with the user you created
4. In the dialog where it shows you the access_token, scroll down and copy the id_token
5. Select the Variables tab in the Controller collection and paste the id_token into the current field of the variable.
6. Call the Login Endpoint

## Etherpad

You need to have an heinlein-video access token configuered for docker in order to compose this container.
See [GitLab Container Registry](#gitlab-container-registry)

Run the etherpad container with:

```s
docker-compose -f docker-compose.etherpad.yaml up -d
```

## MinIO

The container will create a `minio/` folder where the state of the storage is held. Removing the folder and keeping the
database will result in an invalid state for all assets.

A bucket with the name `controller` is created by default.

The MinIO `ACCESS_KEY` and `SECRET_KEY` have the value `minioadmin` pre-configured (same as root user login).
