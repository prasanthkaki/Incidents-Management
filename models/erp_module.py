from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime, timezone
from config.database import Base

class ERPModule(Base):
    __tablename__ = "erp_module"

    id = Column(Integer, primary_key=True, index=True)
    erp_name = Column(String(100), nullable=False)
    status = Column(Integer, default=1, nullable=False)

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
