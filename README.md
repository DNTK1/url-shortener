# URL-Shortener

To repozytorium jest częścią pracy magisterskiej "Projekt i ocena automatyzacji tworzenia klastra Kubernetes oraz wdrażania aplikacji internetowej z użyciem infrastruktury jako kodu".

Uruchomienie `lab.sh up` tworzy lub modyfikuje klaster Kubernetesa (1 control plane + 3 workery) przez Terraform + Ansible. Dodatkowo wdrażana jest na niego prosta aplikacja skracacza URL (Python+FastAPI+PostgreSQL) w modelu GitOps (GitHub Actions buduje obraz i aktualizuje manifesty, a Argo CD synchronizuje je na bieżąco z klastrem).

Całość działa na: https://github.com/DNTK1/HomeLab