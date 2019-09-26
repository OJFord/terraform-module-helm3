Simple Helm Chart application with state managed by Terraform.

That is, use `helm template` and `kubectl apply` (so no `helm rollback`) with Terraform managing lifecycle instead of Helm. As a result, it should work with Helm v2 (but won't use Tiller since we're applying with `kubectl`) or v3 (which has no Tiller anyway).
