# URL-Shortener

To repozytorium jest częścią pracy magisterskiej "Projekt i ocena automatyzacji tworzenia klastra Kubernetes oraz wdrażania aplikacji internetowej z użyciem infrastruktury jako kodu".

Tworzy automatycznie od zera klaster Kubernetesa (1 control plane + 3 workery) przez Terraform + Ansible + ArgoCD, a następnie wdraża na niego prostą aplikację skracacza URL (Python+FastAPI+PostgreSQL) przy pomocy pipelinu GitHub Actions.

Całość działa na: https://github.com/DNTK1/HomeLab