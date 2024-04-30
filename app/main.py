import os
import logging
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
import sqlalchemy
from google.cloud.sql.connector import connector, IPTypes
import pg8000

# Configure basic logger
logging.basicConfig(level=logging.DEBUG)
def connect_with_connector() -> sqlalchemy.engine.base.Engine:
    instance_connection_name = os.getenv("INSTANCE_CONNECTION_NAME", "") # connection name
    db_user = os.getenv("DB_USER", "") # DB username
    db_pass = os.getenv("DB_PASS", "") # DB password
    db_name = os.getenv("DB_NAME", "") # DB name

    def getconn() -> pg8000.dbapi.Connection:
        try:
            conn = connector.connect(
                instance_connection_name,
                "pg8000",
                user=db_user,
                password=db_pass,
                db=db_name
            )
            if conn is None:
                raise Exception("Failed to establish database connection. Connector returned None.")
            logging.debug("Database connection established successfully.")
            return conn
        except Exception as e:
            logging.error(f"Failed to connect to the database: {e}")
            raise

    engine = create_engine("postgresql+pg8000://", creator=getconn)
    return engine



engine = connect_with_connector()

def execute_query(query, **params):
    try:
        with engine.connect() as connection:
            logging.debug(f"Executing query: {query} with parameters: {params}")
            result = connection.execute(text(query), **params)
            return result
    except SQLAlchemyError as e:
        logging.error(f"SQLAlchemy Error: {str(e)}")
        raise

def users(request):
    logging.debug(f"Request Method: {request.method}")
    logging.debug(f"Request JSON: {request.get_json(silent=True)}")
    logging.debug(f"Request Args: {request.args}")

    request_json = request.get_json(silent=True)
    request_method = request.method
    request_args = request.args

    try:
        if request_method == 'POST':
            username = request_json['username']
            result = execute_query(
                "INSERT INTO users (username) VALUES (:username) RETURNING id;",
                username=username
            )
            user_id = result.fetchone()[0]
            return {'id': user_id}, 201

        elif request_method == 'GET':
            user_id = request_args.get('id')
            try:
                result = execute_query(
                    "SELECT * FROM users WHERE id = :user_id;",
                    user_id=user_id
                )
                user = result.fetchone()
                if not user:
                    return {'error': 'User not found'}, 404
                return {'id': user[0], 'username': user[1]}
            except Exception as e:
                logging.error(f"Operation was cancelled or failed: {str(e)}")
                return {'error': 'Operation cancelled or failed'}, 503

        elif request_method == 'PUT':
            user_id = request_args.get('id')
            username = request_json['username']
            result = execute_query(
                "UPDATE users SET username = :username WHERE id = :user_id;",
                username=username, user_id=user_id
            )
            if result.rowcount == 0:
                return {'error': 'User not found'}, 404
            return {'id': user_id, 'updated': True}

        elif request_method == 'DELETE':
            user_id = request_args.get('id')
            result = execute_query(
                "DELETE FROM users WHERE id = :user_id;",
                user_id=user_id
            )
            if result.rowcount == 0:
                return {'error': 'User not found'}, 404
            return {'deleted': True}

    except Exception as e:
        logging.error(f"Unhandled Exception: {type(e).__name__}, Error: {str(e)}")
        return {'error': f"{type(e).__name__}: {str(e)}"}, 500

def main(request):
    return users(request)