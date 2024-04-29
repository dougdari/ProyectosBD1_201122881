CREATE DATABASE proyecto2bd1;


CREATE TABLE historial (
    fecha DATETIME NOT NULL,
    descripcion VARCHAR(250) NOT NULL,
    tipo VARCHAR(250) NOT NULL
);

CREATE TABLE tipo_cuenta (
    codigo INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(250) NOT NULL,
    descripcion VARCHAR(250) NOT NULL
) AUTO_INCREMENT=1;
	
CREATE TABLE tipo_cliente (
    tipo_cliente INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(250) NOT NULL,
    descripcion VARCHAR(250) NOT NULL
) AUTO_INCREMENT=1;

CREATE TABLE tipo_transaccion (
    id_tipo INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(250) NOT NULL,
    descripcion VARCHAR(250) NOT NULL
) AUTO_INCREMENT=1;

CREATE TABLE cliente (
    id_cliente INTEGER PRIMARY KEY,
    nombre VARCHAR(250) NOT NULL,
    apellido VARCHAR(250) NOT NULL,
    usuario VARCHAR(250) NOT NULL,
    contrasena VARCHAR(250) NOT NULL,
    fecha DATETIME,
    tipo_cliente INTEGER NOT NULL,
    FOREIGN KEY (tipo_cliente) REFERENCES tipo_cliente(tipo_cliente)
);

CREATE TABLE telefono (
    id_cliente INTEGER PRIMARY KEY,
    telefono VARCHAR(250) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE correo (
    id_cliente INTEGER PRIMARY KEY,
    correo VARCHAR(250) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);
	
CREATE TABLE cuenta (
    id_cuenta INTEGER PRIMARY KEY,
    monto_apertura DECIMAL(12,2) NOT NULL,
    saldo_cuenta DECIMAL(12,2) NOT NULL,
    descripcion VARCHAR(250) NOT NULL,
    fecha_apertura DATETIME NOT NULL,
    otros_detalles VARCHAR(250) NOT NULL,
    tipo_cuenta INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE productos_servicios (
    codigo INTEGER PRIMARY KEY,
    tipo INTEGER NOT NULL,
    costo DECIMAL(12,2),
    descripcion VARCHAR(250) NOT NULL
);

CREATE TABLE compra (	
    id_compra INTEGER PRIMARY KEY,
    fecha DATETIME NOT NULL,
    importe_compra DECIMAL(12,2),
    otros_detalles VARCHAR(250),
    codigo_producto_servicio INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    FOREIGN KEY (codigo_producto_servicio) REFERENCES productos_servicios(codigo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);	

CREATE TABLE debito (
    id_debito INTEGER PRIMARY KEY,
    fecha DATETIME NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    otros_detalles VARCHAR(250),
    id_cliente INTEGER NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE deposito (
    id_deposito INTEGER PRIMARY KEY,
    fecha DATETIME NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    otros_detalles VARCHAR(250),
    id_cliente INTEGER NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE transaccion (
    id_transaccion INTEGER PRIMARY KEY AUTO_INCREMENT,
    fecha DATETIME NOT NULL,
    otros_detalles VARCHAR(250),
    id_tipo_transaccion INTEGER NOT NULL,
    id_operacion INTEGER NOT NULL,
    no_cuenta INTEGER NOT NULL,
    FOREIGN KEY (id_tipo_transaccion) REFERENCES tipo_transaccion(id_tipo),
    FOREIGN KEY (no_cuenta) REFERENCES cuenta(id_cuenta)
);

	