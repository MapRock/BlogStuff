
def hr_retention_kpi(department:str, month_count:float, last_month_count:float)->float
	"""KPI for HR manager.

	USAGE:
	------
	"""
	return None if not month_count else (month_count-last_month_count)/last_month_count 