# Build, Scan, and Push Docker Image with GitHub Actions

This repository automates the process of building, scanning, and pushing a Docker image to Docker Hub using GitHub Actions. It includes dependency and container security scanning to ensure the integrity of the deployment.

## Features

- **Automated Docker Image Build**: Automatically builds the Docker image from the source code and a `Dockerfile`.
- **Security Scanning**:
  - Dependency scanning using `pip-audit`.
  - Docker image scanning using `Trivy` for vulnerabilities.
- **Deployment**:
  - Pushes the built Docker image to Docker Hub.
- **Report Generation**:
  - Outputs a detailed vulnerability report for review.

## Workflow Overview

The GitHub Actions workflow triggers on every push to the `main` branch. The workflow performs the following steps:

1. Check out the repository.
2. Log in to Docker Hub.
3. Scan Python dependencies for vulnerabilities using `pip-audit`.
4. Build the Docker image.
5. Scan the Docker image for vulnerabilities using `Trivy`.
6. Upload the Trivy scan report as an artifact.
7. Push the Docker image to Docker Hub.

## Prerequisites

To use this repository, you need:

1. A Docker Hub account.
2. Docker installed locally (for manual builds and testing).
3. The following secrets configured in your GitHub repository:
   - `DOCKER_USERNAME`: Your Docker Hub username.
   - `DOCKER_PASSWORD`: Your Docker Hub access token.

## Usage

### Local Development

1. **Build the Docker Image**:
   ```bash
   docker build -t your-image-name:latest .
   ```
2. **Run Dependency Scanning**
 ```bash
 pip install pip-audit
 pip-audit -r requirements.txt
```

3. **Run Image Scanning** 
```bash
trivy image your-image-name:latest
```
## Github Actions Workflow
The workflow file is located at `.github/workflows/docker-publish.yml`. To customize the workflow, edit this file.

### Trigger the Workflow 

1. Push the changes to the `main` branch: 

```bash 
git add .
git commit -m "Trigger workflow"
git push origin main
```
2. Monitor the workflow in the **Actions** tab of this repository

## Outputs 

### Trivy Scan Report 
The Trivy scan report is saved as an artifact and can be downloaded from the workflow run page in the **Actions** tab.

## Directory Structure 
```
.
├── .github/
│   └── workflows/
│       └── docker-publish.yml  # GitHub Actions workflow file
├── Dockerfile                  # Dockerfile to build the image
├── requirements.txt            # Python dependencies
└── README.md                   # Repository documentation
```

## Example Workflow 
Here’s a snippet of the GitHub Actions workflow:
```
name: Build, Scan, and Push Docker Image

on:
  push:
    branches:
      - main

jobs:
  build-scan-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Scan dependencies with pip-audit
        run: |
          pip install pip-audit
          pip-audit -r requirements.txt

      - name: Build Docker image
        run: |
          docker build -t ${{ secrets.DOCKER_USERNAME }}/your-image-name:latest .

      - name: Scan Docker image with Trivy
        uses: aquasecurity/trivy-action@v0.11.0
        with:
          image-ref: ${{ secrets.DOCKER_USERNAME }}/your-image-name:latest
          format: json
          output: trivy-report.json
          exit-code: 1
          severity: CRITICAL,HIGH

      - name: Upload Trivy report
        uses: actions/upload-artifact@v3
        with:
          name: trivy-report
          path: trivy-report.json

      - name: Push Docker image
        run: |
          docker push ${{ secrets.DOCKER_USERNAME }}/your-image-name:latest

```
## Security

**Dependency Scanning**: `pip-audit` ensures Python dependencies are free from vulnerabilities.
**Image Scanning**: `Trivy` detects vulnerabilities in the Docker image.
**GitHub Secrets**: Ensure sensitive information (e.g., Docker Hub credentials) is stored securely in GitHub Secrets.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This repository is licensed under the MIT License.
