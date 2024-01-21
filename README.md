# Terraform - Full course for beginners by FreeCodeCamp 

 El comando 'terraform state list' se utiliza para listar todos los recursos en el estado actual de Terraform.
```bash
terraform state list
```


El comando 'terraform state show' se utiliza para inspeccionar el estado de un recurso específico. Reemplace 'resource_name' con el nombre del recurso que desea inspeccionar.

```bash
terraform state show resource_name
```

Forzamos la actualización de un recurso en especifico

```bash
terraform apply -replace resource_name
```
