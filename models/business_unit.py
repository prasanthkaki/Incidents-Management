from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime, timezone
from config.database import Base

class BusinessUnit(Base):
    __tablename__ = "business_unit"

    id = Column(Integer, primary_key=True)
    business_unit_name = Column(String(100))
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