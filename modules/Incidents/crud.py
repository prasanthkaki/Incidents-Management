from sqlalchemy.orm import Session
from models import Incident, BusinessUnit, Categories, Environment, ERPModule
from schemas import incident_input, incident_output
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import desc

def create_incident(db:Session, incident_data: dict):
    db_incident = Incident(
        **incident_data
    )
    try:
        db.add(db_incident)
        db.commit()
        db.refresh(db_incident)
        return db_incident
    except:
        db.rollback()
        # // Add logging here
        return None
    
def get_incidents(db:Session, page, limit, id : int | None = None):
    query = db.query(Incident)
    total = query.count()
    if id:
        query = query.filter(Incident.id == id)
    incidents = query.order_by(desc(Incident.created_at)).offset(page).limit(limit).all()
    return incidents, total

def update_incident(db:Session, incident_data:dict):
    incident = db.query(Incident).filter(Incident.id == incident_data.get('id')).first()
    if not incident:
        return None
    for key, value in incident_data.items():
        setattr(incident, key, value)

    db.commit()
    db.refresh(incident)
    return incident

def delete_incident(db:Session, id: int):
    incident = db.query(Incident).filter(Incident.id == id).first()
    if not incident:
        return False

    db.delete(incident)
    db.commit()
    return True

def get_dropdown_values_list(db:Session):
    business_unit = db.query(BusinessUnit.id, BusinessUnit.business_unit_name).filter(BusinessUnit.status == 1)
    categories = db.query(Categories.id, Categories.category_name).filter(Categories.status == 1)
    environments = db.query(Environment.id, Environment.env_name).filter(Environment.status == 1)
    erp_module = db.query(ERPModule.id, ERPModule.erp_name).filter(ERPModule.status == 1)
    return {"business_unit":business_unit, "categories": categories, "environments":environments, "erp_module":erp_module}

