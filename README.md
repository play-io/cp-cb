## How to reproduce

### MySQL DB
- Directory `mysql` contains all files needed to create `ak-mysql` Docker image - customized MySQL DB.
    - Custom script creates `debezium` user and grant privileges needed for monitoring changes in MySQL database.
    - Custom script creates and populates 2 tables with sample data. The tables definition is incomplete - it's mainly done for PoC.
- `ak-mysql` Docker container image was built and pushed to Dockerhub artifactory, user *akkrdockerhub*.
- Deploy MySQL DB to Kubernetes. `kubectl apply -f mysql.yaml`.
- Deploy credentials to access MySQL DB, it will be used by Debezium's connector. `kubectl apply -f mysql-credential.yaml`.

### Confluent for Kubernetes
The operator was installed to existing Kubernetes cluster by running the following commands.

1. Add the Confluent for Kubernetes Helm repository.
```bash
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
```

2. Install Confluent for Kubernetes.
```bash
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes
```

### Confluent Platform
By deploying `kafka-eco-system.yaml` there will be installed:
- *Zookeeper* cluster.
- *Kafka* cluster.
    - With enabled option `auto.create.topics.enable=true`. For PoC we allow Kafka Connector to create topics as it goes.
- *Kafka Connect*.
    - With installed Debezium's MySQL Kafka Connector
```yaml
plugins:
  locationType: confluentHub
  confluentHub:
    - name: debezium-connector-mysql
      owner: debezium
      version: 0.9.4
```
    - With mounted `Secret` with credentials for the connector
```yaml
mountedSecrets:
- secretRef: mysql-credential
```

- *Schema Registry*.
    - Debezium MySQL Connector is configured to generate AVRO schema for tables, from where it reads.
- *Control Center*.

### MySQL Connector

Deploy `mysql-connector.yaml` to listening changes to MySQL DB and push it to Kafka.

## For convenience

### Exec into broker
`kubectl exec kafka-0 -it bash -n confluent`

### List topics
`kafka-topics --bootstrap-server  kafka.confluent.svc.cluster.local:9071 --list`

### Consumes data from a topic with Avro deserializer
`kafka-console-consumer --from-beginning --topic cloudbed.inventory.a_htl_bookings --bootstrap-server  kafka.confluent.svc.cluster.local:9071 --property schema.registry.url=http://schemaregistry.confluent.svc.cluster.local:8081 --value-deserializer io.confluent.kafka.serializers.KafkaAvroDeserializer --key-deserializer org.apache.kafka.common.serialization.StringDeserializer`

