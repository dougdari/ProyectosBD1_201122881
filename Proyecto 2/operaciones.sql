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