# Wisecow Kubernetes Deployment | AccuKnox DevOps Assessment

## 📘 Overview
This project demonstrates **containerization, Kubernetes deployment, and CI/CD automation** for the Wisecow web application — part of the AccuKnox DevOps Trainee Practical Assessment.

The Wisecow app serves random “cowsay” messages over HTTP, written as a Bash script. The project implements full automation using **Docker**, **Helm**, **Kubernetes**, and **GitHub Actions**, with secure **HTTPS (TLS)** support.

---

## 🚀 Project Objectives
1. **Containerize** the Wisecow Bash application using Docker. 
2. **Deploy** the application to a Kubernetes cluster (Minikube). 
3. **Expose** the service securely with TLS via Ingress. 
4. **Automate CI/CD** using GitHub Actions to build, push, and update Helm charts. 
5. **Enable Continuous Delivery** using Helm and (optionally) ArgoCD.

---

## 🧩 Tech Stack
| Component | Tool Used |
|------------|------------|
| Containerization | Docker |
| Orchestration | Kubernetes (Minikube) |
| Package Management | Helm |
| CI/CD | GitHub Actions, argoCD |
| TLS Certificates | mkcert (self-signed, trusted locally) |

---

## 🐋 Dockerization
### Dockerfile Highlights
- Base Image: Ubuntu 22.04 
- Installs dependencies: `fortune-mod`, `cowsay`, `netcat-openbsd`
- Copies the `wisecow.sh` script into `/app`
- Exposes port `4499`
- Sets entrypoint to the script

**Build and Run Locally:**
```bash
docker build -t wisecow:latest .
docker run -p 4499:4499 wisecow
```

---

## ☸️ Kubernetes Deployment
All Kubernetes resources are managed through **Helm** templates:

| File | Purpose |
|------|----------|
| `namespace.yaml` | Creates `wisecow` namespace |
| `deployment.yaml` | Deploys Wisecow container |
| `service.yaml` | Exposes service on port 80 / NodePort 30499 |
| `ingress-https.yaml` | Configures HTTPS Ingress using mkcert certificates |

### TLS Setup (Local)
```bash
mkcert -install
mkcert wisecow.local
kubectl create secret tls wisecow-tls  --cert=wisecow.local.pem  --key=wisecow.local-key.pem  -n wisecow
```

Access app at:
```
https://wisecow.local
```

---

## ⚙️ CI/CD Pipeline (GitHub Actions)
The CI pipeline automates the following stages:

| Stage | Description |
|--------|--------------|
| **Build** | Lints Dockerfile using Hadolint |
| **Docker Build & Push** | Builds and pushes image to DockerHub |
| **Helm Update** | Updates `values.yaml` with latest image SHA tag and commits changes |

**Secrets Required:**
| Secret | Description |
|---------|-------------|
| `DOCKER_USERNAME` | DockerHub username |
| `DOCKER_PASSWORD` | DockerHub token |
| `TOKEN_GIT` | GitHub Personal Access Token for commits |

---

## 🧠 Learning Outcomes
- Hands-on experience with **Docker, Kubernetes, Helm, and CI/CD pipelines**
- Secure app deployment using **TLS certificates**
- Automated image versioning and Helm updates
- Modular, reusable infrastructure setup

---
