Node.js CI/CD Workflow with SonarQube, Snyk, ZAP, and Docker Build
This GitHub Actions workflow automates the process of building, testing, scanning for security vulnerabilities, and deploying a Node.js application to Docker. It includes steps for:

Installing and caching Node.js dependencies.
Building and testing the source code across multiple Node.js versions.
Running static code analysis using SonarQube.
Scanning the code for vulnerabilities using Snyk.
Running a security scan on a web application using ZAP.
Building and pushing a Docker image.
Workflow Overview
This workflow contains multiple jobs that run on each push to the main branch or during a pull request to the main branch.

Workflow Structure
yaml
Copy
name: Build

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

permissions:
  contents: read         # Read access to repository contents (default)
  issues: write           # Write access to issues
  pull-requests: write    # Write access to pull requests
  actions: read           # Read access to workflow runs
Jobs Overview
1. Build Job
Objective: Install Node.js dependencies, cache them, build the project, and run tests.
Steps:
Checkout code.
Set up Node.js version from the matrix configuration.
Install Node.js dependencies using npm install.
Run the build command with npm run build.
yaml

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [22.14.0]  # Define Node.js versions here
    steps:
    - uses: actions/checkout@v4
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    - run: npm install
    - run: npm run build --if-present
2. SonarQube Job
Objective: Perform a static code analysis of the source code using SonarQube.
Steps:
Checkout the repository.
Run the SonarQube scan using SonarSource/sonarqube-scan-action.
The SonarQube token is securely retrieved from GitHub Secrets (SONAR_TOKEN).
yaml

  sonarqube:
    runs-on: ubuntu-latest
    steps:
    - name: sonar scan for source code
      uses: actions/checkout@v2
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0  # Disable shallow clone for full repo analysis
    - name: SonarQube Scan
      uses: SonarSource/sonarqube-scan-action@v4
      env:
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
3. Snyk Security Job
Objective: Scan for security vulnerabilities in the project using Snyk.
Steps:
Checkout the repository.
Use Snyk's GitHub Action to check for vulnerabilities in dependencies.
Snyk token is retrieved from GitHub Secrets (SNYK_TOKEN).
yaml

  snyk-security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run Snyk to check for vulnerabilities
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
4. ZAP Security Scan Job
Objective: Run a security scan of a deployed web application using ZAP (OWASP Zed Attack Proxy).
Steps:
Checkout the repository.
Perform the ZAP scan on the web application hosted at http://54.85.206.95:8081/.
Rules for the scan can be customized using .zap/rules.tsv.
yaml

  zap_scan:
    runs-on: ubuntu-latest
    name: Scan the web application
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          ref: main
      - name: ZAP Scan
        uses: zaproxy/action-baseline@v0.14.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          docker_name: 'ghcr.io/zaproxy/zaproxy:stable'
          target: 'http://54.85.206.95:8081/'
          rules_file_name: '.zap/rules.tsv'
          cmd_options: '-a'
5. Docker Image Build and Push Job
Objective: Build a Docker image for the project and push it to Docker Hub.
Steps:
Checkout the repository.
Build the Docker image using docker buildx.
Tag the image with the latest GitHub SHA (${GITHUB_SHA}).
Log in to Docker Hub using credentials from GitHub Secrets (DOCKER_USERNAME and DOCKER_PASSWORD).
Push the image to Docker Hub.
yaml

  build-docker-image:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Build Docker image
        run: docker buildx build -t netflix-clone:latest .
      - name: Tag Docker image
        run: docker tag netflix-clone:latest davidayo97/netflix-latest:${GITHUB_SHA}
      - name: Show Docker images
        run: docker images
      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      - name: Push Docker image
        run: docker push davidayo97/netflix-latest:${GITHUB_SHA}
Workflow Requirements
GitHub Secrets:

SONAR_TOKEN: Token to authenticate with SonarQube.
SNYK_TOKEN: Token to authenticate with Snyk.
DOCKER_USERNAME: Docker Hub username for login.
DOCKER_PASSWORD: Docker Hub password for login.
GITHUB_TOKEN: Used for interacting with GitHub API.
Node.js: The workflow uses Node.js version 22.14.0 as defined in the matrix.

Docker: Docker is required for building and pushing images.

Conclusion
This GitHub Actions workflow provides a comprehensive CI/CD pipeline for a Node.js application that automates testing, security scanning, and deployment. It ensures that the application is tested, analyzed for vulnerabilities, and ready for deployment in a secure and efficient manner.

For more information on each tool and their setup, refer to the respective official documentation:

SonarQube: SonarQube GitHub Action
Snyk: Snyk GitHub Action
ZAP: ZAP GitHub Action
Docker: Docker GitHub Action
