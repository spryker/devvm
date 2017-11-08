elk:
  # Location of Elasticsearch for logs. Note that SaltStack will not setup this ES,
  # so it should be either a seperate, dedicated Elasticsearch cluster for logs (production),
  # or it could be shared Elasticsearch cluster with spryker shop catalog (this is not live-ready
  # solution, but it works fine on DevVM where we need to optimize resources).

  elasticsearch:
    host: localhost
    port: 10005

  kibana:
    version: 4.5.0
