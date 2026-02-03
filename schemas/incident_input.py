from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class IncidentCreate(BaseModel):
    id: Optional[int] = None
    title: str
    description: str
    erp_module_id: int
    env_id: int
    client_id: int
    business_unit_id: int
    category_id: int
