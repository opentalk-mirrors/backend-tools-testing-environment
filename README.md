# Testing Environments

Ready to run testing environments for opentalk-signaling and opentalk-controller

Just a simple `docker compose up -d` away. This will start all the base components OpenTalk depends on(rabbitMQ, redis, keycloak, etc.).
Next to that there are profiles to start the rest of the components of OpenTalk as you need them for development.
You can add them with the `--profile` option, so for example to run the base components and the controller simply run `docker compose --profile backend up`.
`docker compose --profile backend --profile frontend up` will give you a full base deployment with frontend and backend.

## Mac compatibility

Since on non Linux OSs Docker is run in a virtual machine, you cant use the `network_mode=host`. The [`add_mac_configurations`](https://git.opentalk.dev/opentalk/backend/tools/testing-environment/-/tree/add_mac_configurations) branch contains the required adjustments to use the testing environment under MacOS(and probably Windows).

## Web Frontends

The following web frontends are started depending on the selected profiles:

- [OpenTalk Dashboard](http://localhost:3000) (profile: `frontend`) — see [User](#user) section for credentials
- [Jaeger UI](http://localhost:16686) (profile: `metrics`) — no login required
- [Grafana](http://localhost:9000) (profile: `metrics`) — `admin:admin`
- [Keycloak Admin Console](http://localhost:8080/auth) — `admin:admin`
- [RabbitMQ Management](http://localhost:8280) — `guest:guest`
- [MinIO Console](http://localhost:9556) — `minioadmin:minioadmin`
- [NextCloud](http://localhost:9002) (profile: `nextcloud`) — `exampleuser:v3rys3cr3t`
- [OpenCloud](http://localhost:9003) (profile: `opencloud`) — Keycloak login (e.g. `alice`); `admin:admin` for basic-auth/API
- [Email Dashboard](http://localhost:1080) (profile: `mailer`) — no login required
- [RedisInsight](http://localhost:5540) (profile: `extras`) — no login required

## Profiles

- no profile(always enabled)
  - postgres
  - rabbitmq
  - livekit
  - keycloak
  - minio
- frontend
  - web-app
- frontend-roomserver
  - web-app (roomserver version)
- backend
  - controller
- backend-roomserver
  - controller-roomserver (controller with roomserver enables)
- recorder
  - recorder
- roomserver
  - roomserver
- nextcloud
  - nextcloud
- opencloud
  - opencloud
- spacedeck
  - spacedeck
- etherpad
  - etherpad
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
  - redisinsight
  - ndt

## User

There are multiple users created by default.

| First name | Last name | Login   | Email                 | Password   |
| ---------- | --------- | ------- | --------------------- | ---------- |
| first      | last      | test    | `foo@example.com`     | `testtest` |
| Alice      | Adams     | alice   | `alice@example.com`   | `alice`    |
| Bob        | Burton    | bob     | `bob@example.com`     | `bob`      |
| Charlie    | Cooper    | charlie | `charlie@example.com` | `charlie`  |
| Dave       | Dunn      | dave    | `dave@example.com`    | `dave`     |
| Erin       | Eaton     | erin    | `erin@example.com`    | `erin`     |

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

## Keycloak

You can use the provided keycloak or use a central one.

Admin User: admin
Admin Password: admin

The following users are created upon start (see [User](#user) section for details):
test/testtest, alice/alice, bob/bob, charlie/charlie, dave/dave, erin/erin

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
docker compose --profile nextcloud up
```

## OpenCloud

OpenCloud is an alternative to Nextcloud for the shared folder integration. It starts a single OpenCloud container that
uses host networking and is available on the host on port 9003 via HTTP (`http://localhost:9003`).

Authentication is handled by the testing-environment Keycloak (`OPENTALK` realm) instead of OpenCloud's built-in IDP:

- The bundled IDP is disabled (`OC_EXCLUDE_RUN_SERVICES=idp`) and OpenCloud is registered as the public `OpenCloud`
  client in the realm.
- Log in with any `OPENTALK` realm user (e.g. `alice`). On first login the account is auto-provisioned in OpenCloud's
  built-in LDAP (IDM) and gets the default `user` role.
- The built-in `admin:admin` account is kept for API/WebDAV access via basic auth.

Keycloak imports the realm only when it is first created, so the new `OpenCloud` client is picked up only after a realm
(re-)import. For an existing environment, either recreate the Keycloak database (drop the `keycloak` database in Postgres
or wipe its `pg_data*` volume) or add the client manually in the
[Keycloak admin console](http://localhost:8080/auth): a public `openid-connect` client `OpenCloud`, redirect URI
`http://localhost:9003/*`, web origin `http://localhost:9003`, PKCE method `S256`.

The container creates an `opencloud` folder in which the configuration and data are stored. After switching the auth
model you may need to delete that folder to start from a clean state.

Run opencloud container with:

```shell
docker compose --profile opencloud up
```

## Mailer

The `mailer` profile starts the SMTP Mailer and a MailCrab server. The SMTP Mailer connects to RabbitMQ from the testing environment by default and has MailCrab configured as the SMTP server. MailCrab exposes a web interface on port `1080` by default, where you can access the mails sent by the SMTP Mailer.

Run mailer profile with:

```shell
docker compose --profile mailer up
```
