# Sample API

Small FastAPI service used to demonstrate the GitOps delivery path.

Endpoints:

- `/`
- `/health`
- `/ready`
- `/metrics`

Local development:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pytest -q tests
uvicorn app.main:app --reload
```
