# Arquitectura Web Segura de 3 Capas con Terraform en Azure

![Azure](https://img.shields.io/badge/azure-%230078D4.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

Este repositorio contiene el código de **Infraestructura como Código (IaC)** para desplegar una aplicación web multi-contenedor siguiendo un patrón de arquitectura de 3 capas en Microsoft Azure, todo gestionado con **Terraform**.

**➡️ [Ver la Documentación Técnica Detallada del Despliegue](DOCUMENTACION_DETALLADA.md)**

---

### 🚀 Arquitectura y Flujo de Tráfico

La infraestructura se despliega en una Red Virtual (VNet) personalizada y se divide en cuatro subredes dedicadas para aplicar los principios de seguridad de **defensa en profundidad** y **mínimo privilegio**.

![Diagrama de la Arquitectura de Red en Azure](images/arquitectura-azure.png)

1.  **Capa de Presentación:** Un **Azure Application Gateway** actúa como reverse proxy.
2.  **Capa de Lógica:** Una **Azure Container Instance (ACI)** ejecuta la aplicación web desde una imagen de Docker.
3.  **Capa de Datos:** Un servidor de **Azure Database for MySQL** almacena los datos.
4.  **Capa de Administración:** Una **Máquina Virtual (Jump Box)** sirve como punto de acceso seguro.

---

### 💡 Logros y Habilidades Demostradas

* **Automaticé el despliegue de más de 15 recursos de Azure**, reduciendo el tiempo de aprovisionamiento de horas a minutos y garantizando un entorno 100% reproducible, mediante la escritura de código declarativo con **Terraform**.
* **Gestioné la infraestructura como código (IaC)**, permitiendo el control de versiones y la revisión de cambios en la infraestructura de la misma forma que se hace con el código de una aplicación, al estructurar el proyecto en **módulos lógicos (`network.tf`, `database.tf`, etc.)**.
* **Implementé un sistema de autenticación seguro y sin contraseñas entre servicios**, eliminando la necesidad de gestionar credenciales para el acceso a imágenes de contenedor, mediante la definición en código de **Identidades Administradas** y la asignación de roles **RBAC**.
* **Aseguré la gestión de secretos en un flujo de trabajo IaC**, desacoplando las contraseñas de la base de datos del código fuente, utilizando **ficheros `.tfvars`** excluidos del control de versiones.
* **Diseñé y codifiqué una topología de red virtual segmentada**, aplicando principios de seguridad de defensa en profundidad, mediante la definición explícita de **subredes dedicadas y delegadas** en Terraform.

---

### ⚙️ Cómo Usar

1.  Clonar el repositorio.
2.  Configurar las variables en un archivo `terraform.tfvars`.
3.  Ejecutar `terraform init`.
4.  Ejecutar `terraform apply`.