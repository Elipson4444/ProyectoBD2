CREATE DATABASE PROYECTO;

USE PROYECTO;

CREATE TABLE categoria_producto (
    id_categoria     INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(50) NOT NULL
);

CREATE TABLE producto (
    id_producto      INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria     INT,
    nombre           VARCHAR(50) NOT NULL,
    talla            VARCHAR(20),
    color            VARCHAR(20),
    precio           DECIMAL(10,2) NOT NULL CHECK (precio > 0),

    CONSTRAINT fk_producto_categoria 
        FOREIGN KEY (id_categoria) REFERENCES categoria_producto(id_categoria)
        ON DELETE CASCADE
);

CREATE TABLE tienda (
    id_tienda        INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(50) NOT NULL,
    direccion        VARCHAR(75) NOT NULL,
    num_admin        INT NULL,
    num_empleados    INT NULL
);

CREATE TABLE inventario (
    id_inventario    INT AUTO_INCREMENT PRIMARY KEY,
    id_tienda        INT NOT NULL,
    stock_total      INT NULL,
    valor_total      DECIMAL(10,2) NULL,
    tipo_productos   INT NULL,
    fecha_cambio    DATE NOT NULL,
    
    CONSTRAINT fk_inventario_tienda 
        FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda),
    CONSTRAINT uk_tienda
        UNIQUE (id_tienda)
);

CREATE TABLE detalle_inventario(
    id_detalle_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_inventario         INT NOT NULL,
    id_producto           INT NOT NULL,
    cantidad              INT NOT NULL CHECK (cantidad>=0),
    valor_unitario        DECIMAL(10,2) NOT NULL CHECK (valor_unitario>=0),
    valor_stock           DECIMAL(10,2) NOT NULL CHECK (valor_stock>=0),
    stock_minimo          INT NOT NULL CHECK (stock_minimo>=0),
    stock_maximo          INT NOT NULL CHECK (stock_maximo>=1),
    CONSTRAINT fk_detalleInv_inventario
        FOREIGN KEY (id_inventario) REFERENCES inventario (id_inventario),
    CONSTRAINT fk_detalleInv_producto 
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT uk_productoInv_inventario 
        UNIQUE (id_producto,id_inventario)
);
 
CREATE TABLE usuario (
    id_usuario       INT AUTO_INCREMENT PRIMARY KEY,
    id_tienda	     INT NOT NULL,
    nombre           VARCHAR(70) NOT NULL,
    num_documento    VARCHAR(20) UNIQUE,
    rol              VARCHAR(20) CHECK (rol IN ('administrador','vendedor')),
    clave       VARCHAR(100) NOT NULL,
    
    CONSTRAINT fk_id_tienda
		FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda)
);


CREATE TABLE ingreso_inventario (
    id_ingreso       INT AUTO_INCREMENT PRIMARY KEY,
    id_tienda        INT NOT NULL,
    id_usuario       INT NOT NULL,
    fecha            DATE NOT NULL,
    tipo_productos   INT NULL,
    motivo           VARCHAR(30) CHECK (motivo IN ('recepción','devolución','ajuste')),
    valor_inventario DECIMAL(10,2) NULL,
    
    CONSTRAINT fk_ingreso_tienda 
        FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda),
    CONSTRAINT fk_ingreso_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE detalle_ingreso (
    id_detalle_ingreso    INT AUTO_INCREMENT PRIMARY KEY,
    id_ingreso            INT NOT NULL,
    id_producto           INT NOT NULL,
    cantidad              INT NOT NULL CHECK (cantidad>= 1),
    CONSTRAINT fk_detalleIgs_ingreso
        FOREIGN  KEY (id_ingreso) REFERENCES ingreso_inventario(id_ingreso)
        ON DELETE CASCADE,
    CONSTRAINT fk_detalleIgs_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE venta (
    id_venta         INT AUTO_INCREMENT PRIMARY KEY,
    fecha            DATE NOT NULL,
    total            DECIMAL(10,2) NULL,
    id_tienda        INT NOT NULL,
    id_usuario       INT NOT NULL,
    CONSTRAINT fk_venta_tienda 
        FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda),
    CONSTRAINT fk_venta_usuario 
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE detalle_venta (
    id_detalle       INT AUTO_INCREMENT PRIMARY KEY,
    cantidad         INT NOT NULL CHECK (cantidad>= 1),
    precio_unitario  DECIMAL(10,2) NOT NULL,
    id_venta         INT NOT NULL,
    id_producto      INT NOT NULL,
    CONSTRAINT fk_detalleVnt_venta 
        FOREIGN KEY (id_venta) REFERENCES venta(id_venta)
        ON DELETE CASCADE,
    CONSTRAINT fk_detalleVnt_producto 
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE traslado (
    id_traslado      INT AUTO_INCREMENT PRIMARY KEY,
    id_tienda_origen INT NOT NULL,
    id_tienda_destino INT NOT NULL,
    id_usuario       INT NOT NULL,
    fecha            DATE NOT NULL,
    
    CONSTRAINT fk_traslado_origen 
        FOREIGN KEY (id_tienda_origen) REFERENCES tienda(id_tienda),
    CONSTRAINT fk_traslado_destino 
        FOREIGN KEY (id_tienda_destino) REFERENCES tienda(id_tienda),
    CONSTRAINT fk_traslado_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE detalle_traslado (
    id_detalle_traslado INT AUTO_INCREMENT PRIMARY KEY,
    cantidad            INT NOT NULL CHECK (cantidad>= 1),
    id_traslado         INT NOT NULL,
    id_producto         INT NOT NULL,
    CONSTRAINT fk_detalleTras_traslado 
        FOREIGN KEY (id_traslado) REFERENCES traslado(id_traslado)
        ON DELETE CASCADE,
    CONSTRAINT fk_detalleTras_producto 
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);


ALTER TABLE detalle_venta
ADD COLUMN total decimal(10,2) not null;


ALTER TABLE detalle_venta
DROP CHECK detalle_venta_chk_1;


ALTER TABLE detalle_venta
ADD CONSTRAINT detalle_venta_chk_1 CHECK (cantidad >= 0);


ALTER TABLE detalle_ingreso
DROP CHECK detalle_ingreso_chk_1;

ALTER TABLE detalle_ingreso
ADD CONSTRAINT detalle_ingreso_chk_1 CHECK (cantidad >= 0);







USE PROYECTO;


INSERT INTO categoria_producto (nombre) VALUES 
('Camisetas'),
('Pantalones'),
('Zapatos'),
('Accesorios'),
('Ropa Deportiva');


INSERT INTO producto (id_categoria, nombre, talla, color, precio) VALUES 
(1, 'Camiseta Básica', 'M', 'Blanco', 15.99),
(1, 'Camiseta Premium', 'L', 'Negro', 24.99),
(2, 'Jeans Clásicos', '32', 'Azul', 45.50),
(2, 'Pantalón Deportivo', 'M', 'Gris', 35.75),
(3, 'Zapatos Casuales', '42', 'Marrón', 89.99),
(3, 'Tenis Running', '41', 'Negro', 120.00),
(4, 'Gorra Deportiva', 'Única', 'Rojo', 19.99),
(5, 'Sudadera con Capucha', 'XL', 'Azul Marino', 55.00);

INSERT INTO producto (id_categoria, nombre, talla, color, precio) VALUES 
(5, 'Sudadera sin Capucha', 'XL', 'Azul Marino', 10);


INSERT INTO tienda (nombre, direccion, num_admin, num_empleados) VALUES 
('Tienda Centro', 'Av. Principal 123, Centro', 1, 8),
('Tienda Norte', 'Calle Norte 456, Zona Norte', 2, 6),
('Tienda Sur', 'Plaza Sur 789, Zona Sur', 3, 5),
('Tienda Online', 'Almacén Central, Polígono Industrial', 4, 3);


INSERT INTO usuario (nombre, id_tienda, rol, num_documento ,clave) VALUES 
('Vendedor 1',1,'vendedor','1', '3974fca6b4c10bf5c3c3be6a35f9e29fe3af26d5'),
('Carlos López',2, 'vendedor','1033' ,'vendedor456'),
('María Rodríguez',3,'vendedor','1034', 'vendedor789'),
('Pedro Martínez',4, 'administrador','1035', 'admin456'),
('Jman',1,'administrador', '103293','7a8427c880e6abd12cd7b7c367bd981b6cad6011');



INSERT INTO inventario (id_tienda, stock_total, valor_total, tipo_productos, fecha_cambio) VALUES 
(1, 150, 4500.75, 8, '2024-01-15'),
(2, 200, 6200.50, 8, '2024-01-15'),
(3, 100, 3200.25, 8, '2024-01-15'),
(4, 300, 8900.00, 8, '2024-01-15');


INSERT INTO detalle_inventario (id_inventario, id_producto, cantidad, valor_unitario, valor_stock, stock_minimo, stock_maximo) VALUES 
(1, 1, 50, 15.99, 799.50, 10, 100),
(1, 2, 30, 24.99, 749.70, 5, 50),
(1, 3, 20, 45.50, 910.00, 5, 30),
(2, 4, 40, 35.75, 1430.00, 8, 60),
(2, 5, 25, 89.99, 2249.75, 3, 40),
(3, 6, 15, 120.00, 1800.00, 2, 25),
(3, 7, 35, 19.99, 699.65, 10, 80),
(4, 8, 60, 55.00, 3300.00, 15, 100);


INSERT INTO ingreso_inventario (id_tienda, id_usuario, fecha, tipo_productos, motivo, valor_inventario) VALUES 
(1, 1, '2024-01-10', 3, 'recepción', 450.25),
(2, 2, '2024-01-11', 2, 'devolución', 320.75),
(3, 3, '2024-01-12', 1, 'ajuste',150.00),
(4, 4, '2024-01-13', 4, 'recepción', 680.50);


INSERT INTO detalle_ingreso (id_ingreso, id_producto, cantidad) VALUES 
(1, 1, 20),
(1, 2, 10),
(1, 3, 5),
(2, 4, 8),
(2, 5, 3),
(3, 6, 2),
(4, 7, 15),
(4, 8, 10);


INSERT INTO venta (fecha, total, id_tienda, id_usuario) VALUES 
('2024-01-15', 156.98, 1, 2),
('2024-01-15', 245.50, 2, 3),
('2024-01-14', 89.99, 3, 2),
('2024-01-14', 175.75, 1, 3);


INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto,total) VALUES 
(2, 15.99, 1, 1,7),
(1, 24.99, 1, 2,6),
(1, 45.50, 2, 3,5),
(2, 35.75, 2, 4,4),
(1, 89.99, 3, 5,3),
(1, 55.00, 4, 8,2),
(2, 35.75, 4, 4,1);


INSERT INTO traslado (id_tienda_origen, id_tienda_destino, id_usuario, fecha) VALUES 
(4, 1, 1, '2024-01-13'),
(4, 2, 4, '2024-01-14'),
(1, 3, 2, '2024-01-12'),
(2, 1, 3, '2024-01-11');


INSERT INTO detalle_traslado (cantidad, id_traslado, id_producto) VALUES 
(10, 1, 1),
(5, 1, 2),
(8, 2, 4),
(3, 2, 5),
(4, 3, 3),
(6, 4, 7);





-- Login
DELIMITER $$
CREATE PROCEDURE sp_login ( 
IN vv_numDocumento VARCHAR(20), 
IN vv_clave VARCHAR(100)
 )
BEGIN
	DECLARE vn_contador INT;
	SELECT COUNT(*) INTO vn_contador
    FROM usuario 
    WHERE num_documento = vv_numDocumento AND clave = vv_clave;
    
    IF vn_contador = 1 THEN
		SELECT id_usuario,id_tienda,nombre,rol
        FROM usuario
        WHERE num_documento = vv_numDocumento;
	ELSE
		SELECT NULL AS id_usuario, NULL AS id_tienda,'error login' AS mensaje, NULL AS rol; 
	END IF;
END $$
DELIMITER ;


-- SP para mostrar info general del inventario segun id_tienda del empleado
DELIMITER $$
CREATE PROCEDURE sp_mostrarInfoInventario(
	IN vn_idTienda INT 
)
BEGIN
	SELECT t.nombre,
    i.stock_total, 
    i.valor_total, 
    i.tipo_productos, 
    i.fecha_cambio 
FROM tienda t 
	INNER JOIN inventario i ON t.id_tienda = i.id_tienda
    WHERE i.id_inventario = vn_idTienda;
END $$ 
DELIMITER $$




-- SP para mostrar inventario segun id_tienda del empleado
DELIMITER $$
CREATE PROCEDURE sp_mostrarProductosInventario(
	IN vn_idTienda INT
)
BEGIN
SELECT d.id_detalle_inventario,
	p.nombre, 
	d.cantidad,
    d.valor_unitario,
    d.valor_stock, 
    d.stock_minimo, 
    d.stock_maximo 
FROM inventario i
	INNER JOIN detalle_inventario d ON i.id_inventario = d.id_inventario
    INNER JOIN producto p ON p.id_producto = d.id_producto
    WHERE i.id_tienda = vn_idTienda;
END $$
DELIMITER $$

-- SP para mostrar ingresos inventario
DELIMITER $$
CREATE PROCEDURE sp_mostrarIngresosInventario(
    IN vn_idTienda INT
)
BEGIN
    SELECT i.id_ingreso,
           t.nombre ,
           u.nombre,
           i.fecha,
           i.tipo_productos,
           i.motivo,
           i.valor_inventario
    FROM ingreso_inventario i
    INNER JOIN tienda t ON i.id_tienda = t.id_tienda
    INNER JOIN usuario u ON i.id_usuario = u.id_usuario
    WHERE i.id_tienda = vn_idTienda;
END $$
DELIMITER ;



-- SP para actualizar motivo ingreso inventario
DELIMITER $$
CREATE PROCEDURE sp_actualizarIngresoInventario(
	IN vn_idIngresoInventario INT,
    IN vv_nMotivo VARCHAR (30)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS alerta;
	END;
	START TRANSACTION;
	UPDATE ingreso_inventario
    SET
    motivo = COALESCE(vv_nMotivo,motivo)
    WHERE id_ingreso = vn_idIngresoInventario;
    COMMIT;
    
END $$
DELIMITER $$






-- actualizar detalles inventario
DELIMITER $$
CREATE PROCEDURE sp_actualizarDetallesInventario(
	IN vn_idDetalleInventario INT,
    IN vn_nCantidad INT,
    IN vn_nStockMinimo INT,
    IN vn_nStockMaximo INT
)
BEGIN
	DECLARE vn_nValorStock DECIMAL (10,2);
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS alerta;
	END;
	START TRANSACTION;
    
	UPDATE detalle_inventario
    SET
    cantidad = COALESCE(vn_nCantidad,cantidad),
    stock_minimo = COALESCE(vn_nStockMinimo,stock_minimo),
    stock_maximo = COALESCE(vn_nStockMaximo,stock_maximo)
    WHERE id_detalle_inventario = vn_idDetalleInventario;
    
    SET vn_nValorStock = (
		SELECT cantidad * valor_unitario
        FROM detalle_inventario
        WHERE id_detalle_inventario = vn_idDetalleInventario
    );
    
    UPDATE detalle_inventario
    SET valor_stock = vn_nValorStock
    WHERE id_detalle_inventario = vn_IdDetalleInventario;
    
    COMMIT;
    
END $$
DELIMITER $$



-- SP eliminacion detalle inventario
DELIMITER $$
CREATE PROCEDURE sp_eliminarDetalleInventario(
	IN vn_idDetalleInventario INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
	END;
	START TRANSACTION;
		DELETE FROM detalle_inventario
        WHERE id_detalle_inventario = vn_idDetalleInventario;
    COMMIT;
END $$
DELIMITER $$

DELIMITER $$
-- SP registrar ingreso inventario
CREATE PROCEDURE sp_ingresoInventario(
	IN vn_idTienda INT,
    IN vn_idUsuario INT,
    IN vv_motivo VARCHAR(30)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
	END;
    START TRANSACTION;
    INSERT INTO ingreso_inventario(id_tienda,id_usuario,fecha,motivo)
    VALUES (vn_idTienda,vn_idUsuario,NOW(),vv_motivo);
    
    COMMIT;
END $$
DELIMITER $$

-- SP eliminar ingreso inventario
DELIMITER $$
CREATE PROCEDURE sp_eliminarIngresoInventario(
	IN vn_IdIngreso INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
	END;
	START TRANSACTION;
		DELETE FROM ingreso_inventario
        WHERE id_ingreso = vn_idIngreso;
    COMMIT;
END $$
DELIMITER $$





-- SP mostrar detalles ingreso segun id_inventario
DELIMITER $$
CREATE PROCEDURE sp_mostrarDetallesIngreso (
	IN vn_idIngreso INT
)
BEGIN
	SELECT d.id_detalle_ingreso,
    p.nombre,
    d.cantidad
    FROM detalle_ingreso d 
    INNER JOIN producto p ON d.id_producto = p.id_producto
    WHERE d.id_ingreso = vn_idIngreso ;
END $$
DELIMITER $$




-- SP agregar detalle de ingreso inventario
DELIMITER $$
CREATE PROCEDURE sp_agregarDetalleInventario(
	IN vn_idInventario INT,
    IN vn_idProducto INT,
    IN vn_cantidad INT,
    IN vn_stockMinimo INT,
    IN vn_stockMaximo INT
)
BEGIN
	DECLARE vn_valorUnitario INT;
    DECLARE vn_valorStock INT;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        resignal;
    END;
    
    START TRANSACTION;
    
    SELECT precio INTO vn_valorUnitario
    FROM producto
    WHERE id_producto = vn_idProducto;
    
	SET vn_valorStock = vn_valorUnitario * vn_cantidad;
    
    INSERT INTO detalle_inventario(id_inventario,id_producto,cantidad,valor_unitario,valor_stock,stock_minimo,stock_maximo)
    VALUES (vn_idInventario,vn_idProducto,vn_cantidad,vn_valorUnitario,vn_valorStock,vn_stockMinimo,vn_stockMaximo);
    
    COMMIT;
END $$
DELIMITER $$



-- Fn calcular valor total del inventario
DELIMITER $$ 
CREATE FUNCTION fn_calcularValorInventario(
	vn_idInventario INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE vn_valorTotal DECIMAL(10,2);
    SELECT SUM(valor_stock) INTO vn_valorTotal
    FROM detalle_inventario
    WHERE id_inventario = vn_idInventario;
    RETURN IFNULL(vn_valorTotal,0);
    
END$$
DELIMITER $$



-- Fn calcular Stock total del inventario
DELIMITER $$
CREATE FUNCTION fn_calcularStockTotalInventario(
	vn_idInventario INT
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE vn_totalStock INT;
    
    SELECT SUM(cantidad) INTO vn_totalStock
    FROM detalle_inventario
    WHERE id_inventario = vn_idInventario;
    
    RETURN IFNULL(vn_totalStock,0);
END $$
DELIMITER $$



-- calcular cantidad de tipo de productos en el inventario
DELIMITER $$
CREATE FUNCTION fn_calcularCantidadTipoProducto(
	vn_idInventario INT
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE vn_tipoProductos INT;
    SELECT COUNT(*) INTO vn_tipoProductos
    FROM detalle_inventario
    WHERE id_inventario = vn_idInventario;
    RETURN IFNULL(vn_tipoProductos,0);
END $$
DELIMITER $$



-- SP para llamar en triggers de detalle_inventario
DELIMITER $$
CREATE PROCEDURE sp_actualizarInfoInventario(
	IN vn_idInventario INT
)
BEGIN
	DECLARE vn_stockTotal INT;
	DECLARE vn_valorTotal DECIMAL(10,2);
    DECLARE vn_tipoProductos INT;
    
    
    
    SET vn_stockTotal = fn_calcularStockTotalInventario(vn_idInventario);
    SET vn_valorTotal = fn_calcularValorInventario(vn_idInventario);
    SET vn_tipoProductos = fn_calcularCantidadTipoProducto(vn_idInventario);
    
    UPDATE inventario
    SET
    stock_total = COALESCE(vn_stockTotal,stock_total),
    valor_total = COALESCE(vn_valorTotal,valor_total),
    tipo_productos = COALESCE(vn_tipoProductos,tipo_productos),
    fecha_cambio = NOW()
    WHERE id_inventario = vn_idInventario;
	
END $$
DELIMITER $$


-- tgr para actualizar Info inventario despues de insertar detalle inventario
DELIMITER $$
CREATE TRIGGER tgr_ai_actualizarTotalInventario
AFTER INSERT ON detalle_inventario
FOR EACH ROW
BEGIN
	CALL sp_actualizarInfoInventario(NEW.id_inventario);
    
END $$
DELIMITER $$


-- tgr para actualizar Info inventario despues de actualizar detalle inventario
DELIMITER $$
CREATE TRIGGER tgr_au_actualizarTotalInventario
AFTER UPDATE ON detalle_inventario
FOR EACH ROW
BEGIN
	CALL sp_actualizarInfoInventario(NEW.id_inventario);
	
END $$
DELIMITER $$


-- tgr para actualizar Info inventario despues de eliminar detalle inventario
DELIMITER $$
CREATE TRIGGER tgr_ad_actualizarTotalInventario
AFTER DELETE ON detalle_inventario
FOR EACH ROW
BEGIN
	CALL sp_actualizarInfoInventario(OLD.id_inventario);
END $$
DELIMITER $$




-- DETALLES INVETARIO
-- DETALLES INVENTARIO
-- DETALLES INVENTARIO



-- SP para registrar detalles de ingreso
DELIMITER $$
CREATE PROCEDURE sp_registrarDetalleIngreso(
	IN vn_idIngreso INT,
    IN vn_idProducto INT,
    IN vn_cantidad INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
    END;
    
    START TRANSACTION ;
		INSERT INTO detalle_ingreso(id_ingreso,id_producto,cantidad)
        VALUES (vn_idIngreso,vn_idProducto,vn_cantidad);
    COMMIT;
END $$
DELIMITER $$ 



DELIMITER $$
CREATE PROCEDURE sp_actualizarDetalleIngreso (
	IN vn_idDetalleIngreso INT,
    IN vn_nCantidad INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
    END;
    
    START TRANSACTION ;

	UPDATE detalle_ingreso
    SET
    cantidad = COALESCE(vn_nCantidad,cantidad)
    WHERE id_detalle_ingreso = vn_idDetalleIngreso;
    COMMIT;
END $$
DELIMITER $$







DELIMITER $$
CREATE PROCEDURE sp_eliminarDetalleIngreso(
	IN vn_idDetalleIngreso INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
	END;
	START TRANSACTION;
		DELETE FROM detalle_ingreso
        WHERE id_detalle_ingreso = vn_idDetalleIngreso;
    COMMIT;
END $$
DELIMITER $$



-- SP para consultar todos los productos
DELIMITER $$
CREATE PROCEDURE sp_ConsultarTodoProducto (
)
BEGIN
	SELECT id_producto,
    nombre
    FROM producto;
END $$
DELIMITER $$





-- CRUD TERMINADO
-- DETALLE INVENTARIO
-- FALTAN TRIGERRS A IMPLEMENTER JUNTO A DETALLES ingreso,traslado y venta







-- INICIO CRUD
-- TRASLADO


DELIMITER $$
CREATE PROCEDURE sp_mostrarTrasladoInventario (
    IN vn_idTienda INT
)
BEGIN
    SELECT 
        tr.id_traslado,
        u.nombre,
        t_origen.nombre AS origen,
        t_destino.nombre AS destino,
        tr.fecha
    FROM traslado tr
    INNER JOIN usuario u ON tr.id_usuario = u.id_usuario
    INNER JOIN tienda t_origen ON tr.id_tienda_origen = t_origen.id_tienda
    INNER JOIN tienda t_destino ON tr.id_tienda_destino = t_destino.id_tienda
    WHERE tr.id_tienda_origen = vn_idTienda 
       OR tr.id_tienda_destino = vn_idTienda;
END $$
DELIMITER ;




-- SP necesario para registrar desde el front
DELIMITER $$
CREATE PROCEDURE sp_seleccionarTienda (
)
BEGIN
	SELECT id_tienda,nombre
    FROM tienda;
END $$
DELIMITER $$








DELIMITER $$
CREATE PROCEDURE sp_registrarTrasladoInventario(
	IN vn_idTiendaOrigen INT,
    IN vn_idTiendaDestino INT,
    IN vn_idUsuario INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
    END;
    
    START TRANSACTION ;
		INSERT INTO traslado(id_tienda_origen,id_tienda_destino,id_usuario,fecha)
        VALUES (vn_idTiendaOrigen,vn_idTiendaDestino,vn_idUsuario, NOW());
    COMMIT;
END $$
DELIMITER $$





DELIMITER $$
CREATE PROCEDURE sp_actualizarTrasladoInventario (
	IN vn_idTraslado INT,
    IN vn_nIdTiendaOrigen INT,
    IN vn_nIdTiendaDestino INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
    END;
    
    START TRANSACTION ;

	UPDATE traslado
    SET
    id_tienda_origen = COALESCE(vn_nIdTiendaOrigen,id_tienda_origen),
    id_tienda_destino = COALESCE(vn_nIdTiendaDestino,id_tienda_destino)
    WHERE id_traslado = vn_idTraslado;
    COMMIT;
END $$
DELIMITER $$



DELIMITER $$
CREATE PROCEDURE sp_eliminarTraslado(
	IN vn_idTraslado INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
	END;
	START TRANSACTION;
		DELETE FROM traslado
        WHERE id_traslado = vn_idTraslado;
    COMMIT;
	
END $$
DELIMITER $$





-- CRUD
-- DETALLE TRASLADO






-- SP mostrar detalles Traslado segun id_inventario
DELIMITER $$
CREATE PROCEDURE sp_mostrarDetalleTraslado (
	IN vn_idTraslado INT
)
BEGIN
	SELECT d.id_detalle_traslado,
    p.nombre,
    d.cantidad
    FROM detalle_traslado d 
    INNER JOIN producto p ON d.id_producto = p.id_producto
    WHERE d.id_traslado = vn_idTraslado;
END $$
DELIMITER $$




-- SP para registrar detalles de Traslado
DELIMITER $$
CREATE PROCEDURE sp_registrarDetalleTraslado(
	IN vn_idTraslado INT,
    IN vn_idProducto INT,
    IN vn_cantidad INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
    END;
    
    START TRANSACTION ;
		INSERT INTO detalle_traslado(id_traslado,id_producto,cantidad)
        VALUES (vn_idTraslado,vn_idProducto,vn_cantidad);
    COMMIT;
END $$
DELIMITER $$ 





DELIMITER $$
CREATE PROCEDURE sp_actualizarDetalleTraslado (
	IN vn_idDetalleTraslado INT,
    IN vn_nCantidad INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
    END;
    
    START TRANSACTION ;

	UPDATE detalle_traslado
    SET
    cantidad = COALESCE(vn_nCantidad,cantidad)
    WHERE id_detalle_traslado = vn_idDetalleTraslado;
    COMMIT;
END $$
DELIMITER $$






DROP PROCEDURE  sp_eliminarDetalleTraslado;
DELIMITER $$
CREATE PROCEDURE sp_eliminarDetalleTraslado(
	IN vn_idDetalleTraslado INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
	END;
	START TRANSACTION;
		DELETE FROM detalle_traslado
        WHERE id_detalle_traslado = vn_idDetalleTraslado;
    COMMIT;
END $$
DELIMITER $$






-- CRUD
-- VENTAS


DROP PROCEDURE sp_mostrarVenta;
DELIMITER $$
CREATE PROCEDURE sp_mostrarVenta (
    IN vn_idTienda INT
)
BEGIN
    SELECT v.id_venta,
    v.fecha,
    v.total,
    t.nombre,
    u.nombre
    FROM venta v
    INNER JOIN tienda t ON v.id_tienda = t.id_tienda
    INNER JOIN usuario u ON v.id_usuario = u.id_usuario
    WHERE v.id_tienda = vn_idTienda;
END $$
DELIMITER ;






DELIMITER $$
CREATE PROCEDURE sp_registrarVenta(
    IN vn_idTienda INT,
    IN vn_idUsuario INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
    END;
    
    START TRANSACTION ;
		INSERT INTO venta(fecha,id_tienda,id_usuario)
        VALUES (NOW(),vn_idTienda,vn_idUsuario);
    COMMIT;
END $$
DELIMITER $$




-- NO HAY NADA QUE EL USUARIO PUEDA ACTUALIZAR


DELIMITER $$
CREATE PROCEDURE sp_eliminarVenta(
	IN vn_idVenta INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
	END;
	START TRANSACTION;
		DELETE FROM venta
        WHERE id_venta = vn_idVenta;
    COMMIT;
	
END $$
DELIMITER $$






-- CRUD
-- DETALLES VENTAS 



-- SP mostrar detalles Traslado segun id_inventario
DELIMITER $$
CREATE PROCEDURE sp_mostrarDetalleVenta (
	IN vn_idVenta INT
)
BEGIN
	SELECT d.id_detalle,
    p.nombre,
    d.cantidad,
    p.precio,
    d.total
    FROM detalle_venta d 
    INNER JOIN producto p ON d.id_producto = p.id_producto
    WHERE d.id_venta = vn_idVenta;
END $$
DELIMITER $$







-- FN para seleccionar precio producto
DELIMITER $$
CREATE FUNCTION fn_seleccionarPrecioProducto(
	vn_idProducto INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE vn_valorProducto DECIMAL(10,2);
	SELECT precio INTO vn_valorProducto
    FROM producto 
    WHERE id_producto = vn_idProducto;
	    
    RETURN IFNULL(vn_valorProducto,0);
END $$
DELIMITER $$




-- FN para calcular valor total detalle de venta
DELIMITER $$
CREATE FUNCTION fn_calcularTotalDetalleVenta(
	vn_idProducto INT,
    vn_cantidad DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE vn_valorTotal DECIMAL(10,2);
    DECLARE vn_valorProducto DECIMAL (10,2);
    
    SET vn_valorProducto = fn_seleccionarPrecioProducto(vn_idProducto);
    
    SET vn_valorTotal = vn_cantidad * vn_valorProducto;
    
    RETURN IFNULL(vn_valorTotal,0);
END $$
DELIMITER $$













-- SP para registrar detalles de Venta
DELIMITER $$
CREATE PROCEDURE sp_registrarDetalleVenta(
	IN vn_idVenta INT,
    IN vn_idProducto INT,
    IN vn_cantidad INT
)
BEGIN
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
    END;
    
    START TRANSACTION ;
		INSERT INTO detalle_venta(cantidad,precio_unitario,id_venta,id_producto,total)
        VALUES (vn_cantidad,fn_seleccionarPrecioProducto(vn_idProducto),vn_idVenta,vn_idProducto,fn_calcularTotalDetalleVenta(vn_idProducto,vn_cantidad));
    COMMIT;
END $$
DELIMITER $$ 







DELIMITER $$
CREATE PROCEDURE sp_actualizarDetalleVenta (
	IN vn_idDetalle INT,
    IN vn_nCantidad INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado,' AS Alerta;
    END;
    
    START TRANSACTION ;

	UPDATE detalle_venta
    SET
    cantidad = COALESCE(vn_nCantidad,cantidad),
    total = IFNULL(vn_nCantidad * precio_unitario,0)
    WHERE id_detalle = vn_idDetalle;
    COMMIT;
END $$
DELIMITER $$








DROP PROCEDURE  sp_eliminarDetalleVenta;
DELIMITER $$
CREATE PROCEDURE sp_eliminarDetalleVenta(
	IN vn_idDetalle INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
	END;
	START TRANSACTION;
		DELETE FROM detalle_venta
        WHERE id_detalle = vn_idDetalle;
    COMMIT;
END $$
DELIMITER $$




-- TRIGGERS PARA DETALLE INVENTARIO  




-- Fn que calcula valor total de una venta para sp de tgr  
DELIMITER $$ 
CREATE FUNCTION fn_calcularValorTotalVenta(
	vn_idVenta INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE vn_valorTotal DECIMAL(10,2);
    
    SELECT SUM(total) INTO vn_valorTotal
    FROM detalle_venta
    WHERE id_venta = vn_idVenta;
    RETURN IFNULL(vn_valorTotal,0);
    
END$$
DELIMITER $$




-- SP para ser llamado por triggers de detalle venta que actualiza total tabla venta
DELIMITER $$
CREATE PROCEDURE sp_actualizarTotalVenta(
	IN vn_idVenta INT
)
BEGIN

	DECLARE vn_valorTotal DECIMAL(10,2);
    
    SET vn_valorTotal = fn_calcularValorTotalVenta(vn_idVenta);
    
    
    UPDATE venta
    SET
    total = COALESCE(vn_valorTotal,total)
    WHERE id_venta = vn_idVenta;
	
END $$
DELIMITER $$





-- SP para actualizar cantidad de detalle inventario por descuento de detalle venta 
DELIMITER $$ 
CREATE PROCEDURE sp_actualizarCantidadDetalleVenta( 
	IN vn_idProducto INT, 
    IN vn_descuentoOriginal INT, 
    IN vn_descuentoNuevo INT 
) BEGIN 
	DECLARE vn_diferenciaCantidad INT;
    DECLARE vn_cantidadDetalleInventario INT; 
    DECLARE vn_ajusteFinal INT; 
    
    SET vn_diferenciaCantidad = vn_descuentoOriginal - vn_descuentoNuevo ; 
    
    SELECT cantidad INTO vn_cantidadDetalleInventario 
    FROM detalle_inventario 
    WHERE id_producto = vn_idProducto; 
    
    SET vn_ajusteFinal = vn_cantidadDetalleInventario + vn_diferenciaCantidad ; 
    
    IF vn_ajusteFinal < 0 THEN 
    
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente'; 
    
    END IF; 
    
    UPDATE detalle_inventario 
    SET cantidad = COALESCE(vn_ajusteFinal,cantidad) 
    WHERE id_producto = vn_idProducto; 
    
END $$ 
DELIMITER $$ 
    




DELIMITER $$
CREATE TRIGGER tgr_ai_actualizarInfoVentaJuntoDetalleInventario
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
   
    CALL sp_actualizarTotalVenta(NEW.id_venta);

  
    CALL sp_actualizarCantidadDetalleVenta(NEW.id_producto, 0, NEW.cantidad);

    
    CALL sp_actualizarInfoInventario((SELECT id_inventario 
                                      FROM detalle_inventario 
                                      WHERE id_producto = NEW.id_producto));
END$$
DELIMITER $$


DROP TRIGGER  tgr_au_actualizarInfoVentaJuntoDetalleInvetario;
-- tgr para actualizar total venta despues de actualizar detalle venta


DELIMITER $$
CREATE TRIGGER tgr_au_actualizarInfoVentaJuntoDetalleInvetario
AFTER UPDATE ON detalle_venta
FOR EACH ROW
BEGIN
	CALL sp_actualizarTotalVenta(NEW.id_venta);
    CALL sp_actualizarCantidadDetalleVenta (NEW.id_producto,OLD.cantidad,NEW.cantidad);
END $$
DELIMITER $$






-- -- calcular cantidad de tipo de productos en el inventario
DELIMITER $$
CREATE FUNCTION fn_calcularCantidadTipoProductoIngreso(
	vn_idIngreso INT
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE vn_tipoProductos INT;
    SELECT COUNT(*) INTO vn_tipoProductos
    FROM detalle_ingreso
    WHERE id_ingreso = vn_idIngreso;
    RETURN IFNULL(vn_tipoProductos,0);
END $$
DELIMITER $$


DELIMITER $$
CREATE FUNCTION fn_calcularValorInventarioIngreso(
    vn_idIngreso INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE vn_valorTotal DECIMAL(10,2);

    SELECT IFNULL(SUM(di.cantidad * p.precio), 0)
    INTO vn_valorTotal
    FROM detalle_ingreso di
    INNER JOIN producto p ON di.id_producto = p.id_producto
    WHERE di.id_ingreso = vn_idIngreso;

    RETURN vn_valorTotal;
END $$
DELIMITER ;



DELIMITER $$
CREATE TRIGGER trg_after_insert_detalle_ingreso
AFTER INSERT ON detalle_ingreso
FOR EACH ROW
BEGIN

    UPDATE ingreso_inventario
    SET tipo_productos = fn_calcularCantidadTipoProductoIngreso(NEW.id_ingreso)
    WHERE id_ingreso = NEW.id_ingreso;


    UPDATE ingreso_inventario
    SET valor_inventario = fn_calcularValorInventarioIngreso(NEW.id_ingreso)
    WHERE id_ingreso = NEW.id_ingreso;
END $$
DELIMITER $$

-- AFTER UPDATE
CREATE TRIGGER trg_after_update_detalle_ingreso
AFTER UPDATE ON detalle_ingreso
FOR EACH ROW
BEGIN

    UPDATE ingreso_inventario
    SET tipo_productos = fn_calcularCantidadTipoProductoIngreso(NEW.id_ingreso)
    WHERE id_ingreso = NEW.id_ingreso;

   
    UPDATE ingreso_inventario
    SET valor_inventario = fn_calcularValorInventarioIngreso(NEW.id_ingreso)
    WHERE id_ingreso = NEW.id_ingreso;
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_after_delete_detalle_ingreso
AFTER DELETE ON detalle_ingreso
FOR EACH ROW
BEGIN

    UPDATE ingreso_inventario
    SET tipo_productos = fn_calcularCantidadTipoProductoIngreso(OLD.id_ingreso)
    WHERE id_ingreso = OLD.id_ingreso;

    UPDATE ingreso_inventario
    SET valor_inventario = fn_calcularValorInventarioIngreso(OLD.id_ingreso)
    WHERE id_ingreso = OLD.id_ingreso;
END $$
DELIMITER ;





DELIMITER $$
CREATE PROCEDURE sp_actualizarCantidadDetalleInventarioPorIngreso(
    IN vn_idProducto INT,
    IN vn_cantidadOriginal INT,
    IN vn_cantidadNueva INT
)
BEGIN
    DECLARE vn_diferenciaCantidad INT;
    DECLARE vn_cantidadDetalleInventario INT;
    DECLARE vn_ajusteFinal INT;

    -- Diferencia entre cantidad original y nueva
    SET vn_diferenciaCantidad = vn_cantidadNueva - vn_cantidadOriginal;

    -- Obtener cantidad actual en detalle_inventario
    SELECT cantidad INTO vn_cantidadDetalleInventario
    FROM detalle_inventario
    WHERE id_producto = vn_idProducto;

    SET vn_cantidadDetalleInventario = IFNULL(vn_cantidadDetalleInventario,0);

    SET vn_ajusteFinal = vn_cantidadDetalleInventario + vn_diferenciaCantidad;

    -- Validación de stock negativo
    IF vn_ajusteFinal < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;

    -- Actualizar inventario
    UPDATE detalle_inventario
    SET cantidad = vn_ajusteFinal
    WHERE id_producto = vn_idProducto;

END$$
DELIMITER $$










DELIMITER //


CREATE PROCEDURE sp_mostrarCategorias()
BEGIN
    SELECT id_categoria, nombre
    FROM categoria_producto
    ORDER BY id_categoria;
END;
//

CREATE PROCEDURE sp_registrarCategoria(
    IN vv_nombre VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS alerta;
    END;
    START TRANSACTION;
    INSERT INTO categoria_producto(nombre) VALUES (vv_nombre);
    COMMIT;
END;
//

CREATE PROCEDURE sp_actualizarCategoria(
    IN vn_idCategoria INT,
    IN vv_nNombre VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS alerta;
    END;
    START TRANSACTION;
    UPDATE categoria_producto
    SET nombre = COALESCE(vv_nNombre, nombre)
    WHERE id_categoria = vn_idCategoria;
    COMMIT;
END;
//

CREATE PROCEDURE sp_eliminarCategoria(IN vn_idCategoria INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS alerta;
    END;
    START TRANSACTION;
    DELETE FROM categoria_producto WHERE id_categoria = vn_idCategoria;
    COMMIT;
END;
//


CREATE PROCEDURE sp_mostrarProductos()
BEGIN
    SELECT
        p.id_producto,
        p.id_categoria,
        c.nombre AS categoria,
        p.nombre,
        p.talla,
        p.color,
        p.precio
    FROM producto p
    LEFT JOIN categoria_producto c ON p.id_categoria = c.id_categoria
    ORDER BY p.id_producto;
END;
//

CREATE PROCEDURE sp_registrarProducto(
    IN vn_idCategoria INT,
    IN vv_nombre VARCHAR(50),
    IN vv_talla VARCHAR(20),
    IN vv_color VARCHAR(20),
    IN vn_precio DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
    END;
    START TRANSACTION;
    INSERT INTO producto(id_categoria, nombre, talla, color, precio)
    VALUES (vn_idCategoria, vv_nombre, vv_talla, vv_color, vn_precio);
    COMMIT;
END;
//

CREATE PROCEDURE sp_seleccionarCategoria()
BEGIN
    SELECT id_categoria, nombre
    FROM categoria_producto
    ORDER BY nombre;
END;
//

CREATE PROCEDURE sp_actualizarProducto(
    IN vn_idProducto INT,
    IN vn_nIdCategoria INT,
    IN vv_nNombre VARCHAR(50),
    IN vv_nTalla VARCHAR(20),
    IN vv_nColor VARCHAR(20),
    IN vn_nPrecio DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en el proceso, rollback activado' AS Alerta;
    END;
    START TRANSACTION;
    UPDATE producto
    SET
        id_categoria = COALESCE(vn_nIdCategoria, id_categoria),
        nombre = COALESCE(vv_nNombre, nombre),
        talla = COALESCE(vv_nTalla, talla),
        color = COALESCE(vv_nColor, color),
        precio = COALESCE(vn_nPrecio, precio)
    WHERE id_producto = vn_idProducto;
    COMMIT;
END;
//

DELIMITER ;
