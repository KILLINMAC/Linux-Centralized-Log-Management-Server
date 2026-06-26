# Linux Centralized Log Management Server

## 📖 Project Overview

The **Linux Centralized Log Management Server** is a DevOps project that demonstrates how to collect, centralize, and manage logs from multiple Linux servers using **rsyslog** and **logrotate** on **AWS EC2**.

A dedicated log server receives logs from multiple client machines over the network, stores them in a centralized location, and automatically rotates and compresses log files to optimize disk usage.

This project simulates a real-world enterprise logging infrastructure used for troubleshooting, monitoring, auditing, and system administration.

---

## 🏗️ Architecture

```text
                        AWS VPC
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        │                  │                  │
┌────────────────┐  ┌────────────────┐  ┌─────────────────────┐
│ Client Server 1│  │ Client Server 2│  │ Central Log Server  │
│ Ubuntu EC2     │  │ Ubuntu EC2     │  │ Ubuntu EC2          │
│ rsyslog Client │  │ rsyslog Client │  │ rsyslog + logrotate │
└───────┬────────┘  └───────┬────────┘  └──────────┬──────────┘
        │                   │                      │
        └────────── TCP 514 ┴──────────────────────┘
                            │
                            ▼
                /var/log/centralized/
                            │
          ┌─────────────────┼─────────────────┐
          ▼                 ▼                 ▼
     client1.log      client2.log      client3.log
                            │
                            ▼
                      logrotate
                            │
                            ▼
              client1.log.1.gz
              client2.log.1.gz
```

---

## 🚀 Features

- Centralized log collection from multiple Linux servers
- Real-time log forwarding using rsyslog
- Automatic log rotation using logrotate
- Log compression to reduce disk usage at scheduled time
- Configurable log retention policy
- Automated setup using Bash scripts
- AWS EC2 based deployment
- Easy to scale by adding more client servers

---

## 🛠️ Technologies Used

- Ubuntu 
- AWS EC2
- Linux
- Bash Scripting
- rsyslog
- logrotate
- Git
- GitHub

---

## 📁 Project Structure

```text
Linux-Centralized-Log-Management-Server/
│
├── server/
│   └── server.sh
│
├── client/
│   └── client.sh
│
├── docs/
│   └── architecture.md
│
├── screenshots/
│
└── README.md
```

---

## ⚙️ Prerequisites

- AWS Account
- Three Ubuntu EC2 Instances
- SSH Key Pair
- Git Installed
- Security Group configured to allow:
  - SSH (22)
  - TCP 514
  - UDP 514 (optional)

---

## 🖥️ Server Setup

Navigate to the server directory:

```bash
cd server
```

Make the script executable:

```bash
chmod +x server.sh
```

Run the script:

```bash
sudo ./server.sh
```

The script will:

- Install rsyslog
- Install logrotate
- Configure rsyslog to receive remote logs
- Create centralized log directory
- Configure automatic log rotation
- Enable and start required services

---

## 💻 Client Setup

Navigate to the client directory:

```bash
cd client
```

Edit the script and update the log server's **private IP address**:

```bash
LOG_SERVER_IP="YOUR_SERVER_PRIVATE_IP"
```

Make the script executable:

```bash
chmod +x client.sh
```

Run the script:

```bash
sudo ./client.sh
```

The client will:

- Install rsyslog
- Configure remote log forwarding
- Start the rsyslog service
- Send a test log message to the server

---

## 🧪 Testing

Generate a test log on any client:

```bash
logger "Testing centralized logging"
```

On the log server:

```bash
ls -l /var/log/centralized
```

View received logs:

```bash
cat /var/log/centralized/*.log
```

---

## 🔄 Log Rotation

This project uses **logrotate** to manage centralized log files.

Configuration includes:

- Daily rotation
- Keep last 7 log files
- Compress old logs
- Skip empty logs
- Automatically create new log files
- Preserve proper ownership and permissions

Force a manual rotation:

```bash
sudo logrotate -f /etc/logrotate.d/centralized-logs
```

Verify rotated logs:

```bash
ls -lh /var/log/centralized
```

Example output:

```text
client1.log
client1.log.1.gz
client2.log
client2.log.1.gz
```

---

## 📂 Important Directories

Centralized logs:

```text
/var/log/centralized/
```

rsyslog configuration:

```text
/etc/rsyslog.conf
/etc/rsyslog.d/30-centralized.conf
```

Client forwarding configuration:

```text
/etc/rsyslog.d/50-forward.conf
```

logrotate configuration:

```text
/etc/logrotate.d/centralized-logs
```

---

## 🔍 Troubleshooting

### No logs received

Check rsyslog status:

```bash
sudo systemctl status rsyslog
```

---

### Validate rsyslog configuration

```bash
sudo rsyslogd -N1
```

---

### Verify server listening on port 514

```bash
sudo ss -tuln | grep 514
```

---

### Test client connectivity

```bash
nc -vz <SERVER_PRIVATE_IP> 514
```

---

### Check log directory

```bash
ls -ld /var/log/centralized
```

---

## 📸 Screenshots

Add screenshots demonstrating:

- AWS EC2 Instances
- Security Group Configuration
- Log Server Setup
- Client Setup
- Received Logs
- Log Rotation
- Project Directory Structure

---

## 📚 Learning Outcomes

This project demonstrates practical experience with:

- Linux System Administration
- AWS EC2 Deployment
- Centralized Logging
- rsyslog Configuration
- Log Management
- Bash Automation
- Log Rotation and Retention
- DevOps Infrastructure Management

---

## 🚀 Future Improvements

- Secure log forwarding using TLS
- Elasticsearch integration
- Kibana dashboards
- Logstash pipeline
- Filebeat agents
- Ansible automation
- Terraform deployment
- Docker containerization
- Monitoring with Prometheus and Grafana

---

## 👨‍💻 Author

**KILLINMAC**

Linux & DevOps Projects

---

## ⭐ Repository

If you found this project useful, consider giving it a ⭐ on GitHub.
