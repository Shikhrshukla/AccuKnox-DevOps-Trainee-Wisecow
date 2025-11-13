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
<img width="903" height="454" alt="Screenshot from 2025-11-13 18-31-40" src="https://github.com/user-attachments/assets/00393d69-f865-4bfe-ad47-eae9ded921b8" />


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

### **🐙 ArgoCD Integration (UI Method)** 

After implementing CI/CD with GitHub Actions and Helm, **ArgoCD** was added to enable **Continuous Deployment (GitOps)** - automatically syncing new image updates from the GitHub repo to the Kubernetes cluster. 

#### 1. **Install ArgoCD on Minikube**

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
<img width="1919" height="961" alt="Screenshot from 2025-11-12 19-55-44" src="https://github.com/user-attachments/assets/8add75e8-6e7d-40f9-be1b-e277f3a00ef2" /> 

#### 2. **Expose ArgoCD Server (Local Access)**

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
<img width="1919" height="961" alt="Screenshot from 2025-11-12 19-56-20" src="https://github.com/user-attachments/assets/5167fd95-4026-4991-86f2-4d69cec9d3bb" /> Then access the ArgoCD UI at: 👉 [https://localhost:8080](https://localhost:8080) 

#### 3. **Extract Admin Password** Get the default admin password:

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
```

#### 4. **Login to ArgoCD UI**

- **Username:** admin
- **Password:** (value from above command)

After login, change the password for security. 

<img width="1919" height="961" alt="Screenshot from 2025-11-12 19-58-04" src="https://github.com/user-attachments/assets/fa1f8a5b-2240-4c08-863e-dcee0f404864" /> 

#### 5. **Connect Wisecow GitHub Repository** 

In the ArgoCD dashboard: 
1. Go to **Settings → Repositories → Connect Repo using HTTPS**
2. Add your GitHub repo: `https://github.com/Shikhrshukla/AccuKnox-DevOps-Trainee-Wisecow.git`
3. Authentication Type: **HTTPS with Personal Access Token**

#### 6. **Create Application Manually via UI** 

- Go to **Applications → New App**
- Fill in the details:
  - **App Name:** wisecowapp
  - **Project:** default
  - **Repository URL:** your GitHub repo
  - **Revision:** main - **Path:** helm
  - **Cluster:** https://kubernetes.default.svc
  - **Namespace:** wisecow
- Click **Create** and **Sync**

ArgoCD will: 
- Automatically pull Helm changes (like updated image tags)
- Deploy the latest version of Wisecow to Kubernetes

<img width="1919" height="961" alt="Screenshot from 2025-11-12 20-00-36" src="https://github.com/user-attachments/assets/af69c908-2410-43dc-b091-b2b618e5c07e" />

#### 7. **Verify Deployment**

```bash
kubectl get pods -n wisecow
kubectl get ingress -n wisecow
```

---

## Probelm 2 : Bash Scripts (How to run)

`SystemHealthMonitoring.sh`
1. Make the script executable: use the command `sudo chmod +x SystemHealthMonitoring.sh` to set execute permission on the file.
2. Run as a normal user to write logs to your home directory; the script writes metrics and alerts to `system_health.log` in your home directory.
3. To write logs to system log directory (`/var/log`) run the script with elevated privileges (sudo).
4. To customize thresholds or behavior, open the script and edit the CPU, memory, and disk threshold variables near the top.
5. Check the generated log file to review recorded metrics and any alerts.

<img width="1680" height="878" alt="Screenshot from 2025-11-13 16-43-19" src="https://github.com/user-attachments/assets/bb360674-e8cc-4ab2-8028-ee937c1c1914" />

`ApplicationHealthChecker.sh`
1. Make the script executable: set execute permission on the file using `sudo chmod +x ApplicationHealthChecker.sh`
2. By default the script checks `https://wisecow.local`
3. Run the script; it will periodically check the application endpoint, log status codes and response times, and append results to `application_health.log` in your home directory.
4. Stop monitoring with Ctrl+C. To run the script in background, start it with a job control command appropriate for your shell.
5. Review the log file to see up/down events, response times, and alerts.

<img width="1216" height="955" alt="Screenshot from 2025-11-13 17-18-40" src="https://github.com/user-attachments/assets/2b5cdbec-c33b-4195-b462-59180800be25" />

---

## Probelm 3 : KubeArmor

- Attached the **Screenshots** in kubearmor directory `./kubearmor/Screenshots/` , go through with it. I'm getting **partial output** from that after setting up Cluster Policies.
- It also contains kubearmor policy at `./kubearmor/kubearmor-policy.yaml` location.

---

## 🧠 Learning Outcomes
- Hands-on experience with **Docker, Kubernetes, Helm, GitHub Actions, and ArgoCD**.
- Secure app deployment using **TLS certificates**.
- Automated image versioning and Helm chart updates.
- GitOps-based continuous delivery using ArgoCD.
- Modular, reusable infrastructure setup.
- Gained hands-on experience in system monitoring and application health automation using **Bash Scripting**.
- Secured Kubernetes workloads with **KubeArmor** policies.

---

## 👤 Author
**Shikhar Shukla**  
DevOps Engineer Trainee | AccuKnox Practical Assessment  
GitHub: [shikhrshukla](https://github.com/shikhrshukla)
