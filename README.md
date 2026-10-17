# OCI Free Tier Automation

> Automated retry script to claim Oracle Cloud Infrastructure (OCI) Always Free **Ampere A1 Flex** instances when facing capacity limits (`Out of host capacity`).

---

## 📌 Problem & Solution

* **Problem:** Oracle Cloud's Always Free ARM instances (**VM.Standard.A1.Flex**) are frequently unavailable due to high demand, resulting in the `Out of host capacity` error when launching via the web console.
* **Solution:** This lightweight Bash script uses OCI CLI within Cloud Shell to continuously request an instance every 30 seconds until capacity becomes available.

---

## 🚀 Features

- **Robust Retry Mechanism:** Automatically retries on capacity limits, rate limits, and transient server errors.
- **Safe JSON Config Parsing:** Uses a temporary `/tmp/shape.json` file to pass shape configurations without escaping issues.
- **Persistent Execution:** Can be run in the background using `tmux` or `nohup` so it keeps running even if the browser is closed.

---

## 🛠️ Usage Guide

### 1. Open OCI Cloud Shell
Log in to your [Oracle Cloud Console](https://cloud.oracle.com/) and open the **Cloud Shell** (terminal icon at the top right).

### 2. Clone Repository
```bash
git clone [https://github.com/Denex7/OCI-Free-Tier-Automation.git](https://github.com/Denex7/OCI-Free-Tier-Automation.git)
cd OCI-Free-Tier-Automation
