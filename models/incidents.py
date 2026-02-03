from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime, timezone
from config.database import Base

class Incident(Base):
    __tablename__ = "incidents"

    id = Column(Integer, primary_key=True)
    client_id = Column(Integer, nullable=False)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=False)

    erp_module_id = Column(Integer, ForeignKey("erp_module.id"))
    business_unit_id = Column(Integer, ForeignKey("business_unit.id"))
    env_id = Column(Integer, ForeignKey("environments.id"))
    category_id = Column(Integer, ForeignKey("categories.id"))

    severity = Column(Integer)
    status = Column(Integer, default=1)

    created_at = Column(
            DateTime(timezone=True),
            default=lambda: datetime.now(timezone.utc),
            nullable=False
        )
    updated_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    erp_module = relationship("ERPModule")
    business_unit = relationship("BusinessUnit")
    environment = relationship("Environment")
    categories = relationship("Categories")
