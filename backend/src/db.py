from sqlmodel import create_engine, SQLModel, Session
import os


mysql_password = os.environ.get("MYSQL_ROOT_PASSWORD")
mysql_user = os.environ.get("MYSQL_USER")
mysql_table = os.environ.get("MYSQL_DATABASE")
mysql_address = os.environ.get("MYSQL_ADDRESS")

DATABASE_URL = "mysql+mysqldb://{mysql_user}:{mysql_password}@{mysql_adress}:3306/{mysql_table}"


engine = create_engine(DATABASE_URL)

def init_db():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
