# Testing Environments

Ready to run testing environments for opentalk-signaling and opentalk-controller

Just a simple `docker compose up -d` away. This will start all the base componenets OpenTalk depends on(rabbitMQ, redis, keycloak, etc.). Next to that there are profiles to start the rest of the components of OpenTalk as you need them for development. You can add them with the `--profile` option, so for example to run the base components and the controller simply run `docker compose --profile backend up`. `docker compose --profile backend --profile frontend up` will give you a full base deployment with frontend and backend.

You might need to restart Janus with `docker compose restart janus` because docker compose does not wait for rabbitmq to be fully booted before starting janus, janus just ignores rabbitmq if it can not connect.

## Mac compatability

Since on non Linux OSs Docker is run in a virtual machine, you cant use the `network_mode=host`. The [`add_mac_configurations`](https://git.opentalk.dev/opentalk/backend/tools/testing-environment/-/tree/add_mac_configurations) branch contains the required adjustments to use the testing environment under MacOS(and probably Windows).

## Web Frontends

The following web frontends are started depending on the selected profiles:

* [OpenTalk Dashboard](http://localhost:3000) (profile: `frontend`)
* [Jaeger UI](http://localhost:16686) (profile: `metrics`)
* [Grafana](http://localhost:9000) (profile: `metrics`)
* [Keycloak Admin Console](http://localhost:8080/auth)
* [RabbitMq](http://localhost:8280)
* [NextCloud](http://localhost:9002) (profile: `sharedfolder`)
* [Email Dashboard](http://localhost:1080) (profile: `mailer`)

## Profiles

- no profile(always enabled)
  - postgres
  - rabbitmq
  - janus
  - keycloak
  - minio
  - turn
- frontend
  - web-app
- backend
  - controller
- recorder
  - recorder
- mailer
  - smtp-mailer
  - mailcrab
- sharedfolder
  - nextcloud
- spacedeck
  - spacedeck
- etherpad
  - etherpad
- spacedeck
  - spacedeck
- metrics
  - jaeger
  - prometheus
  - grafana
  - node-exporter
  - redis-exporter
- mailer
  - smtp-mailer
  - mailcrab
- extras
  - redis
  - ndt

## User

There are multiple users created by default.

| First name | Last name | Login   | Email               | Password   |
| ---------- | --------- | ------- | ------------------- | ---------- |
| first      | last      | test    | foo@example.com     | `testtest` |
| Alice      | Adams     | alice   | alice@example.com   | `alice`    |
| Bob        | Burton    | bob     | bob@example.com     | `bob`      |
| Charlie    | Cooper    | charlie | charlie@example.com | `charlie`  |
| Dave       | Dunn      | dave    | dave@example.com    | `dave`     |
| Erin       | Eaton     | erin    | erin@example.com    | `erin`     |

## Controller

You can run the latest controller using the `backend`  profile.
Per default this uses the provided keycloak. You can set different settings using the env vars or by changing the config file `controller/config.toml`

## Frontend

You can run the latest frontend with the `frontend` profile. Per default it tries to use a local backend deployed at localhost:8000.

## GitLab Container Registry

In order to compose the some containers, your docker needs to have access to the `opentalk` container registry.
You can login your docker daemon to the repository by creating an access token.

Create an access token for the `opentalk` package/container registry:

1. Navigate in gitlab to your `profile` > `Access Tokens`
2. Create a new token with `read_registry` & `write_registry` scope
3. Copy the access token string
4. run `docker login git.opentalk.dev:5050 -u <username> -p <access token string>`

## Rabbit MQ

ManagementURL: http://localhost:8280
Username: guest
Password: guest

## Turn

Static Auth Secret: opentalk

## Keycloack

You can use the provided keycloak or use a central one.

Admin User: admin
Admin Password: admin

A test user with credentials test and test is created upon start.

# Metrics

To also start the metrics stuff run:
```shell
docker compose --profile metrics up
```

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

You need to have an `opentalk` access token configuered for docker in order to compose this container.
See [GitLab Container Registry](#gitlab-container-registry)

Run the etherpad container with:

```shell
docker compose --profile etherpad up
```

## MinIO

The container will create a `minio/` folder where the state of the storage is held. Removing the folder and keeping the
database will result in an invalid state for all assets.

A bucket with the name `controller` is created by default.

The MinIO `ACCESS_KEY` and `SECRET_KEY` have the value `minioadmin` pre-configured (same as root user login).


## Nextcloud

Will start a nextcloud behind an apache, available on the host on port 9002. Uses the example credentials from the
example `controller.toml`(exampleuser:v3rys3cr3t). The container creates a `nextcloud` folder, in which the data from
the nextcloud is stored.

Run nextcloud container with:

```shell
docker compose --profile sharedfolder up
```

## Mailer

The `mailer` profile starts the SMTP Mailer and a MailCrab server. The SMTP Mailer connects to RabbitMQ from the testing environment by default and has MailCrab configured as the SMTP server. MailCrab exposes a web interface on port `1080` by default, where you can access the mails sent by the SMTP Mailer.

Run mailer profile with:

```shell
docker compose --profile mailer up
```

