# Aprendiendo Docker

Proyecto desarrollado para experimentar con Docker, Docker Compose y prácticas DevSecOps. Consiste en un backend desarrollado con ElysiaJS y un frontend desarrollado con TypeScript y Bun, ambos ejecutándose en contenedores Docker y orquestados mediante Docker Compose.

Además del despliegue local, el proyecto incorpora un pipeline CI/CD automatizado utilizando GitHub Actions, análisis de seguridad, pruebas automatizadas y validaciones de calidad.

---

# Arquitectura del Proyecto

El sistema está compuesto por dos servicios principales:

* **mi-api** → Backend desarrollado con ElysiaJS.
* **mi-front** → Frontend desarrollado con TypeScript y Bun.

Docker Compose permite ejecutar ambos servicios de forma coordinada dentro de la misma red de contenedores.

---

# Tecnologías Utilizadas

## Desarrollo

* TypeScript
* Bun
* ElysiaJS

## Contenedores

* Docker
* Docker Compose

## DevOps y CI/CD

* GitHub Actions
* SonarCloud
* Snyk
* Dependabot
* Vitest

---

# Requisitos

> [!IMPORTANT]
> Debes tener Docker Desktop instalado.

Herramientas necesarias:

* Docker Desktop
* Git

---

# Ejecución Local

Para iniciar todos los servicios:

```bash
docker compose up
```

Docker Compose construirá las imágenes y levantará automáticamente todos los contenedores necesarios.

---

# Acceso a la Aplicación

| Servicio | URL                   |
| -------- | --------------------- |
| Frontend | http://localhost:3001 |
| Backend  | http://localhost:3000 |

---

# Servicios

## Backend (mi-api)

Microservicio desarrollado con ElysiaJS.

Características:

* API REST
* TypeScript
* Ejecutado mediante Bun
* Contenerizado con Docker

Puerto expuesto:

```text
3000
```

---

## Frontend (mi-front)

Aplicación cliente desarrollada con TypeScript y Bun.

Características:

* Interfaz web
* Comunicación con API REST
* Contenerizada mediante Docker

Puerto expuesto:

```text
3001
```

---

# Orquestación de Contenedores

La orquestación se realiza mediante Docker Compose.

Docker Compose permite:

* Construcción automática de imágenes.
* Gestión de dependencias entre servicios.
* Ejecución simultánea de frontend y backend.
* Reinicio automático de contenedores.
* Administración centralizada de la infraestructura local.

El frontend depende del backend para su correcto funcionamiento, por lo que Docker Compose controla el orden de inicio de los servicios.

---

# Pipeline CI/CD

El proyecto utiliza GitHub Actions para automatizar la integración y entrega continua.

Cada vez que se realiza un push a la rama principal:

1. Se descargan las dependencias.
2. Se ejecutan pruebas automatizadas.
3. Se analizan vulnerabilidades mediante Snyk.
4. Se analizan dependencias con Dependabot.
5. Se ejecuta análisis de calidad mediante SonarCloud.
6. Se construyen las imágenes Docker.
7. Se despliega automáticamente la aplicación utilizando Docker Compose.

---

# Pruebas Automatizadas

Las pruebas unitarias son ejecutadas automáticamente durante el pipeline.

Herramienta utilizada:

* Vitest

Objetivos:

* Validar funcionalidades críticas.
* Detectar errores antes del despliegue.
* Garantizar estabilidad de la aplicación.

Si una prueba falla, el pipeline se detiene automáticamente.

---

# Seguridad

El proyecto incorpora prácticas DevSecOps.

## Dependabot

Dependabot monitorea dependencias vulnerables y genera actualizaciones automáticas.

## Snyk

Snyk analiza:

* Dependencias del backend.
* Dependencias del frontend.
* Imágenes Docker.

Si se detectan vulnerabilidades High o Critical, el pipeline es bloqueado automáticamente.

---

# Calidad del Código

La calidad del código es analizada mediante SonarCloud.

Se evalúan:

* Bugs
* Vulnerabilidades
* Code Smells
* Mantenibilidad
* Cobertura de pruebas

El despliegue se bloquea automáticamente cuando no se cumple la Quality Gate definida en SonarCloud.

---

# Trazabilidad

La trazabilidad del proyecto está garantizada mediante GitHub Actions.

Cada ejecución del pipeline registra:

* Commit ejecutado.
* Autor del cambio.
* Resultado de pruebas.
* Resultado de análisis de seguridad.
* Resultado de análisis de calidad.
* Estado del despliegue.

Esto permite seguir el ciclo completo desde el desarrollo hasta la ejecución de la aplicación.

---

# Logs

Para visualizar los registros de los contenedores:

```bash
docker compose logs -f
```

---

# Detener los Servicios

Para detener y eliminar los contenedores:

```bash
docker compose down
```

---

# Consideraciones

> [!WARNING]
> Si existe algún problema de comunicación entre contenedores, verificar que todos los servicios estén conectados correctamente a la red creada por Docker Compose.

Docker Compose genera esta red automáticamente durante la ejecución.

---

# Objetivo del Proyecto

Este proyecto fue desarrollado con fines educativos para aprender conceptos relacionados con:

* Contenedores Docker.
* Orquestación mediante Docker Compose.
* Integración Continua (CI).
* Entrega Continua (CD).
* Seguridad en pipelines DevSecOps.
* Automatización de despliegues.
* Monitoreo de calidad de software.
