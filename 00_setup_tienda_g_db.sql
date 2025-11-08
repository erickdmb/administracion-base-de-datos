-- 1) Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS tienda_g_db;
USE tienda_g_db;
-- Desactivar safe update mode temporalmente (para permitir UPDATE sin WHERE con KEY)
SET SQL_SAFE_UPDATES = 0;
-- 2) Limpieza (en orden, desactivando FKs temporalmente)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Venta_Detalle;
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Clientes;
SET FOREIGN_KEY_CHECKS = 1;
-- Categorías
CREATE TABLE Categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    UNIQUE (nombre) -- restricción de unicidad (no crea una vista; es una regla de datos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Clientes
CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE, -- unicidad de email
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Productos
CREATE TABLE Productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(50) NOT NULL UNIQUE, -- unicidad de SKU
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    categoria_id INT NULL,
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (categoria_id) REFERENCES Categorias(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Ventas (cabecera)
CREATE TABLE Ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Detalle de ventas
CREATE TABLE Venta_Detalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (venta_id) REFERENCES Ventas(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id) REFERENCES Productos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Categorías (9)
INSERT INTO Categorias (nombre, descripcion) VALUES
('Laptops', 'Equipos de cómputo portátiles de alto rendimiento'),
('Smartphones', 'Teléfonos inteligentes de última generación'),
('Accesorios', 'Accesorios varios para computadoras y móviles'),
('Periféricos', 'Dispositivos externos para computadoras'),
('Componentes', 'Partes internas de computadoras'),
('Monitores', 'Pantallas y displays'),
('Almacenamiento', 'Dispositivos de almacenamiento de datos'),
('Audio', 'Dispositivos de audio y sonido'),
('Redes', 'Equipos de redes y conectividad');
-- Clientes (10)
INSERT INTO Clientes (nombre, apellido, email) VALUES
('Juan', 'Pérez García', 'juan.perez@email.com'),
('Ana', 'Gómez López', 'ana.gomez@email.com'),
('Carlos', 'Ruiz Martinez', 'carlos.ruiz@email.com'),
('María', 'López', 'maria.lopez@email.com'),
('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com'),
('Laura', 'Martínez', 'laura.martinez@email.com'),
('Pedro', 'Sánchez', 'pedro.sanchez@email.com'),
('Sofía', 'Fernández', 'sofia.fernandez@email.com'),
('Miguel', 'González', 'miguel.gonzalez@email.com'),
('Lucía', 'Díaz', 'lucia.diaz@email.com');
-- Productos (21 registros con formato uniforme PROD-001 a PROD-021)
INSERT INTO Productos (sku, nombre, descripcion, precio, stock, categoria_id) VALUES
('PROD-001', 'Laptop Dell XPS 15', 'Equipo portátil de alto rendimiento', 5500.00, 15, (SELECT id FROM Categorias WHERE nombre='Laptops')),
('PROD-002', 'Laptop HP Spectre x360 14', 'Convertible premium de 14 pulgadas', 4800.50, 20, (SELECT id FROM Categorias WHERE nombre='Laptops')),
('PROD-003', 'Samsung Galaxy S23 Ultra', 'Smartphone de gama alta', 4200.00, 30, (SELECT id FROM Categorias WHERE nombre='Smartphones')),
('PROD-004', 'Apple iPhone 15 Pro', 'Smartphone premium de Apple', 5100.75, 25, (SELECT id FROM Categorias WHERE nombre='Smartphones')),
('PROD-005', 'Mouse Logitech MX Master 3', 'Mouse inalámbrico ergonómico', 350.00, 55, (SELECT id FROM Categorias WHERE nombre='Accesorios')),
('PROD-006', 'Audífonos Sony WH-1000XM5', 'Auriculares con cancelación activa de ruido', 1200.00, 8, (SELECT id FROM Categorias WHERE nombre='Audio')),
('PROD-007', 'Teclado Mecánico RGB', 'Teclado para gaming con iluminación RGB', 75.50, 50, (SELECT id FROM Categorias WHERE nombre='Periféricos')),
('PROD-008', 'Mouse Gamer Inalámbrico', 'Mouse ergonómico inalámbrico para gaming', 45.00, 80, (SELECT id FROM Categorias WHERE nombre='Periféricos')),
('PROD-009', 'Monitor Curvo 27"', 'Monitor curvo de 27 pulgadas', 320.00, 25, (SELECT id FROM Categorias WHERE nombre='Monitores')),
('PROD-010', 'Auriculares Gaming con Micrófono', 'Headset con micrófono para gaming', 89.99, 60, (SELECT id FROM Categorias WHERE nombre='Audio')),
('PROD-011', 'Webcam HD 1080p', 'Cámara web de alta definición', 55.50, 40, (SELECT id FROM Categorias WHERE nombre='Redes')),
('PROD-012', 'Disco Duro SSD 500GB', 'Unidad de estado sólido de 500GB', 120.00, 30, (SELECT id FROM Categorias WHERE nombre='Almacenamiento')),
('PROD-013', 'Memoria RAM 16GB DDR4', 'Módulo de memoria DDR4 16GB', 85.75, 45, (SELECT id FROM Categorias WHERE nombre='Componentes')),
('PROD-014', 'Tarjeta Gráfica GTX 1660', 'Tarjeta de video GTX 1660', 299.99, 15, (SELECT id FROM Categorias WHERE nombre='Componentes')),
('PROD-015', 'Silla Gaming Ergonómica', 'Silla ergonómica para gamers', 189.50, 20, (SELECT id FROM Categorias WHERE nombre='Redes')),
('PROD-016', 'Alfombrilla Mouse XXL', 'Alfombrilla de gran tamaño para mouse', 25.00, 100, (SELECT id FROM Categorias WHERE nombre='Accesorios')),
('PROD-017', 'Micrófono Condensador USB', 'Micrófono USB para streaming', 79.99, 35, (SELECT id FROM Categorias WHERE nombre='Audio')),
('PROD-018', 'Teclado Inalámbrico Compacto', 'Teclado compacto inalámbrico', 45.50, 55, (SELECT id FROM Categorias WHERE nombre='Periféricos')),
('PROD-019', 'Soporte para Monitor Ajustable', 'Soporte ajustable para monitor', 38.75, 40, (SELECT id FROM Categorias WHERE nombre='Monitores')),
('PROD-020', 'Hub USB 3.0 de 7 Puertos', 'Hub USB con 7 puertos 3.0', 29.99, 70, (SELECT id FROM Categorias WHERE nombre='Accesorios')),
('PROD-021', 'Ventilador para Laptop', 'Base de enfriamiento para laptop', 22.50, 65, (SELECT id FROM Categorias WHERE nombre='Accesorios'));
-- Ventas (8)
INSERT INTO Ventas (cliente_id, fecha_venta, total) VALUES
((SELECT id FROM Clientes WHERE email='juan.perez@email.com'), '2025-05-10 09:15:00', 0),
((SELECT id FROM Clientes WHERE email='ana.gomez@email.com'), '2025-05-11 14:30:00', 0),
((SELECT id FROM Clientes WHERE email='carlos.ruiz@email.com'), '2025-05-12 11:45:00', 0),
((SELECT id FROM Clientes WHERE email='maria.lopez@email.com'), '2025-05-13 16:20:00', 0), 
((SELECT id FROM Clientes WHERE email='carlos.rodriguez@email.com'), '2025-05-14 10:10:00', 0),
((SELECT id FROM Clientes WHERE email='laura.martinez@email.com'), '2025-05-15 13:25:00', 0),
((SELECT id FROM Clientes WHERE email='pedro.sanchez@email.com'), '2025-05-16 15:40:00', 0),
((SELECT id FROM Clientes WHERE email='sofia.fernandez@email.com'), '2025-05-17 12:05:00', 0);
-- Detalle de ventas
INSERT INTO Venta_Detalle (venta_id, producto_id, cantidad, precio_unitario) VALUES
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-10 09:15:00'), (SELECT id FROM Productos WHERE sku='PROD-008'), 1, (SELECT precio FROM Productos WHERE sku='PROD-008')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-10 09:15:00'), (SELECT id FROM Productos WHERE sku='PROD-016'), 2, (SELECT precio FROM Productos WHERE sku='PROD-016')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-11 14:30:00'), (SELECT id FROM Productos WHERE sku='PROD-009'), 1, (SELECT precio FROM Productos WHERE sku='PROD-009')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-11 14:30:00'), (SELECT id FROM Productos WHERE sku='PROD-018'), 1, (SELECT precio FROM Productos WHERE sku='PROD-018')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-12 11:45:00'), (SELECT id FROM Productos WHERE sku='PROD-010'), 1, (SELECT precio FROM Productos WHERE sku='PROD-010')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-13 16:20:00'), (SELECT id FROM Productos WHERE sku='PROD-007'), 1, (SELECT precio FROM Productos WHERE sku='PROD-007')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-13 16:20:00'), (SELECT id FROM Productos WHERE sku='PROD-011'), 1, (SELECT precio FROM Productos WHERE sku='PROD-011')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-14 10:10:00'), (SELECT id FROM Productos WHERE sku='PROD-014'), 1, (SELECT precio FROM Productos WHERE sku='PROD-014')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-15 13:25:00'), (SELECT id FROM Productos WHERE sku='PROD-018'), 1, (SELECT precio FROM Productos WHERE sku='PROD-018')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-15 13:25:00'), (SELECT id FROM Productos WHERE sku='PROD-019'), 1, (SELECT precio FROM Productos WHERE sku='PROD-019')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-16 15:40:00'), (SELECT id FROM Productos WHERE sku='PROD-012'), 2, (SELECT precio FROM Productos WHERE sku='PROD-012')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-17 12:05:00'), (SELECT id FROM Productos WHERE sku='PROD-006'), 1, (SELECT precio FROM Productos WHERE sku='PROD-006')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-17 12:05:00'), (SELECT id FROM Productos WHERE sku='PROD-005'), 1, (SELECT precio FROM Productos WHERE sku='PROD-005')),
((SELECT id FROM Ventas WHERE fecha_venta='2025-05-17 12:05:00'), (SELECT id FROM Productos WHERE sku='PROD-020'), 1, (SELECT precio FROM Productos WHERE sku='PROD-020'));
-- Actualizar total de cada venta en base a su detalle
UPDATE Ventas v
SET v.total = (
    SELECT IFNULL(SUM(vd.cantidad * vd.precio_unitario), 0)
    FROM Venta_Detalle vd
    WHERE vd.venta_id = v.id
);
-- Reactivar safe update mode
SET SQL_SAFE_UPDATES = 1;