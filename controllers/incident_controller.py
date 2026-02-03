from fastapi import APIRouter, Request, HTTPException, UploadFile, File, Form, Depends, Query

from sqlalchemy.orm import Session
from models import Incident

from schemas.incident_input import IncidentCreate
from schemas.incident_output import IncidentResponse
from sqlalchemy.exc import SQLAlchemyError

from config.deps import get_db
from services.commonServices import get_severity
from modules.Incidents.crud import create_incident as create_incident_db, get_incidents, update_incident, delete_incident as delete_incident_db, get_dropdown_values_list
from common.constants import *
from services.s3_client import create_incident_payload

router = APIRouter(prefix="/incidents", tags=["Incidents"])

# response_model=IncidentResponse
@router.post("/create-incident")
def create_incident(payload: IncidentCreate, db: Session = Depends(get_db)):
    severity = get_severity(payload.description, payload.env_id)
    # return {"severity": severity}
    incident_data = payload.model_dump()
    incident_data["severity"] = severity

    if payload.id:
        incident = update_incident(db, incident_data)
        if not incident:
            raise HTTPException(status_code=404, detail="Incident not found")
        create_incident_payload(incident)
        return {
            "status": "updated",
            "description": "Incident updated successfully"
        }
    
    incident = create_incident_db(db, incident_data)
    if incident:
        return create_incident_payload(incident)
        return {
            "status": "created",
            "description":"Incident created successfully.",
        }
    raise HTTPException(
        status_code = 400, 
        detail = "Failed to create incident. Please check your input data."
    )
# response_model=list[IncidentResponse]
@router.get('/list')
def get_list(db:Session = Depends(get_db), 
        id: int | None = Query(default = None), 
        page: int = Query(1, ge = 1),
        limit: int = Query(1, ge = 10)
    ):
    offset = (page - 1) * limit
    incidents, total = get_incidents(db, offset, limit, id)
    response = []
    for i in incidents:
        response.append({
            "id": i.id,
            "client_id": i.client_id,
            "title": i.title,
            "description": i.description,
            "severity": SEVERITY_NAME.get(i.severity, "Unknown"),
            "client_id" : i.client_id,
            "status": INCIDENT_STATUS_NAME.get(i.status, "Unknown"),
            "environment": i.environment.env_name,
            "created_at":i.created_at,
            "business_unit": i.business_unit.business_unit_name,
            "erp_module": i.erp_module.erp_name,
            "category": i.categories.category_name
        })
    return {"data" : response, "total":total, "page":page, "limit": limit}

@router.delete('/delete-incident/{id}')
def delete_incident(id: int,db:Session = Depends(get_db)):
    status = delete_incident_db(db, id)
    if status:
        return {"status":"Delete", "message" : "Incident deleted successfully"}
    
    raise HTTPException(status_code=404, detail={"status":"Not Found", "message" : "Incident Not found"})

@router.get('/drop-down')
def get_dropdown_values(db:Session = Depends(get_db)):
    data = get_dropdown_values_list(db)
    data['status'] = INCIDENT_STATUS_NAME
    return {"data":data}




