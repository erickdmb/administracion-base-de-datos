## Organización por semanas

El repositorio está estructurado para un curso de 16 semanas. A partir de la semana 2 se comienza la creación de la base de datos y cada semana tiene su propia carpeta con los scripts y materiales correspondientes.

Ejemplo de estructura:

```
mysql/
├── semana_02_creacion_bd/
│   └── crear_base_de_datos.sql
├── semana_03_tablas/
│   └── crear_tablas.sql
├── semana_04_inserts/
│   └── insertar_datos.sql
├── semana_05_consultas_basicas/
│   └── consultas.sql
└── ... (continúa hasta semana_16)
```

Esto facilita el seguimiento del curso y la ubicación de los materiales por semana.

# administracion-base-de-datos
Curso de Administración de Bases de Datos Usando MySQL

## Requisitos previos

### 1. Instalación de Docker

1. Descarga e instala Docker Desktop desde: https://www.docker.com/products/docker-desktop/
2. Sigue las instrucciones de instalación según tu sistema operativo (Windows, Mac o Linux).
3. Verifica la instalación ejecutando en la terminal:
	```sh
	docker --version
	docker-compose --version
	```

## Estructura recomendada del repositorio

```
administracion-base-de-datos/
│
├── README.md
├── docker-compose.yml
├── mysql/
│   ├── init/           # Scripts SQL de inicialización
│   └── backups/        # Respaldos de la base de datos
└── docs/               # Documentación adicional
```

## Uso de Docker y docker-compose


### 1. Levantar el servicio MySQL
Ubícate en la carpeta del proyecto y ejecuta:
```sh
docker-compose up -d
```

### 2. Forzar reconstrucción de imágenes (si cambiaste scripts o configuración)
```sh
docker-compose up -d --build
```

### 3. Conectarse a MySQL con MySQL Workbench
Abre MySQL Workbench y crea una nueva conexión con los siguientes datos:

- Hostname: 127.0.0.1
- Port: 3306
- Username: root
- Password: root

Puedes cambiar estos valores en el archivo `docker-compose.yml` si lo necesitas.

### 4. Detener y eliminar los servicios
```sh
docker-compose down -v
```

### 5. Limpiar imágenes y volúmenes (opcional, para empezar de cero)
```sh
docker-compose down --rmi all -v
docker system prune -a
```

## Comandos útiles de Git

```sh
# Clonar el repositorio
git clone https://github.com/erickdmb/administracion-base-de-datos.git

# Crear y cambiar a una nueva rama
git checkout -b feature/mi-rama

# Actualizar tu rama con main
git fetch origin
git merge origin/main

# Subir cambios a tu rama
git add .
git commit -m "Descripción de los cambios"
git push origin feature/mi-rama

# Subir cambios a main (si eres el owner)
git checkout main
git merge feature/mi-rama
git push origin main
```

---
Sigue estas instrucciones para facilitar el trabajo colaborativo y la gestión de la base de datos con MySQL y Docker.
