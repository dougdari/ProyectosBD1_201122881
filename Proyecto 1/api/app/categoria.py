
import csv
from sqlalchemy.sql.expression import text
from flask import Flask,request,jsonify
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow


app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:123H%40mbre@localhost:3306/proyecto1bd1'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
ma = Marshmallow(app)



@app.route('/consulta1', methods=['GET'])
def consulta1():

    #Mostrar el cliente que más ha comprado. Se debe de mostrar el id del cliente, nombre, apellido, país y monto total.
    
    consulta = """SELECT c.id_cliente, c.nombre, c.apellido, p2.nombre AS pais, SUM(d.cantidad*p.precio) AS monto
        FROM detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON d.id_producto = p.id_producto
        INNER JOIN clientes c
        ON c.id_cliente = o.id_cliente
        INNER JOIN pais p2
        ON p2.id_pais = c.id_pais
        GROUP BY o.id_cliente
        ORDER BY monto DESC
        LIMIT 1;"""
    
    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta = f"ID Cliente: {fila.id_cliente}, Nombre: {fila.nombre}, Apellido: {fila.apellido}, País: {fila.pais}, Monto: {fila.monto}"
                return respuesta

@app.route('/consulta2', methods=['GET'])
def consulta2():

    #Mostrar el producto más y menos comprado. Se debe mostrar el id del producto, nombre del producto, categoría, cantidad de unidades y monto vendido.
        
    consulta = """
        (SELECT
        'MAS VENDIDO' AS Estado,
        d.id_producto,
        p.nombre AS nombre_producto,
        c.nombre AS nombre_categoria,
        SUM(d.cantidad) AS unidades_vendidas,
        SUM(d.cantidad * p.precio) AS monto
        FROM detalle_ordenes d
        INNER JOIN ordenes o ON d.id_orden = o.id_orden
        INNER JOIN productos p ON d.id_producto = p.id_producto
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        GROUP BY d.id_producto
        ORDER BY unidades_vendidas DESC
        LIMIT 1)
        UNION
        (SELECT
        'MENOS VENDIDO' AS Estado,
        d.id_producto,
        p.nombre AS nombre_producto,
        c.nombre AS nombre_categoria,
        SUM(d.cantidad) AS unidades_vendidas,
        SUM(d.cantidad * p.precio) AS monto
        FROM detalle_ordenes d
        INNER JOIN ordenes o ON d.id_orden = o.id_orden
        INNER JOIN productos p ON d.id_producto = p.id_producto
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        GROUP BY d.id_producto
        ORDER BY unidades_vendidas ASC
        LIMIT 1);"""
    
    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"Estado: {fila.Estado}, id_producto: {fila.id_producto}, nombre_producto: {fila.nombre_producto}, nombre_categoria: {fila.nombre_categoria}, unidades_vendidas: {fila.unidades_vendidas}, monto: {fila.monto}\n"
                
    return respuesta

@app.route('/consulta3', methods=['GET'])
def consulta3():

    consulta = """SELECT
            v.id_vendedor,
            v.nombre,
            SUM(p.precio * d.cantidad) AS monto_total_vendido
        FROM detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON d.id_producto = p.id_producto
        INNER JOIN categoria c
        ON p.id_categoria = c.id_categoria 
        INNER JOIN vendedores v
        ON v.id_vendedor = d.id_vendedor
        GROUP BY d.id_vendedor
        ORDER BY monto_total_vendido DESC
        LIMIT 1"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"id_vendedor: {fila.id_vendedor}, nombre: {fila.nombre}, monto_total_vendido: {fila.monto_total_vendido} \n"
                
    return respuesta

@app.route('/consulta4', methods=['GET'])
def consulta4():

    consulta = """(SELECT
        'VENDIO MAS' AS estado,
        pa.nombre AS pais,
        sum(p.precio * d.cantidad) AS monto_total_vendido
        FROM detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON d.id_producto = p.id_producto
        INNER JOIN categoria c
        ON p.id_categoria = c.id_categoria 
        INNER JOIN vendedores cl
        ON cl.id_vendedor = d.id_vendedor
        INNER JOIN pais pa
        ON pa.id_pais = cl.id_pais
        GROUP BY cl.id_pais
        ORDER BY monto_total_vendido DESC
        LIMIT 1)
        UNION
        (SELECT
        'VENDIO MAS' AS estado,
        pa.nombre AS pais,
        sum(p.precio * d.cantidad) AS monto_total_vendido
        FROM detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON d.id_producto = p.id_producto
        INNER JOIN categoria c
        ON p.id_categoria = c.id_categoria 
        INNER JOIN vendedores cl
        ON cl.id_vendedor = d.id_vendedor
        INNER JOIN pais pa
        ON pa.id_pais = cl.id_pais
        GROUP BY cl.id_pais
        ORDER BY monto_total_vendido ASC
        LIMIT 1)"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"Estado: {fila.estado}, Pais: {fila.pais}, monto_total_vendido: {fila.monto_total_vendido} \n"
                
    return respuesta

@app.route('/consulta5', methods=['GET'])
def consulta5():

    consulta = """SELECT
	pa.nombre AS pais,
	SUM(p.precio * d.cantidad) AS monto_total_vendido
	FROM detalle_ordenes d
	INNER JOIN ordenes o
	ON d.id_orden = o.id_orden
	INNER JOIN productos p
	ON d.id_producto = p.id_producto
	INNER JOIN categoria c
	ON p.id_categoria = c.id_categoria 
	INNER JOIN clientes cl
	ON cl.id_cliente = o.id_cliente
	INNER JOIN pais pa
	ON pa.id_pais = cl.id_pais
	GROUP BY cl.id_pais
	ORDER BY monto_total_vendido ASC
	LIMIT 5"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"Pais: {fila.pais}, monto_total_vendido: {fila.monto_total_vendido} \n"

    return respuesta

@app.route('/consulta6', methods=['GET'])
def consulta6():

    consulta = """(SELECT
        'VENDIO MAS' AS estado,
        c.nombre AS categoria,
        SUM( d.cantidad) AS unidades_vendidas
        FROM detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON d.id_producto = p.id_producto
        INNER JOIN categoria c
        ON p.id_categoria = c.id_categoria 

        GROUP BY c.id_categoria
        ORDER BY unidades_vendidas DESC
        LIMIT 1)
        UNION
        (SELECT
        'VENDIO MENOS' AS estado,
        c.nombre AS categoria,
        SUM( d.cantidad) AS unidades_vendidas
        FROM detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON d.id_producto = p.id_producto
        INNER JOIN categoria c
        ON p.id_categoria = c.id_categoria 
        GROUP BY c.id_categoria
        ORDER BY unidades_vendidas ASC
        LIMIT 1)"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"Estado: {fila.estado}, Categoria: {fila.categoria}, Unidades Vendidas: {fila.unidades_vendidas} \n"

    return respuesta

@app.route('/consulta7', methods=['GET'])
def consulta7():

    consulta = """SELECT t1.pais, t1.categoria, t1.cantidad_unidades
            FROM (
            SELECT
                pa.nombre AS pais,
                c.nombre AS categoria,
                SUM(d.cantidad) AS cantidad_unidades,
                RANK() OVER (PARTITION BY pa.id_pais ORDER BY SUM(d.cantidad) DESC) AS ranka
            FROM detalle_ordenes d
            INNER JOIN ordenes o ON d.id_orden = o.id_orden
            INNER JOIN productos p ON d.id_producto = p.id_producto
            INNER JOIN categoria c ON p.id_categoria = c.id_categoria
            INNER JOIN clientes cl ON cl.id_cliente = o.id_cliente
            INNER JOIN pais pa ON pa.id_pais = cl.id_pais
            GROUP BY pa.id_pais, c.id_categoria
            ORDER BY pais ASC
            ) AS t1
            WHERE t1.ranka = 1;"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"Pais: {fila.pais}, Categoria: {fila.categoria}, Unidaddes vendidas: {fila.cantidad_unidades} \n"

    return respuesta


@app.route('/consulta8', methods=['GET'])
def consulta8():

    consulta = """SELECT
            MONTH(o.fecha_orden) AS mes,
            SUM(p.precio * d.cantidad) AS monto
        FROM
            pais pa
        INNER JOIN clientes cl
        ON cl.id_pais = pa.id_pais
        INNER JOIN ordenes o
        ON o.id_cliente = cl.id_cliente
        INNER JOIN detalle_ordenes d
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON p.id_producto = d.id_producto


        WHERE
            pa.id_pais = '10'
        GROUP BY
            MONTH(o.fecha_orden)
        ORDER BY
            mes;"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"Mes: {fila.mes}, Monto: {fila.monto}\n"

    return respuesta

@app.route('/consulta9', methods=['GET'])
def consulta9():

    consulta = """(SELECT 
        'MES CON MAS VENDIDOS' AS estado,
        MONTH(o.fecha_orden) AS mes,
        SUM(p.precio * d.cantidad) AS total_ventas
        FROM
        detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON p.id_producto = d.id_producto
        GROUP BY MONTH(o.fecha_orden)
        ORDER BY total_ventas DESC
        LIMIT 1)
        UNION
        (SELECT 
        'MES CON MENOS VENDIDOS' AS estado,
        MONTH(o.fecha_orden) AS mes,
        SUM(p.precio * d.cantidad) AS total_ventas
        FROM
        detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON p.id_producto = d.id_producto
        GROUP BY MONTH(o.fecha_orden)
        ORDER BY total_ventas ASC
        LIMIT 1)"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"Estado: {fila.estado}, Mes: {fila.mes}, Total_ventas: {fila.total_ventas}\n"

    return respuesta

@app.route('/consulta10', methods=['GET'])
def consulta10():

    consulta  = """select 
        p.id_producto,
        p.nombre AS nombre_producto,
        SUM(p.precio * d.cantidad) AS monto
        FROM
        detalle_ordenes d
        INNER JOIN ordenes o
        ON d.id_orden = o.id_orden
        INNER JOIN productos p
        ON p.id_producto = d.id_producto
        INNER JOIN categoria c
        ON c.id_categoria = p.id_categoria
        WHERE c.nombre  = 'Deportes'
        group by p.id_producto"""

    respuesta = ""

    with app.app_context():
        with db.engine.begin() as connection:
            resultado = connection.execute(text(consulta))

            for fila in resultado:
                respuesta += f"id_producto: {fila.id_producto}, nombre_producto: {fila.nombre_producto}, monto: {fila.monto}\n"

    return respuesta

@app.route('/eliminarmodelo', methods=['GET'])
def eliminarModelo():

    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
                    DROP TABLE IF EXISTS detalle_ordenes;
                """))
            
    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
                    DROP TABLE IF EXISTS ordenes;
                """))
            
    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
                    DROP TABLE IF EXISTS productos;
                """))
            
    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
                    DROP TABLE IF EXISTS categoria;
                """))
            
    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
                    DROP TABLE IF EXISTS vendedores;
                """))

    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
                    DROP TABLE IF EXISTS clientes;
                """))
            
    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
                    DROP TABLE IF EXISTS pais;
                """))

    return 'Respuesta de la eliminar modelo'

@app.route('/crearmodelo', methods=['GET'])
def crearmodelo():

    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text("""
            CREATE TABLE IF NOT EXISTS pais (
                id_pais INT PRIMARY KEY,
                nombre VARCHAR(100)
            );
            """))
            connection.execute(text("""
            CREATE TABLE IF NOT EXISTS categoria (
                id_categoria INT PRIMARY KEY,
                nombre VARCHAR(100)
            );
            """))
            connection.execute(text("""
            CREATE TABLE IF NOT EXISTS productos (
                id_producto INT PRIMARY KEY,
                id_categoria INT,
                precio DECIMAL(10, 2),
                nombre VARCHAR(100),
                FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
            );
            """))
            connection.execute(text("""
            CREATE TABLE IF NOT EXISTS clientes (
                id_cliente INT PRIMARY KEY,
                nombre VARCHAR(100),
                apellido VARCHAR(100),
                direccion VARCHAR(100),
                telefono VARCHAR(100),
                tarjeta VARCHAR(100),
                edad INT,
                genero VARCHAR(25),
                salario NUMERIC,
                id_pais INT,
                FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
            );
            """))
            connection.execute(text("""
            CREATE TABLE IF NOT EXISTS vendedores (
                id_vendedor INT PRIMARY KEY,
                nombre VARCHAR(100),
                apellido VARCHAR(100),
                id_pais INT,
                FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
            );
            """))
            connection.execute(text("""
            CREATE TABLE IF NOT EXISTS ordenes (
                id_orden INT PRIMARY KEY,
                fecha_orden DATE,
                id_cliente INT,
                FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
            );
            """))

            connection.execute(text("""
                CREATE TABLE IF NOT EXISTS detalle_ordenes (
                    id_linea INT,
                    id_orden INT,
                    id_producto INT,
                    id_vendedor INT,
                    cantidad INT,
                    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden),
                    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
                    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
                    PRIMARY KEY(id_orden, id_linea)           

                );
                """))

       # db.create_all()

    return 'Respuesta de la crear modelo'

@app.route('/borrarinfodb', methods=['GET'])
def borrarInfoDB():

    consultaEliminarDetalleOrdenes = "DELETE FROM detalle_ordenes"
    consultaEliminarOrden = "DELETE FROM ordenes"
    consultaEliminarProductos = "DELETE FROM productos"
    consultaEliminarClientes = "DELETE FROM clientes"
    consultaEliminarVendedores = "DELETE FROM vendedores"
    consultaEliminarCategorias = "DELETE FROM categoria"
    consultaEliminarPaises = "DELETE FROM pais"

    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text(consultaEliminarDetalleOrdenes))
            connection.execute(text(consultaEliminarOrden))
            connection.execute(text(consultaEliminarProductos))
            connection.execute(text(consultaEliminarClientes))
            connection.execute(text(consultaEliminarVendedores))
            connection.execute(text(consultaEliminarCategorias))
            connection.execute(text(consultaEliminarPaises))

    return 'Respuesta de la borrar Info DB'

@app.route('/cargarmodelo', methods=['GET'])
def cargarModelo():

    consultaPaises = ''
    consultaClientes = ''
    consultaVendedores = ''
    consultaCategorias = ''
    consultaProductos = ''
    consultaOrdenes = ''
    consultaDetalle = ''

    with open('paises.csv', newline='') as archivo_csv:
        lector_csv = csv.reader(archivo_csv, delimiter=';')  # Ajusta el delimitador si es necesario

        contador = 0
        valores = ''

        for fila in lector_csv:
            if contador > 0:
                valores += "('"+fila[0]+"','"+fila[1]+"'),\n"
            contador = contador + 1 


        consultaPaises = """INSERT IGNORE INTO pais
                (id_pais,nombre)
                VALUES
            """ + valores
        
        consultaPaises = consultaPaises.rstrip(',\n ')

        print(consultaPaises)

    with open('Categorias.csv', newline='') as archivo_csv:
        lector_csv = csv.reader(archivo_csv, delimiter=';')  # Ajusta el delimitador si es necesario

        contador = 0
        valores = ''

        for fila in lector_csv:
            if contador > 0:
                valores += "('"+fila[0]+"','"+fila[1]+"'),\n"
            contador = contador + 1 


        consultaCategorias = """INSERT IGNORE INTO categoria
                (id_categoria,nombre)
                VALUES
            """ + valores
        
        consultaCategorias = consultaCategorias.rstrip(',\n ')

        print(consultaCategorias)

    with open('clientes.csv', newline='') as archivo_csv:
        lector_csv = csv.reader(archivo_csv, delimiter=';')  # Ajusta el delimitador si es necesario

        contador = 0
        valores = ''

        for fila in lector_csv:
            if contador > 0:
                valores += "('"+fila[0]+"',\""+fila[1]+ "\",\"" + fila[2] + "\",\"" + fila[3] + "\",'" + fila[4] + "','" + fila[5] + "','" + fila[6] + "','" + fila[7] + "','" + fila[8] + "','" + fila[9] + "'),\n"
            contador = contador + 1 

        consultaClientes = """INSERT IGNORE INTO clientes
                (id_cliente,nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, id_pais)
                VALUES
            """ + valores
        
        consultaClientes = consultaClientes.rstrip(',\n ')

        print(consultaClientes)
    
    with open('vendedores.csv', newline='') as archivo_csv:
        lector_csv = csv.reader(archivo_csv, delimiter=';')  # Ajusta el delimitador si es necesario

        contador = 0
        valores = ''

        for fila in lector_csv:
            if contador > 0:
                valores += "('"+fila[0]+"',\"" +fila[1] +"\",'" +fila[2] +"'),\n"
            contador = contador + 1 

        consultaVendedores = """INSERT IGNORE INTO vendedores
                (id_vendedor, nombre, id_pais)
                VALUES
            """ + valores
        
        consultaVendedores = consultaVendedores.rstrip(',\n ')

        print(consultaVendedores)

    with open('productos.csv', newline='') as archivo_csv:
        lector_csv = csv.reader(archivo_csv, delimiter=';')  # Ajusta el delimitador si es necesario

        contador = 0
        valores = ''

        for fila in lector_csv:
            if contador > 0:
                valores += "('"+fila[0]+"','" +fila[1] +"','" +fila[2]  +"',\"" + fila[3] +"\"),\n"
            contador = contador + 1 

        consultaProductos = """INSERT IGNORE INTO productos
                (id_producto, nombre, precio, id_categoria)
                VALUES
            """ + valores
        
        consultaProductos = consultaProductos.rstrip(',\n ')

        print(consultaProductos)

    with open('ordenes.csv', newline='') as archivo_csv:
        lector_csv = csv.reader(archivo_csv, delimiter=';')  # Ajusta el delimitador si es necesario

        contador = 0
        valores = ''

        for fila in lector_csv:
            if contador > 0:

                auxFecha = fila[2].split('/')
                auxFecha = auxFecha[2] + "/" + auxFecha[1] + "/" + auxFecha[0]

                valores += "('"+fila[0]+"','" + auxFecha +"','" +fila[3] + "'),\n"
            contador = contador + 1 

        consultaOrdenes = """INSERT IGNORE INTO ordenes
                (id_orden, fecha_orden, id_cliente)
                VALUES
            """ + valores
        
        consultaOrdenes = consultaOrdenes.rstrip(',\n ')

        print(consultaOrdenes)

    with open('ordenes.csv', newline='') as archivo_csv:
        lector_csv = csv.reader(archivo_csv, delimiter=';')  # Ajusta el delimitador si es necesario

        contador = 0
        valores = ''

        for fila in lector_csv:
            if contador > 0:
                valores += "('"+fila[0]+"','" +fila[1] +"','" +fila[4] +"','" +fila[5] +"','" +fila[6] + "'),\n"
            contador = contador + 1 

        consultaDetalle = """INSERT IGNORE INTO detalle_ordenes
                (id_orden, id_linea, id_vendedor, id_producto, cantidad)
                VALUES
            """ + valores
        
        consultaDetalle = consultaDetalle.rstrip(',\n ')

        print(consultaDetalle)

    with app.app_context():
        with db.engine.begin() as connection:
            connection.execute(text(consultaPaises))
            connection.execute(text(consultaCategorias))            
            connection.execute(text(consultaProductos))
            connection.execute(text(consultaClientes))
            connection.execute(text(consultaVendedores))
            connection.execute(text(consultaOrdenes))
            connection.execute(text(consultaDetalle))

    return 'Respuesta de cargar modelo'

if __name__ == '__main__':
    app.run(debug=True)