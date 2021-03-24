# Google Cloud databases

Example usage:

```
provider "aws" {
  region = "us-east-1"
}

module "databases" {
  source              = "TaitoUnited/databases/aws"
  version             = "1.0.0"

  name                = "my-infrastructure"
  vpc_id              = module.network.vpc_id
  database_subnets    = module.network.database_subnets

  postgresql_clusters = yamldecode(file("${path.root}/../infra.yaml"))["postgresqlClusters"]
  mysql_clusters      = yamldecode(file("${path.root}/../infra.yaml"))["mysqlClusters"]
}
```

Example YAML:

```
postgresqlClusters:
  - name: my-common-postgres
    version: "10.6"
    instanceClass: db.t2.large
    storageType: gp2
    storageSizeGb: 10
    maxStorageSizeGb: 100
    backupRetentionDays: 7
    backupWindow: "05:00-07:00"
    maintenanceWindow: "Tue:02:00-Tue:05:00"
    adminUsername: admin

mysqlClusters:
  - name: my-common-mysql
    version: "5.7.19"
    instanceClass: db.t2.large
    storageType: gp2
    storageSizeGb: 10
    maxStorageSizeGb: 100
    backupRetentionDays: 7
    backupWindow: "05:00-07:00"
    maintenanceWindow: "Tue:02:00-Tue:05:00"
    adminUsername: admin
```

YAML attributes:

- See variables.tf for all the supported YAML attributes.

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/aws)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/aws)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/aws)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/aws)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/aws)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/aws)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/aws)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/aws)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

Similar modules are also available for Azure, Google Cloud, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). TIP: See also [AWS project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/aws), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
