 -- consulta de saldo

DELIMITER //

CREATE PROCEDURE consultarSaldoCliente(
    IN p_id_cuenta INTEGER
)
BEGIN
    DECLARE error_message VARCHAR(250);

    -- Validar que la cuenta exista
    IF NOT EXISTS (SELECT 1 FROM cuenta WHERE id_cuenta = p_id_cuenta) THEN
        SET error_message = 'Error: La cuenta especificada no existe.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Consultar los datos del cliente, tipo de cliente, tipo de cuenta y saldo de la cuenta
    SELECT c.nombre AS "Nombre cliente",
           tc.nombre AS "Tipo cliente",
           tcu.nombre AS "Tipo cuenta",
           cu.saldo_cuenta AS "Saldo cuenta",
           cu.monto_apertura AS "Saldo apertura"
    FROM cliente c
    INNER JOIN tipo_cliente tc ON c.tipo_cliente = tc.tipo_cliente
    INNER JOIN cuenta cu ON c.id_cliente = cu.id_cliente
    INNER JOIN tipo_cuenta tcu ON cu.tipo_cuenta = tcu.codigo
    WHERE cu.id_cuenta = p_id_cuenta;
END //

DELIMITER ;

-- consulta cliente --
DELIMITER //

CREATE PROCEDURE consultarCliente(
    IN p_id_cliente INTEGER
)
consultar_cliente: BEGIN
    -- Variables para almacenar los resultados concatenados
    DECLARE error_message VARCHAR(250);	
    DECLARE telefonos_concat VARCHAR(1000);
    DECLARE correos_concat VARCHAR(1000);
    DECLARE tipos_cuenta_concat VARCHAR(1000);
    DECLARE num_cuentas INTEGER;

	IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SET error_message = 'Error: El cliente con el ID especificado no existe.';
        SELECT error_message AS "Mensaje";
        LEAVE consultar_cliente;
    END IF;

    -- Concatenar los números de teléfono del cliente
    SELECT GROUP_CONCAT(telefono SEPARATOR ', ') INTO telefonos_concat FROM telefono WHERE id_cliente = p_id_cliente;

    -- Concatenar las direcciones de correo del cliente
    SELECT GROUP_CONCAT(correo SEPARATOR ', ') INTO correos_concat FROM correo WHERE id_cliente = p_id_cliente;

    -- Contar el número de cuentas asociadas al cliente
    
    SELECT COUNT(*) INTO num_cuentas FROM cuenta WHERE id_cliente = p_id_cliente;

    -- Concatenar los nombres de tipo de cuenta que posee el cliente
    SELECT GROUP_CONCAT(tc.nombre SEPARATOR ', ') INTO tipos_cuenta_concat
    FROM tipo_cuenta tc
    INNER JOIN cuenta c ON tc.codigo = c.tipo_cuenta
    WHERE c.id_cliente = p_id_cliente;

    -- Consultar los datos del cliente y mostrar los resultados
    SELECT 
        id_cliente AS "Id cliente",
        CONCAT(nombre, ' ', apellido) AS "Nombre completo",
        fecha AS "Fecha creacion",
        usuario AS "Usuario",
        telefonos_concat AS "Telefono(s)",
        correos_concat AS "Correo(s)",
        num_cuentas AS "No Cuenta(s)",
        tipos_cuenta_concat AS "Tipo(s) de cuenta que posee"
    FROM cliente
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;

-- consultar movimientos cliente

DELIMITER //

CREATE PROCEDURE consultarMovsCliente(
    IN p_id_cliente INTEGER
)
consultar_movs_cliente: BEGIN
    DECLARE error_message VARCHAR(250);

    -- Validar si el cliente existe
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SET error_message = 'Error: El cliente con el ID especificado no existe.';
        SELECT error_message AS "Mensaje";
        LEAVE consultar_movs_cliente;
    END IF;

    -- Consultar las transacciones del cliente y mostrar los resultados
    SELECT
        t.id_transaccion AS 'Id transaccion',
        tt.nombre AS 'Tipo transaccion',
        CASE
            WHEN t.id_tipo_transaccion = 1 THEN (SELECT c.importe_compra FROM compra c WHERE c.id_compra = t.id_operacion)
            WHEN t.id_tipo_transaccion = 2 THEN (SELECT d.monto FROM deposito d WHERE d.id_deposito = t.id_operacion)
            WHEN t.id_tipo_transaccion = 3 THEN (SELECT d.monto FROM debito d WHERE d.id_debito = t.id_operacion)
            ELSE NULL
        END AS 'Monto',
        tt2.nombre AS 'Operacion',
        tc.nombre AS 'Tipo cuenta'
    FROM transaccion t
    INNER JOIN tipo_transaccion tt ON t.id_tipo_transaccion = tt.id_tipo
    LEFT JOIN tipo_transaccion tt2 ON t.id_tipo_transaccion = tt2.id_tipo
    LEFT JOIN cuenta c ON t.no_cuenta = c.id_cuenta
    LEFT JOIN tipo_cuenta tc ON c.tipo_cuenta = tc.codigo
    WHERE c.id_cliente = p_id_cliente;

  
END //

DELIMITER ;

-- Consultar clientes por tipo de cuenta
DELIMITER //

CREATE PROCEDURE consultarTipoCuentas(IN codigo_param INT)
BEGIN
    DECLARE tipo_existente INT;
    DECLARE tipo_nombre VARCHAR(250);
    DECLARE tipo_cuenta_count INT;
    
    -- Verificar si el código existe en la tabla tipo_cuenta
    SELECT COUNT(*) INTO tipo_existente FROM tipo_cuenta WHERE codigo = codigo_param;
    
    IF tipo_existente > 0 THEN
        -- Obtener el nombre del tipo de cuenta
        SELECT nombre INTO tipo_nombre FROM tipo_cuenta WHERE codigo = codigo_param;
        
        -- Obtener el conteo de clientes con ese tipo de cuenta
        SELECT COUNT(DISTINCT id_cliente) INTO tipo_cuenta_count FROM cuenta WHERE tipo_cuenta = codigo_param;
        
        -- Mostrar resultados
        SELECT codigo AS 'Codigo tipo cuenta', nombre AS 'Nombre cuenta', tipo_cuenta_count AS 'Cantidad de clientes'
        FROM tipo_cuenta WHERE codigo = codigo_param;
    ELSE
        -- Mostrar mensaje de error
        SELECT 'El tipo de cuenta con el código ', codigo_param, ' no existe.' AS 'Error';
    END IF;
    
END //

DELIMITER ;

-- Consulta movimientos generales por rango de fechas






DELIMITER //

CREATE PROCEDURE consultarMovsGenFech(IN fecha_inicio VARCHAR(10), IN fecha_fin VARCHAR(10))
BEGIN
    -- Variables para manejar las fechas
    DECLARE fecha_inicio_conv DATE;
    DECLARE fecha_fin_conv DATE;
    
    -- Convertir las fechas al formato DATE de MySQL
    SET fecha_inicio_conv = STR_TO_DATE(fecha_inicio, '%d/%m/%Y');
    SET fecha_fin_conv = STR_TO_DATE(fecha_fin, '%d/%m/%Y');
    
    -- Mostrar los movimientos según el rango de fechas
    SELECT 
        t.id_transaccion AS 'Id transaccion',
        tt.nombre AS 'Tipo transaccion',
        CASE
            WHEN t.id_tipo_transaccion = 1 THEN c.otros_detalles
            WHEN t.id_tipo_transaccion = 2 THEN dep.otros_detalles
            WHEN t.id_tipo_transaccion = 3 THEN deb.otros_detalles
        END AS 'Tipo de servicio',
        CASE
            WHEN t.id_tipo_transaccion = 1 THEN c.importe_compra
            WHEN t.id_tipo_transaccion = 2 THEN dep.monto
            WHEN t.id_tipo_transaccion = 3 THEN deb.monto
        END AS 'Monto',
        cl.nombre AS 'Nombre cliente',
        tc.nombre AS 'Tipo cuenta',
        t.fecha AS 'Fecha',
        t.otros_detalles AS 'Otros detalles'
    FROM 
        transaccion t
        INNER JOIN tipo_transaccion tt ON t.id_tipo_transaccion = tt.id_tipo
        INNER JOIN cuenta cu ON t.no_cuenta = cu.id_cuenta
        INNER JOIN cliente cl ON cu.id_cliente = cl.id_cliente
        INNER JOIN tipo_cuenta tc ON cu.tipo_cuenta = tc.codigo
        LEFT JOIN compra c ON t.id_operacion = c.id_compra AND t.id_tipo_transaccion = 1
        LEFT JOIN deposito dep ON t.id_operacion = dep.id_deposito AND t.id_tipo_transaccion = 2
        LEFT JOIN debito deb ON t.id_operacion = deb.id_debito AND t.id_tipo_transaccion = 3
    WHERE 
        t.fecha BETWEEN fecha_inicio_conv AND fecha_fin_conv;
    
END //

DELIMITER ;


-- consulta movimiento por rango de fecha filtrado por cliente

call consultarMovsFechClien(202401,'01/01/2020','01/01/2025');

DELIMITER //

CREATE PROCEDURE consultarMovsFechClien(IN id_cliente_param INT, IN fecha_inicio VARCHAR(10), IN fecha_fin VARCHAR(10))
BEGIN
    DECLARE cliente_existente INT;
    DECLARE fecha_inicio_conv DATE;
	DECLARE fecha_fin_conv DATE;
    
    -- Verificar si el cliente existe
    SELECT COUNT(*) INTO cliente_existente FROM cliente WHERE id_cliente = id_cliente_param;
    
    IF cliente_existente > 0 THEN
        -- Variables para manejar las fechas
        
        
        -- Convertir las fechas al formato DATE de MySQL
        SET fecha_inicio_conv = STR_TO_DATE(fecha_inicio, '%d/%m/%Y');
        SET fecha_fin_conv = STR_TO_DATE(fecha_fin, '%d/%m/%Y');
        
        -- Mostrar los movimientos según el rango de fechas y el cliente
        SELECT 
            t.id_transaccion AS 'Id transaccion',
            tt.nombre AS 'Tipo transaccion',
            CASE
                WHEN t.id_tipo_transaccion = 1 THEN c.otros_detalles
                WHEN t.id_tipo_transaccion = 2 THEN dep.otros_detalles
                WHEN t.id_tipo_transaccion = 3 THEN deb.otros_detalles
            END AS 'Tipo de servicio',
            CASE
                WHEN t.id_tipo_transaccion = 1 THEN c.importe_compra
                WHEN t.id_tipo_transaccion = 2 THEN dep.monto
                WHEN t.id_tipo_transaccion = 3 THEN deb.monto
            END AS 'Monto',
            cl.nombre AS 'Nombre cliente',
            tc.nombre AS 'Tipo cuenta',
            t.fecha AS 'Fecha',
            t.otros_detalles AS 'Otros detalles'
        FROM 
            transaccion t
            INNER JOIN tipo_transaccion tt ON t.id_tipo_transaccion = tt.id_tipo
            INNER JOIN cuenta cu ON t.no_cuenta = cu.id_cuenta
            INNER JOIN cliente cl ON cu.id_cliente = cl.id_cliente
            INNER JOIN tipo_cuenta tc ON cu.tipo_cuenta = tc.codigo
            LEFT JOIN compra c ON t.id_operacion = c.id_compra AND t.id_tipo_transaccion = 1
            LEFT JOIN deposito dep ON t.id_operacion = dep.id_deposito AND t.id_tipo_transaccion = 2
            LEFT JOIN debito deb ON t.id_operacion = deb.id_debito AND t.id_tipo_transaccion = 3
        WHERE 
            cl.id_cliente = id_cliente_param AND
            t.fecha BETWEEN fecha_inicio_conv AND fecha_fin_conv;
    ELSE
        -- Mostrar mensaje de error
        SELECT 'El cliente con el ID ', id_cliente_param, ' no existe.' AS 'Error';
    END IF;
    
END //

DELIMITER ;


-- productos --

call consultarProductoServicio();

DELIMITER //

CREATE PROCEDURE consultarProductoServicio()
BEGIN
    -- Listar las columnas especificadas de la tabla productos_servicios
    SELECT 
        codigo AS 'Codigo de servicio / producto',
        descripcion AS 'Nombre',
        concat('Tipo ', tipo) AS 'Descripcion',
        IF(tipo = 1, 'Servicio', 'Producto') AS 'Tipo'
    FROM 
        productos_servicios;
END //

DELIMITER ;
