# DevOps Capstone 1 — Voting App

A containerized voting application used to demonstrate Docker, Kubernetes, Terraform, Helm and GitHub Actions.

## Repository
- GitHub fork: https://github.com/morecrownsamuel/example-voting-app

## Application architecture
The `vote` service accepts votes and places them in Redis. The `worker` consumes queued votes and stores them in PostgreSQL. The `result` service displays the totals.

## Run locally with Docker Compose
From the repository root:

```bash
docker compose up -d

docker compose ps
```

Use the ports published by the Compose configuration to open the vote and result applications. To stop the local stack:

```bash
docker compose down
```

## Kubernetes / Helm / Terraform
- Terraform configuration: `terraform/`
- Voting App Helm chart: `voting-app/`
- Terraform/Helm checks workflow: `.github/workflows/terraform-helm-checks.yml`

The Terraform configuration in this repository configures the Kubernetes provider from the local kubeconfig and manages a `terraform-lab` namespace. It does **not** provision an AWS EKS cluster. The current AWS EKS access issue is separate from the local Minikube environment.

Typical validation commands (require the tools installed; Terraform validation may initialize providers):

```bash
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
helm lint ./voting-app
```

## CI/CD
The repository includes component image build workflows and a Terraform/Helm validation workflow. Check the **Actions** tab for the latest run results. A green validation job is not by itself proof that a full deployment or image push succeeded.

## Evidence and current status
Previously demonstrated during development: the Voting App and Results pages loaded locally through Kubernetes services; application pods were reported `1/1 Running`; and a Helm rollback completed successfully, with Helm history showing a rollback revision. The local Minikube API server later became unstable due to etcd/API health errors. These historical results do not guarantee the cluster is currently healthy.

## Security notes
- Do not commit kubeconfig files, cloud credentials, tokens, `.env` secrets or Terraform state containing sensitive values.
- Use repository/organization secrets for CI credentials.
- Review base image versions, non-root execution and `.dockerignore` files before claiming the safe-containerization criteria are complete.

## Architecture diagram
See [`docs/architecture.mmd`](docs/architecture.mmd) (copy the provided diagram there).
