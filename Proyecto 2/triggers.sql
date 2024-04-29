
-- tabla tipo_cuenta

DELIMITER //
CREATE TRIGGER tipo_cuenta_after_insert
AFTER INSERT ON tipo_cuenta
FOR EACH ROW
BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), "Actividad en tabla tipo_cuenta", "INSERT");
END //


CREATE TRIGGER tipo_cuenta_after_update
AFTER UPDATE  ON tipo_cuenta
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla tipo_cuenta', 'UPDATE');
END //



-- tipo_cliente

DELIMITER //

CREATE TRIGGER tipo_cliente_after_insert
AFTER INSERT ON tipo_cliente
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla tipo_cliente', 'INSERT');
END//


CREATE TRIGGER tipo_cliente_after_update
AFTER UPDATE  ON tipo_cliente
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla tipo_cliente', 'UPDATE');
END//



-- tabla tipo_transaccion

DELIMITER //

CREATE TRIGGER tipo_transaccion_after_insert
AFTER INSERT ON tipo_transaccion
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tipo_transaccion', 'INSERT');
END//

CREATE TRIGGER tipo_transaccion_after_update
AFTER UPDATE  ON tipo_transaccion
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla tipo_transaccion', 'UPDATE');
END//


-- tabla cliente 

DELIMITER //

CREATE TRIGGER cliente_after_insert
AFTER INSERT ON cliente
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en cliente', 'INSERT');
END//

CREATE TRIGGER cliente_after_update
AFTER UPDATE  ON cliente
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla cliente', 'UPDATE');
END//


-- tabla telefono

DELIMITER //

CREATE TRIGGER telefono_after_insert
AFTER INSERT ON telefono
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en telefono', 'INSERT');
END//

CREATE TRIGGER telefono_after_update
AFTER UPDATE  ON telefono
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla telefono', 'UPDATE');
END//


-- tabla correo

DELIMITER //

CREATE TRIGGER correo_after_insert
AFTER INSERT ON correo
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en correo', 'INSERT');
END//

CREATE TRIGGER correo_after_update
AFTER UPDATE  ON correo
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla correo', 'UPDATE');
END//


-- tabla cuenta

DELIMITER //

CREATE TRIGGER cuenta_after_insert
AFTER INSERT ON cuenta
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en cuenta', 'INSERT');
END//

CREATE TRIGGER cuenta_after_update
AFTER UPDATE  ON cuenta
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla cuenta', 'UPDATE');
END//


-- tabla productos_servicios


DELIMITER //

CREATE TRIGGER productos_servicios_after_insert
AFTER INSERT ON productos_servicios
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en productos_servicios', 'INSERT');
END//

CREATE TRIGGER productos_servicios_after_update
AFTER UPDATE  ON productos_servicios
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla productos_servicios', 'UPDATE');
END//

-- tabla compra


DELIMITER //

CREATE TRIGGER compra_after_insert
AFTER INSERT ON compra
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en compra', 'INSERT');
END//

CREATE TRIGGER compra_after_update
AFTER UPDATE  ON compra
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla compra', 'UPDATE');
END//


-- tabla debito


DELIMITER //

CREATE TRIGGER debito_after_insert
AFTER INSERT ON debito
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en debito', 'INSERT');
END//

CREATE TRIGGER debito_after_update
AFTER UPDATE  ON debito
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla debito', 'UPDATE');
END//

-- tabla deposito


DELIMITER //

CREATE TRIGGER deposito_after_insert
AFTER INSERT ON deposito
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en deposito', 'INSERT');
END//

CREATE TRIGGER deposito_after_update
AFTER UPDATE  ON deposito
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla deposito', 'UPDATE');
END//

-- tabla transaccion

DELIMITER //

CREATE TRIGGER transaccion_after_insert
AFTER INSERT ON transaccion
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en transaccion', 'INSERT');
END//

CREATE TRIGGER transaccion_after_update
AFTER UPDATE  ON transaccion
FOR EACH ROW

BEGIN
		INSERT INTO historial (fecha, descripcion, tipo)
        VALUES (now(), 'Actividad en tabla transaccion', 'UPDATE');
END//
