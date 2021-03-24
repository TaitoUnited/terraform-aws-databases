/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "postgres_instance_address" {
  description = "The address of the RDS instance"
  value       = module.postgres.this_db_instance_address
}

output "postgres_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.postgres.this_db_instance_endpoint
}

output "mysql_instance_address" {
  description = "The address of the RDS instance"
  value       = module.mysql.this_db_instance_address
}

output "mysql_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.mysql.this_db_instance_endpoint
}
