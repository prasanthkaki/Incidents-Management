from fastapi import FastAPI
from config.database import engine
from models import Incident
from fastapi.middleware.cors import CORSMiddleware


from models import ERPModule, BusinessUnit, Environment, categories
from controllers.incident_controller import router as incident_router
from fastapi.staticfiles import StaticFiles
from middleware.auth import AuthMiddleware

app = FastAPI()

app.add_middleware(AuthMiddleware)

app.mount("/static", StaticFiles(directory="views"), name="static")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow all origins (OK for local dev)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#Create all the tables
Incident.metadata.create_all(bind=engine)
app.include_router(incident_router)