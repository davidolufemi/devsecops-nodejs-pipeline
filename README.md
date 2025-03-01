# CI/CD Pipeline for Node.js with SonarQube, Snyk, ZAP, and Docker

This GitHub Actions workflow automates the process of building, testing, scanning for security vulnerabilities, and deploying a Node.js application to Docker. It includes steps for:

1. Installing and caching Node.js dependencies.
2. Building and testing the source code across multiple Node.js versions.
3. Running static code analysis using SonarQube.
4. Scanning the code for vulnerabilities using Snyk.
5. Running a security scan on a deployed web application using ZAP.
6. Building and pushing a Docker image to Docker Hub.

## Workflow Structure

The workflow runs on every push or pull request to the `main` branch. 

### Jobs Overview

#### 1. **Build Job**
- **Objective:** Install Node.js dependencies, cache them, build the project, and run tests.
- **Steps:**
  - Checkout code.
  - Set up Node.js version from the matrix configuration.
  - Install Node.js dependencies using `npm install`.
  - Run the build command with `npm run build`.

#### 2. **SonarQube Job**
- **Objective:** Perform a static code analysis of the source code using SonarQube to find bugs, vulnerabilities, and code smells.
- **Steps:**
  - Checkout the repository.
  - Run the SonarQube scan.
  - The SonarQube token is securely retrieved from GitHub Secrets (`SONAR_TOKEN`).

#### 3. **Snyk Security Job**
- **Objective:** Scan for security vulnerabilities in the project using Snyk.
- **Steps:**
  - Checkout the repository.
  - Use Snyk's GitHub Action to check for vulnerabilities in dependencies.
  - Snyk token is retrieved from GitHub Secrets (`SNYK_TOKEN`).

#### 4. **ZAP Security Scan Job**
- **Objective:** Run a security scan of a deployed web application using ZAP (OWASP Zed Attack Proxy).
- **Steps:**
  - Checkout the repository.
  - Perform the ZAP scan on the web application.
  - Rules for the scan can be customized using `.zap/rules.tsv`.

#### 5. **Docker Image Build and Push Job**
- **Objective:** Build a Docker image for the project and push it to Docker Hub.
- **Steps:**
  - Checkout the repository.
  - Build the Docker image using `docker buildx`.
  - Tag the image with the latest GitHub SHA (`${GITHUB_SHA}`).
  - Log in to Docker Hub using credentials from GitHub Secrets (`DOCKER_USERNAME` and `DOCKER_PASSWORD`).
  - Push the image to Docker Hub.

### Workflow Requirements

1. **GitHub Secrets:**
   - `SONAR_TOKEN`: Token to authenticate with SonarQube.
   - `SNYK_TOKEN`: Token to authenticate with Snyk.
   - `DOCKER_USERNAME`: Docker Hub username for login.
   - `DOCKER_PASSWORD`: Docker Hub password for login.
   - `GITHUB_TOKEN`: Used for interacting with GitHub API.

2. **Node.js:** The workflow uses Node.js version `22.14.0` as defined in the matrix.

3. **Docker:** Docker is required for building and pushing images.

### Conclusion

This GitHub Actions workflow provides a comprehensive CI/CD pipeline for a Node.js application that automates testing, security scanning, and deployment. It ensures that the application is tested, analyzed for vulnerabilities, and ready for deployment in a secure and efficient manner.

For more information on each tool and their setup, refer to the respective official documentation:
- **SonarQube:** [SonarQube GitHub Action](https://github.com/SonarSource/sonarqube-scan-action)
- **Snyk:** [Snyk GitHub Action](https://github.com/snyk/actions)
- **ZAP:** [ZAP GitHub Action](https://github.com/zaproxy/action-baseline)
- **Docker:** [Docker GitHub Action](https://github.com/docker/login-action)

### Contributing

Feel free to fork this repository, open issues, or submit pull requests to improve the pipeline!
