from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class IncidentResponse(BaseModel):
    id: int
    title: str
    description: str
    severity: str
    client_id: int
    status: str
    created_at: datetime
    environment: str
    business_unit: str
    category: str
    erp_module: str
    category: str
    
    class Config:
        from_attributes = True
