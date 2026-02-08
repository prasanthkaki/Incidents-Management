from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import JSONResponse
import os
from dotenv import load_dotenv


load_dotenv(override=True)

API_TOKEN = "1q2w3e4r5t6y"  # later from env

class AuthMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # if request.url.path in ["/docs", "/openapi.json", "/health"]:
        #     return await call_next(request)
        env_check = True if os.getenv("ENV") == 'prod' else False
        if env_check :
            token = request.headers.get("Authorization")
            if not token or token != f"Bearer {API_TOKEN}":
                return JSONResponse(
                    status_code=401,
                    content={"detail": "Invalid or missing token"}
                )
        return await call_next(request)
