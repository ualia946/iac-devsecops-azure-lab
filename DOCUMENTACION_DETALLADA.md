# Documentación Técnica Detallada del Despliegue con Terraform

## 1. Introducción

Este documento detalla el proceso técnico para el despliegue automatizado de la infraestructura descrita en el `README.md` principal. El objetivo es explicar el flujo de trabajo de Infraestructura como Código (IaC) utilizado y las decisiones tomadas durante el proceso.

> **Nota:** Para un análisis paso a paso de cada servicio de Azure y el proceso de depuración manual que llevó a este diseño, por favor consulte la [documentación del proyecto de despliegiegue manual](https://github.com/ualia946/devsecops-azure-lab/blob/main/DOCUMENTACION_DETALLADA.md).

## 2. Prerrequisitos

Para ejecutar este proyecto, se requiere el siguiente software instalado y configurado:
* Una suscripción de Azure
* Azure CLI (`az`)
* Terraform
* Docker

## 3. Estructura del Repositorio

El código de Terraform se ha organizado en archivos lógicos para mejorar la legibilidad y el mantenimiento, siguiendo las mejores prácticas de la industria:

* **`main.tf`**: Contiene el recurso principal del Grupo de Recursos.
* **`providers.tf`**: Configura el proveedor de `azurerm` y la versión requerida.
* **`variables.tf`**: Declara todas las variables de entrada del proyecto.
* **`network.tf`**: Define la Red Virtual (VNet) y las cuatro subredes.
* **`database.tf`**: Define el servidor de Azure Database for MySQL, la Zona DNS Privada y el VNet Link.
* **`compute.tf`**: Define la Máquina Virtual (Jump Box), su IP pública, su interfaz de red y Grupo de Seguridad de Red (NSG).
* **`containers.tf`**: Define el Azure Container Registry (ACR) y la Azure Container Instance (ACI).
* **`reverse_proxy.tf`**: Define la capa de presentación y el punto de entrada a la aplicación, incluyendo el Azure Application Gateway y su IP Pública asociada.
* **`outputs.tf`**: Expone datos útiles, como la IP pública del Application Gateway.

---

## 4. Flujo de Despliegue Detallado

Debido a que la Instancia de Contenedor (ACI) necesita que la imagen de Docker ya exista en el Azure Container Registry (ACR) en el momento de su creación, el despliegue no se puede realizar con un único `terraform apply`. Se debe seguir un flujo de varias fases que simula un proceso de Integración Continua y Despliegue Continuo (CI/CD).

### Fase 1: Preparación Local - Construcción de la Imagen Docker

El primer paso es construir la imagen de la aplicación web localmente usando el `Dockerfile` proporcionado. Este `Dockerfile` se encarga de instalar todas las dependencias necesarias sobre una imagen base de PHP y Apache.

```bash
# Asegúrate de estar en la raíz de tu proyecto
# Este comando le dice a Docker que construya una imagen llamada "dvwa-web:v1"
# usando el contexto de la carpeta 'dvwa/', donde se encuentran el Dockerfile y dvwa.zip.
docker build -t dvwa-web:v1 ./dvwa
```

### Fase 2: Desplegar la Infraestructura Mínima (Terraform)

Para poder subir la imagen, primero necesitamos que el "almacén" (el ACR) exista en Azure. Usamos Terraform para crear únicamente este recurso.

```bash
# Inicializar el proyecto y descargar los proveedores de Terraform
terraform init

# Aplicar la creación del Grupo de Recursos y del ACR
terraform apply -target=azurerm_resource_group.rg -target=azurerm_container_registry.acr-dvwa
```
*Se debe confirmar la operación escribiendo `yes`.*

### Fase 3: Publicación de la Imagen en ACR (Simulación de CI/CD)

Con el ACR ya creado, simulamos el pipeline de CI/CD subiendo la imagen construida localmente al registro en la nube.

```bash
# 1. Iniciar sesión en el ACR recién creado
# Reemplaza <nombre-del-acr> con el nombre de tu ACR, ej. "acrterraformdvwadev"
az acr login --name <nombre-del-acr>

# 2. Etiquetar la imagen para el registro remoto
docker tag dvwa-web:v1 <nombre-del-acr>.azurecr.io/dvwa-web:v1

# 3. Subir la imagen al ACR
docker push <nombre-del-acr>.azurecr.io/dvwa-web:v1
```

### Fase 4: Desplegar la Arquitectura Completa (Terraform)

Ahora que la imagen (el "artefacto") está disponible en el ACR, podemos ejecutar Terraform para que cree el resto de los recursos.

```bash
# Aplicar la configuración completa
terraform apply
```
Terraform detectará que el Grupo de Recursos y el ACR ya existen (porque están en su fichero de estado) y procederá a crear todos los demás componentes (VNet, Base de Datos, ACI, Application Gateway, etc.), que ahora podrán completarse con éxito.

---

## 5. Destrucción del Entorno

Para eliminar todos los recursos creados y detener los costes, se utiliza un único comando que leerá el fichero de estado y destruirá toda la infraestructura gestionada.

```bash
terraform destroy
```