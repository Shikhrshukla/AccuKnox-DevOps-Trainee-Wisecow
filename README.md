# Wisecow | AccuKnox DevOps Assessment

## 📘 Overview
This project demonstrates **containerization, Kubernetes deployment, and CI/CD automation** for the Wisecow web application - part of the AccuKnox DevOps Trainee Practical Assessment.

The Wisecow app serves random “cowsay” messages over HTTP, written as a Bash script. The project implements full automation using **Docker**, **Helm**, **Kubernetes**, **GitHub Actions**, and **ArgoCD**, with secure **HTTPS (TLS)** support.

---

## 🚀 Project Objectives
1. **Containerize** the Wisecow Bash application using Docker. 
2. **Deploy** the application to a Kubernetes cluster (Minikube). 
3. **Expose** the service securely with TLS via Ingress. 
4. **Automate CI/CD** using GitHub Actions to build, push, and update Helm charts. 
5. **Enable Continuous Deployment** using **ArgoCD** for GitOps-based delivery.

---

## 🧩 Tech Stack
| Component | Tool Used |
|------------|------------|
| Containerization | Docker |
| Orchestration | Kubernetes (Minikube) |
| Package Management | Helm |
| CI/CD | GitHub Actions, ArgoCD |
| TLS Certificates | mkcert (self-signed, trusted locally) |

<img width="1919" height="706" alt="minikube" src="https://github.com/user-attachments/assets/350a7d37-dcfc-4486-bebc-4efe06214bd6" />

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

<img width="1919" height="961" alt="Screenshot from 2025-11-12 18-48-29" src="https://github.com/user-attachments/assets/90624d96-5aaa-49d7-b422-c6e1d3678324" />
<img width="1919" height="706" alt="dockerPs" src="https://github.com/user-attachments/assets/c5cf213d-2d51-4db1-abe5-18d1936d3d19" />
<img width="1918" height="1001" alt="dockerReg" src="https://github.com/user-attachments/assets/3c60072c-6036-45b5-ad43-13c5095e5970" />

---

## ☸️ Kubernetes Deployment
All Kubernetes resources are managed through **Helm** templates:

| File | Purpose |
|------|----------|
| `namespace.yaml` | Creates `wisecow` namespace |
| `deployment.yaml` | Deploys Wisecow container |
| `service.yaml` | Exposes service on port 80 / NodePort 30499 |
| `ingress-https.yaml` | Configures HTTPS Ingress using mkcert certificates |

<img width="1514" height="962" alt="k8sAll" src="https://github.com/user-attachments/assets/b2e39e88-4228-4177-8a61-e1e0c9b37758" />
<img width="1158" height="252" alt="igC" src="https://github.com/user-attachments/assets/d861b92c-6bba-4ede-89c2-fce03b77efb0" />

### TLS Setup (Local)
```bash
mkcert -install
mkcert wisecow.local
kubectl create secret tls wisecow-tls  --cert=wisecow.local.pem  --key=wisecow.local-key.pem  -n wisecow
```

<img width="1919" height="939" alt="ing" src="https://github.com/user-attachments/assets/fdb23363-c3ce-4423-b786-6969b53ddf64" />

Access app at:
```
https://wisecow.local
```

<img width="1918" height="1001" alt="mainDep" src="https://github.com/user-attachments/assets/c99d33ab-8d40-4289-a125-c47047cd9a54" />

---

## ⚙️ CI/CD Pipeline (GitHub Actions + ArgoCD)
The CI pipeline automates the following stages:

| Stage | Description |
|--------|--------------|
| **Build** | Lints Dockerfile using Hadolint |
| **Docker Build & Push** | Builds and pushes image to DockerHub |
| **Helm Update** | Updates `values.yaml` with latest image SHA tag and commits changes |
| **Continuous Deployment** | ArgoCD automatically syncs Helm chart updates from GitHub to Kubernetes cluster |

**Secrets Required:**
| Secret | Description |
|---------|-------------|
| `DOCKER_USERNAME` | DockerHub username |
| `DOCKER_PASSWORD` | DockerHub token |
| `TOKEN_GIT` | GitHub Personal Access Token for commits |

You’ll see the latest image deployed after each GitHub Action pipeline run.

<img width="1918" height="1001" alt="CI1" src="https://github.com/user-attachments/assets/7dfec06e-7001-41b5-9a06-446bed802544" />
<img width="1918" height="1001" alt="CI2" src="https://github.com/user-attachments/assets/9ad4190b-668d-4269-b77f-7d0050a90d9f" />

---

## Scripts — How to run

SystemHealthMonitoring.sh
1. Make the script executable: use the command `sudo chmod +x SystemHealthMonitoring.sh` to set execute permission on the file.
2. Run as a normal user to write logs to your home directory; the script writes metrics and alerts to `system_health.log` in your home directory.
3. To write logs to system log directory (`/var/log`) run the script with elevated privileges (sudo).
4. To customize thresholds or behavior, open the script and edit the CPU, memory, and disk threshold variables near the top.
5. Check the generated log file to review recorded metrics and any alerts.

ApplicationHealthChecker.sh
1. Make the script executable: set execute permission on the file using `sudo chmod +x ApplicationHealthChecker.sh`
2. By default the script checks `https://wisecow.local`
3. Run the script; it will periodically check the application endpoint, log status codes and response times, and append results to `application_health.log` in your home directory.
4. Stop monitoring with Ctrl+C. To run the script in background, start it with a job control command appropriate for your shell.
5. Review the log file to see up/down events, response times, and alerts.

---

## 🧠 Learning Outcomes
- Hands-on experience with **Docker, Kubernetes, Helm, GitHub Actions, and ArgoCD**
- Secure app deployment using **TLS certificates**
- Automated image versioning and Helm chart updates
- GitOps-based continuous delivery using ArgoCD
- Modular, reusable infrastructure setup

---

## 👤 Author
**Shikhar Shukla**  
DevOps Engineer Trainee | AccuKnox Practical Assessment  
GitHub: [shikhrshukla](https://github.com/shikhrshukla)
