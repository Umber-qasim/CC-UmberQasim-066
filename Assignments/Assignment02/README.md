# Assignment 2 — Multi-Tier Web Infrastructure

## Project Overview

This project demonstrates the deployment of a **multi-tier web infrastructure**
on **AWS**, simulating a real-world web application architecture.

An **Nginx server** is used as a **reverse proxy and load balancer** to distribute
incoming client traffic across multiple **Apache backend web servers**.

### Key Features
- Load Balancing
- Traffic Handling
- Fault Tolerance
- Scalability
- Performance Optimization

---

## Architecture Overview
<pre>
┌──────────────────────────────────────────┐
│                Internet                  │
└───────────────────┬──────────────────────┘
                    │
          HTTPS (443) / HTTP (80)
                    │
                    ▼
        ┌──────────────────────────┐
        │        Nginx Server      │
        │   (Reverse Proxy + LB)   │
        │  - SSL / TLS (HTTPS)     │
        │  - Load Balancing        │
        │  - Caching               │
        │  - Rate Limiting         │
        │  - Security Headers      │
        └───────────┬──────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
 ┌──────────┐ ┌──────────┐ ┌──────────┐
 │  Web-1   │ │  Web-2   │ │  Web-3   │
 │ Apache   │ │ Apache   │ │ Apache   │
 │ Primary  │ │ Primary  │ │ Backup   │
 └──────────┘ └──────────┘ └──────────┘
</pre>
## Components Description

### Nginx Server (Load Balancer)

- Entry point for all client traffic
- Distributes requests to backend servers
- Implements:
  - Reverse Proxy
  - HTTPS Termination
  - Caching (`proxy_cache`)
  - Rate Limiting (`limit_req`, `limit_conn`)

---

### Backend Servers (Web-1, Web-2, Web-3)

- Run Apache HTTP Server
- Host the web application
- Web-1 and Web-2 act as **primary servers**
- Web-3 acts as a **backup server**

---

## Terraform

### Infrastructure as Code (IaC) Tool

- Automates provisioning of AWS infrastructure
- Defines infrastructure components
- Enables repeatable and consistent deployments
- Improves security and scalability

---

## Prerequisites

### Required Tools

- Terraform
- AWS CLI
- SSH Client

---

## AWS Credentials Setup

```bash
aws configure
```

Provide:
- AWS Access Key: AKI*****************
- AWS Secret Key: LUhx************************************
- Region: me-central-1
- Output format: json

---

## SSH Key Setup

Creating a new EC2 key pair: keys

---

## Deployment Instructions

```bash
git clone git@github.com:Umber-qasim/Assignment-2.git
cd Assignment-2
terraform init
terraform validate
terraform apply
```

Type **yes** when prompted.

---

## Configuration Guide

Update backend IPs in Nginx:

```nginx
upstream backend_servers {
    server 10.0.10.57;
    server 10.0.10.108;
    server 10.0.10.31; backup;
}
```

## Reload Nginx:
sudo systemctl reload nginx

### Nginx Configuration Explanation
- proxy_pass
  - forwards requests to backend servers
- load balancing
  - distributes incoming traffic
- limit_req
  - enforces rate limiting
- error_page
  - handles custom error responses

---

## Testing

```bash
curl http://3.28.185.216
```

### Test Rate Limiting:
```bash
for i in {1..20}; do curl -I http://3.28.185.216; done
```

### Verify Cache:
- Check response headers for cache status.
---

## Architecture Details

### Network Topology
- Single VPC
- Public subnet for Nginx
- Backend servers accessible only through Nginx

### Security Group Setup
- Nginx Security Group: Allow HTTP (80), Allow SSH (22)
- Backend Security Group: Allow HTTP from Nginx only, Allow SSH for administration

### Load Balancing Strategy
- Nginx round-robin load balancing
- Backup server activated if primary servers fail

## Troubleshooting

### Common Issues and Solutions

Backend not responding:
- sudo systemctl status httpd
- curl 3.28.185.216 — Verify backend IP addresses. Ensure Apache is running on backend servers.

### Log Locations
Nginx access log: /var/log/nginx/access.log
Nginx error log: /var/log/nginx/error.log
