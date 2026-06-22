# Secure DevSecOps CI/CD Pipeline for Node.js Application
---

# Executive Summary

This project demonstrates the implementation of a complete Secure DevSecOps CI/CD Pipeline for a Node.js application.

The primary objective was to automate the complete software delivery lifecycle while integrating security checks at every stage.

The solution includes:

* Source Code Management using GitHub
* Security Scanning using DevSecOps tools
* Docker Image Creation
* Private Docker Registry
* Azure VM Deployment
* Nginx Reverse Proxy
* Automated CI/CD using GitHub Actions

The project follows DevSecOps best practices by ensuring vulnerabilities are detected before deployment.

---

# Project Objectives

The main objectives of this project were:

### Security

Integrate security scanning into the CI/CD pipeline.

### Automation

Automate build and deployment processes.

### Reliability

Ensure consistent deployments.

### Compliance

Identify vulnerabilities before production deployment.

### Infrastructure Control

Store Docker images in a self-managed Private Docker Registry instead of public registries.

---

# Business Requirements

Manager requirements were:

1. Deploy application on Azure Virtual Machine.
2. Store Docker images in a Private Registry.
3. Avoid Docker Hub, AWS ECR, and Azure ACR.
4. Perform security scanning before deployment.
5. Automate deployment process.
6. Use GitHub Actions as CI/CD platform.

---

# Technologies Used

## Version Control

* Git
* GitHub

## CI/CD

* GitHub Actions

## Containerization

* Docker

## Reverse Proxy

* Nginx

## Cloud Platform

* Microsoft Azure VM

## Private Registry

* Registry:2 Container

## Security Tools

* Gitleaks
* Semgrep
* Checkov
* NPM Audit
* Trivy

---

# Phase 1 – Initial Manual Deployment

Initially deployment was performed manually.

## Manual Deployment Workflow

Developer
↓
GitHub Repository
↓
GitHub Actions
↓
Build Docker Image
↓
docker save
↓
SCP Transfer
↓
Azure VM
↓
docker load
↓
docker run

---

## Manual Image Transfer Using SCP

Docker image exported:

docker save secure-nodejs-app:latest > app-image.tar

Transferred to Azure VM:

scp app-image.tar azureuser@VM-IP:/home/azureuser

Loaded on VM:

docker load -i app-image.tar

Started manually:

docker run -d secure-nodejs-app

---

## Problems with Manual Deployment

* Manual image transfer
* Manual deployment
* Human dependency
* Slow delivery process
* Not scalable
* Error-prone

---

# Phase 2 – Automated Deployment

To eliminate manual effort, deployment was automated using GitHub Actions.

---

# Final Automated Workflow

Developer
↓
Git Push
↓
GitHub Repository
↓
GitHub Actions
↓
Security Scans
↓
Docker Build
↓
Trivy Scan
↓
Push Docker Image
↓
Private Docker Registry
↓
SSH Deployment
↓
Docker Pull
↓
Docker Run
↓
Nginx
↓
Application

---

# Security Tools Implementation

## Gitleaks

Purpose:

Detect secrets accidentally committed into source code.

Examples:

* API Keys
* Passwords
* Access Tokens
* Secrets

---

## Semgrep

Purpose:

Static Application Security Testing (SAST)

Checks:

* Vulnerable code patterns
* Insecure coding practices
* Hardcoded secrets

---

## Checkov

Purpose:

Infrastructure Security Scanning

Checks:

* Dockerfile configurations
* Infrastructure configurations

---

## NPM Audit

Purpose:

Dependency vulnerability scanning.

Checks:

* Vulnerable packages
* Known CVEs

---

## Trivy

Purpose:

Container image vulnerability scanning.

Checks:

* OS vulnerabilities
* Package vulnerabilities
* Critical CVEs

---

# GitHub Actions Pipeline Stages

## Stage 1

Checkout Source Code

## Stage 2

Run Gitleaks Scan

## Stage 3

Run Semgrep Scan

## Stage 4

Run Checkov Scan

## Stage 5

Run NPM Audit

## Stage 6

Build Docker Image

## Stage 7

Run Trivy Scan

## Stage 8

Push Image to Private Registry

## Stage 9

SSH into Azure VM

## Stage 10

Pull Latest Image

## Stage 11

Restart Application Container

## Stage 12

Deployment Complete

---

# Private Docker Registry Setup

Manager required images to be stored on company-controlled infrastructure.

Therefore a self-hosted Private Docker Registry was implemented.

Registry Container:

docker run -d 
-p 5000:5000 
--restart always 
--name registry 
registry:2

Benefits:

* Full control over images
* Internal storage
* Better security
* No dependency on Docker Hub

---

# Azure VM Architecture

The Azure VM hosts:

## Container 1

Private Registry

registry:2

Purpose:

Stores approved Docker images.

---

## Container 2

Node.js Application

secure-nodejs-app

Purpose:

Runs application.

---

## Container 3

Nginx

Purpose:

Acts as Reverse Proxy.

---

# Major Issues Encountered and Resolutions

## Issue 1 – index.html Not Found

### Error

ENOENT: no such file or directory stat '/app/public/index.html'

---

### Investigation

Application expected:

public/index.html

But repository contained:

Public/index.html

---

### Root Cause

Linux containers are case-sensitive.

Public and public are treated as different directories.

Windows:

Public == public

Linux:

Public != public

---

### Resolution

Folder renamed:

Public
↓
public

Changes committed and pushed.

Pipeline redeployed successfully.

---

### Learning

Always maintain lowercase directory naming conventions when deploying applications to Linux-based environments.

---

# Issue 2 – Nginx 502 Bad Gateway

### Error

502 Bad Gateway

---

### Investigation

Application container logs:

docker logs secure-nodejs-app

Output:

Server running on port 3000

Application was healthy.

---

### Verification

curl http://localhost:3000

Application returned HTML successfully.

Meaning:

Node.js application was working correctly.

---

### Root Cause

Nginx container and Application container were running on different Docker networks.

Nginx Network:

secure-network

Application Network:

bridge

Nginx attempted to communicate using:

http://secure-nodejs-app:3000

But container DNS resolution failed because both containers were not connected to the same Docker network.

---

### Resolution

Application container recreated using:

docker rm -f secure-nodejs-app

docker run -d 
--name secure-nodejs-app 
--network secure-network 
-p 3000:3000 
localhost:5000/secure-nodejs-app:24

---

### Result

Nginx successfully connected to application container.

Website became accessible through browser.

---

### Learning

Docker container communication requires:

* Same Docker Network
* Reachable Port
* Proper Container DNS Resolution

---

# Security Improvements Implemented

## Secret Detection

Implemented using Gitleaks.

---

## Static Code Analysis

Implemented using Semgrep.

---

## Infrastructure Security Validation

Implemented using Checkov.

---

## Dependency Scanning

Implemented using NPM Audit.

---

## Container Image Scanning

Implemented using Trivy.

---

## Private Image Storage

Implemented using Private Registry.

---

# Final Architecture

Developer
↓
GitHub Repository
↓
GitHub Actions Pipeline
↓
Gitleaks
↓
Semgrep
↓
Checkov
↓
NPM Audit
↓
Docker Build
↓
Trivy Scan
↓
Private Docker Registry
↓
Azure VM
↓
Docker Container
↓
Nginx Reverse Proxy
↓
Users

---

# Architecture Explanation

## GitHub Repository

Stores source code.

---

## GitHub Actions

Automates build, security validation and deployment.

---

## Security Layer

Performs security scanning before deployment.

---

## Docker Build

Creates deployable Docker image.

---

## Private Registry

Stores approved Docker images.

---

## Azure VM

Deployment server.

---

## Docker Container

Runs Node.js application.

---

## Nginx

Acts as reverse proxy and forwards requests to application container.

---

## End Users

Access application through public IP address.

---

# Project Achievements

Successfully implemented:

✔ Automated CI/CD Pipeline

✔ Automated Deployment

✔ Security Scanning

✔ Private Docker Registry

✔ Azure VM Deployment

✔ Dockerized Application

✔ Nginx Reverse Proxy

✔ GitHub Actions Automation

✔ Vulnerability Detection

✔ Secure Deployment Workflow

---

# Conclusion

A complete Secure DevSecOps CI/CD Pipeline was successfully implemented for a Node.js application.

The solution integrates automated security scanning, Docker containerization, private image storage, automated deployment, and reverse proxy configuration.

The project demonstrates real-world DevSecOps practices used in enterprise environments and significantly improves deployment speed, security, and reliability while reducing manual effort.
