# You can also just source the OpenStack RC file
provider "openstack" {
  auth_url       = "https://<auth_url>"
  username       = "<username>"
  password       = "<password>"
  tenant_name    = "<tenant_name>"
  project_name   = "<project_name>"
  user_domain_id = "<user_domain_id>"
  project_domain_id = "<project_domain_id>"
}