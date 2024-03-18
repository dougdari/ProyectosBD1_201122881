
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

    
    
    return 'Respuesta de la consulta 1'

@app.route('/consulta2', methods=['GET'])
def consulta2():
        
    return 'Respuesta de la consulta 2'

@app.route('/consulta3', methods=['GET'])
def consulta3():

    return 'Respuesta de la consulta 3'

@app.route('/consulta4', methods=['GET'])
def consulta4():

    return 'Respuesta de la consulta 4'

@app.route('/consulta5', methods=['GET'])
def consulta5():

    return 'Respuesta de la consulta 5'

@app.route('/consulta6', methods=['GET'])
def consulta6():

    return 'Respuesta de la consulta 6'

@app.route('/consulta7', methods=['GET'])
def consulta7():

    return 'Respuesta de la consulta 7'

@app.route('/consulta8', methods=['GET'])
def consulta8():

    return 'Respuesta de la consulta 8'

@app.route('/consulta9', methods=['GET'])
def consulta9():

    return 'Respuesta de la consulta 9'

@app.route('/consulta10', methods=['GET'])
def consulta10():

    return 'Respuesta de la consulta 10'

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
                precio NUMERIC,
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
                fecha_orgen TIMESTAMP,
                id_cliente INT,
                FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
            );
            """))

            connection.execute(text("""
                CREATE TABLE IF NOT EXISTS detalle_ordenes (

                    id_orden INT,
                    id_producto INT,
                    id_vendedor INT,
                    id_cantidad INT,
                    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden),
                    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
                    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
                    PRIMARY KEY (id_orden, id_producto, id_vendedor)                  

                );
                """))

       # db.create_all()

    return 'Respuesta de la crear modelo'

@app.route('/borrarinfodb', methods=['GET'])
def borrarInfoDB():

    return 'Respuesta de la borrar Info DB'

@app.route('/cargarmodelo', methods=['GET'])
def cargarModelo():

    return 'Respuesta de cargar modelo'

if __name__ == '__main__':
    app.run(debug=True)