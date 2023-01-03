from sqlmodel import create_engine, SQLModel, Session
import os
import sqlalchemy


mysql_password = os.environ.get("MYSQL_PASSWORD")
# mysql_user = os.environ.get("MYSQL_USER")
mysql_user = 'graytiger'
mysql_table = os.environ.get("MYSQL_DATABASE")
mysql_address = os.environ.get("MYSQL_ADDRESS")
unix_socket_path = '/cloudsql/ceri-m1-ecommerce-2022:europe-west1:mysql-primary'


DATABASE_URL = f"mysql+mysqldb://{mysql_user}:{mysql_password}@/{mysql_table}?unix_socket={unix_socket_path}"
# mysql+pymysql://<db_user>:<db_pass>@/<db_name>?unix_socket=<socket_path>/<cloud_sql_instance_name>


# connect_unix_socket initializes a Unix socket connection pool for
# a Cloud SQL instance of MySQL.
def connect_unix_socket() -> sqlalchemy.engine.base.Engine:
    # Note: Saving credentials in environment variables is convenient, but not
    # secure - consider a more secure solution such as
    # Cloud Secret Manager (https://cloud.google.com/secret-manager) to help
    # keep secrets safe.
    mysql_password = os.environ.get("MYSQL_PASSWORD")
    # mysql_user = os.environ.get("MYSQL_USER")
    mysql_user = 'graytiger'
    mysql_table = os.environ.get("MYSQL_DATABASE")
    mysql_address = os.environ.get("MYSQL_ADDRESS")
    # unix_socket_path = os.environ["INSTANCE_UNIX_SOCKET"]  # e.g. '/cloudsql/project:region:instance'
    unix_socket_path = '/cloudsql/ceri-m1-ecommerce-2022:europe-west1:mysql-primary'

    pool = sqlalchemy.create_engine(
        # Equivalent URL:
        # mysql+pymysql://<db_user>:<db_pass>@/<db_name>?unix_socket=<socket_path>/<cloud_sql_instance_name>
        sqlalchemy.engine.url.URL.create(
            drivername="mysql+pymysql",
            username=mysql_user,
            password=mysql_password,
            database=mysql_table,
            query={"unix_socket": unix_socket_path},
        ),
        # ...
    )
    return pool


DATABASE_URL = sqlalchemy.engine.url.URL.create(
    drivername="mysql+mysqldb",
    username=mysql_user,
    password=mysql_password,
    database=mysql_table,
    query={"unix_socket": unix_socket_path},
)

engine = create_engine(DATABASE_URL)
# engine = connect_unix_socket()


def init_db():
    SQLModel.metadata.create_all(engine)


def get_session():
    with Session(engine) as session:
        yield session
