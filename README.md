# Ejemplo mínimo: MySQL con Docker

Este repositorio muestra cómo levantar una base de datos MySQL 8 usando Docker para practicar comandos desde la terminal.

Al iniciar por primera vez se ejecuta el script `00_setup_tienda_g_db.sql` (debe estar en la raíz). Ajusta su contenido para que sea válido en MySQL.

## Requisitos
- Docker Desktop (Windows / Mac) o Docker Engine (Linux)

## Paso 1: levantar MySQL
```powershell
docker compose up -d
```
MySQL quedará accesible en `localhost:3306`.

Credenciales por defecto (definidas en `docker-compose.yml`):
```
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=tienda_g_db
```
Para cambiarlas, edita directamente `docker-compose.yml` y vuelve a levantar (`docker compose down -v && docker compose up -d`).

## Paso 2: conectarte dentro del contenedor
```powershell
docker compose exec db mysql -u root -p"root"
```

## Ejecutar el script inicial de nuevo (si modificas el .sql)
Se corre sólo la primera vez (volumen vacío). Para forzar:
```powershell
docker compose down -v
docker compose up -d
```
O manualmente (como root):
```powershell
docker compose exec -T db mysql -u root -p"root" tienda_g_db < .\00_setup_tienda_g_db.sql
```

## Ver logs
```powershell
docker compose logs -f db
```

## Apagar
```powershell
docker compose down
```

## Dump rápido
```powershell
docker compose exec db mysqldump -u root -p"root" tienda_g_db > dump.sql
```

## Notas
- Cambia contraseñas antes de compartir el archivo.
- Si tienes otro MySQL local usa `3307:3306` en `docker-compose.yml`.
- El script `00_setup_tienda_g_db.sql` crea y rellena la base `tienda_g_db`; puedes editarlo libremente.

## Prácticas en terminal (con root)
Dentro del cliente MySQL:
```sql
-- Ver bases de datos y seleccionar la de trabajo
SHOW DATABASES;
USE tienda_g_db;
SHOW TABLES;
SELECT COUNT(*) FROM Productos;

-- Crear un usuario para la app
CREATE USER 'appuser'@'%' IDENTIFIED BY 'app_pass';

-- Dar permisos básicos sobre la base
GRANT SELECT, INSERT, UPDATE, DELETE ON tienda_g_db.* TO 'appuser'@'%';
-- (Opcional) más permisos: ALTER, CREATE, DROP, INDEX
-- GRANT ALL PRIVILEGES ON tienda_g_db.* TO 'appuser'@'%';

-- Ver privilegios del usuario
SHOW GRANTS FOR 'appuser'@'%';
```

Probar login con el usuario creado:
```powershell
docker compose exec db mysql -u appuser -p"app_pass" tienda_g_db
```
