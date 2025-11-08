# MySQL con Docker: guía paso a paso (Windows PowerShell)

Este repositorio levanta una base de datos MySQL 8 con Docker y ejecuta automáticamente el script `00_setup_tienda_g_db.sql` en el primer arranque.

La guía está pensada para Windows usando PowerShell.

## 0) Instalar Docker

- Windows: instala Docker Desktop desde:
	https://www.docker.com/products/docker-desktop/
- Tras instalar, reinicia si te lo pide y abre PowerShell.

Verifica que Docker quedó instalado:
```powershell
docker --version
docker compose version
```
Si tu versión no soporta el subcomando `compose`, prueba con el binario antiguo:
```powershell
docker-compose --version
```

## 1) Abrir la carpeta del proyecto

En PowerShell, navega hasta la carpeta del repositorio (ajusta la ruta si es distinta):
```powershell
cd "C:\Users\ErickDMB\Documents\DPW_DBA\administracion-base-de-datos"
```

Archivos clave:
- `docker-compose.yml`: define el servicio MySQL y los volúmenes.
- `00_setup_tienda_g_db.sql`: script que se ejecuta automáticamente la primera vez.

## 2) Levantar MySQL con Docker

Usa el nuevo subcomando (recomendado):
```powershell
docker compose up -d
```
Si tu instalación sólo tiene el binario antiguo, usa:
```powershell
docker-compose up -d
```

Cuando termine, MySQL quedará accesible en `localhost:3306`.

Credenciales por defecto (definidas en `docker-compose.yml`):
```
MYSQL_ROOT_PASSWORD = root
MYSQL_DATABASE      = tienda_g_db
```

## 3) Verificar que está corriendo

Listar el estado de los servicios:
```powershell
docker compose ps
```
Ver logs del servicio de base de datos:
```powershell
docker compose logs -f db
```

Entrar al cliente de MySQL dentro del contenedor como root:
```powershell
docker compose exec db mysql -u root -p"root"
```

Dentro del cliente puedes probar:
```sql
SHOW DATABASES;
USE tienda_g_db;
SHOW TABLES;
```

## 4) Volver a cargar el script inicial (opcional)

El script `00_setup_tienda_g_db.sql` se ejecuta automáticamente sólo al primer arranque (cuando el volumen de datos está vacío).

Para forzar su ejecución de nuevo (ADVERTENCIA: borra datos):
```powershell
docker compose down -v
docker compose up -d
```

O aplicarlo manualmente contra la base actual:
```powershell
docker compose exec -T db mysql -u root -p"root" tienda_g_db < .\00_setup_tienda_g_db.sql
```

## 5) Detener y limpiar

Detener contenedores (sin borrar datos):
```powershell
docker compose down
```
Borrar también el volumen de datos (resetea la base):
```powershell
docker compose down -v
```

## Errores frecuentes y cómo resolverlos

- Puerto en uso (3306): edita `docker-compose.yml` y cambia el mapeo de puertos por ejemplo a `"3307:3306"`; luego levanta de nuevo.
- No tienes `docker compose` pero sí `docker-compose`: usa los comandos con guion (`docker-compose ...`).
- WSL2 requerido (Windows): desde Docker Desktop, habilita “Use the WSL 2 based engine” y asegúrate de tener WSL2 instalado.
- Fallo al ejecutar el SQL inicial: revisa la salida de `docker compose logs -f db`. Corrige el archivo `00_setup_tienda_g_db.sql` y vuelve a levantar con `down -v` si necesitas re-ejecutarlo automáticamente.

## Notas

- Cambia credenciales antes de compartir el proyecto.
- El archivo `docker-compose.yml` monta el script SQL como sólo lectura y persiste datos en el volumen `mysqldata`.
- Si ya tienes un MySQL local, cambia el puerto publicado para evitar conflicto.
