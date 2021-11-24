# Testing Environments

Ready to run testing environments for k3k-signaling and k3k-controller

Just a simple `sudo docker-compose up -d` away. Maybe one day even rootless.
You might need to restart Janus with `sudo docker-compose restart janus` because docker-compose does not wait for rabbitmq to be fully booted before starting janus, janus just ignores rabbitmq if it can not connect.

## Rabbit MQ

ManagementURL: http://localhost:8280
Username: guest
Password: guest

## Turn
Static Auth Secret: k3k

## Keycloack
Admin User: admin
Admin Password: admin

You need to create a new user **with** filled out Firstname, Lastname, and E-Mail

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
