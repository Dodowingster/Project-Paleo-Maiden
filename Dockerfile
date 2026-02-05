FROM python:3.9-slim
RUN pip install papermill jupyter
# Optional: install specific notebook kernels (e.g., ipykernel)
# RUN pip install ipykernel
