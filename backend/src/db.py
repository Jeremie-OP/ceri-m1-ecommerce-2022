from sqlmodel import create_engine, SQLModel, Session

DATABASE_URL = "mysql+mysqldb://customer:iwantvinyls@db:3306/vinyls"


engine = create_engine(DATABASE_URL)

def init_db():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
