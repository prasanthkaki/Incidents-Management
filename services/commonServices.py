def get_severity(description: str, env_id: int):
    text = description.lower()

    if env_id == 1 and any (k in text for k in ["client", "down", "critical", "stuck", "payment"]):
        return 1 # High severity
    if env_id == 2: #UAT portal
        return 2 # Medium Impact
    
    return 3 # Low Impact