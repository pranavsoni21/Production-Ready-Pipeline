# Production-Ready Containerized Application Deployment Pipeline

This project was built to strengthen my understanding of DevOps practices and to explore how real-world workflows operate in an organization, from building an application to deploying it in production using automated pipelines.

---

# Project Goal

Over the last month, I have been learning and practicing various DevOps tools. After gaining a solid understanding of AWS (Cloud), Terraform, CI/CD automation, containerization with Docker, and deployments using ECS and EC2, I wanted to apply this knowledge by building a practical project.

This project demonstrates my understanding of:

- Containerization
- CI/CD automation
- AWS container deployment
- Multi-architecture image builds
- Zero-downtime deployment strategies

---

# Architecture Overview

<img width="1238" height="847" alt="Production-Ready-Pipeline" src="https://github.com/user-attachments/assets/748908d1-57ae-4df4-be36-ea9d67863fda" />


```
Developer pushes code
↓
GitHub Actions pipeline triggers
↓
Docker Buildx builds multi-architecture image
↓
Image pushed to AWS ECR
↓
ECS service pulls new image
↓
Application Load Balancer distributes traffic
```

---

### Developer pushes code

Whenever a developer pushes code to the main branch of the repository, the CI/CD pipeline is automatically triggered using a GitHub Actions workflow.

---

### GitHub Actions pipeline triggers

The workflow is configured to run on every push to the app/* folder.

The workflow file defines:

- the workflow name
- the runner environment
- the jobs that need to be executed
- the steps required to complete the pipeline

---

### Docker Buildx builds multi-architecture image

Once the pipeline starts, it performs the following steps:

- checks out the repository code
- configures AWS credentials
- builds a multi-architecture Docker image using Docker Buildx

Building multi-architecture images ensures that the application can run on machines with different CPU architectures during deployment.

I also implemented commit-based image tagging, which helps maintain clear versioning and simplifies rollbacks if needed.

---

### Image pushed to AWS ECR

After the image is built, the pipeline pushes it to an AWS Elastic Container Registry (ECR) repository, where it is securely stored and versioned.

---

### ECS service pulls new image

Since the ECS infrastructure is already configured, the pipeline performs the following actions:

1. extracts the existing ECS task definition
2. updates the container image version
3. registers the updated task definition
4. deploys the new task as running containers

This automatically launches new containers with the updated application image.

---

### ALB distributes traffic

The ECS service is configured with an Application Load Balancer (ALB).

The ALB provides:

- rolling deployments
- zero-downtime updates
- health checks for containers
- traffic distribution across running containers

This ensures that users always reach healthy containers during deployments.

---

# Technologies Used

### Application

- Python
- Flask
- Gunicorn

### Containerization

- Docker
- Multi-stage builds
- Docker Buildx

### CI/CD

- GitHub Actions

### Cloud Infrastructure

- AWS ECR
- AWS ECS
- Application Load Balancer

---

# Design Decisions

### Why I used multi-stage builds

While building the Docker image, I used a multi-stage build process.

In this approach:

- The first stage (builder stage) compiles the application and installs heavy dependencies.
- The second stage uses a minimal base image (such as alpine or debian-slim) and copies only the compiled artifacts from the builder stage.

This approach excludes unnecessary components such as:

- source code
- build tools
- development dependencies

Since Docker uses the last stage as the final image, this significantly reduces the image size and minimizes potential security risks.

---

### Why I used Gunicorn instead of the Flask development server

The default Flask server is intended only for development purposes and is not designed to handle production workloads.

Gunicorn, on the other hand, is a production-grade WSGI server that provides:

- better performance
- improved stability
- higher concurrency
- production-ready security

Therefore, Gunicorn is more suitable for running Flask applications in production environments.

---

# How to Run Locally

```
# Clone the repository
git clone https://github.com/pranavsoni21/Production-Ready-Pipeline.git

# Change directory
cd Production-Ready-Pipeline

# Build Docker image
docker build -t app:latest .

# Run container
docker run -it --name app -p 8000:8000 app:latest
```

---

# Future Improvements

- Infrastructure provisioning using Terraform ✅
- Container vulnerability scanning
- Monitoring and observability ✅
- Autoscaling configuration
- Database integration

---

# Lessons Learned

Through this project I gained hands-on experience with:

- Docker multi-architecture image builds
- ECS deployment workflows
- CI/CD automation using GitHub Actions
- ALB-based zero-downtime deployments
