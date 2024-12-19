#!/bin/bash

# Recon Script for ProjectDiscovery Tools
# Ensure all required tools are installed before running this script

# Prompt for the domain
read -p "Enter the domain to perform reconnaissance: " domain

# Create output directory
output_dir="recon_results_$domain"
mkdir -p "$output_dir"

# Subfinder - Subdomain Enumeration
echo "[INFO] Running Subfinder..."
subfinder -d "$domain" -o "$output_dir/subfinder.txt"

# Chaos - Fetch Assets from Chaos Dataset
echo "[INFO] Running Chaos..."
chaos -d "$domain" -o "$output_dir/chaos.txt"

# DNSX - DNS Resolution
echo "[INFO] Running DNSX..."
cat "$output_dir/subfinder.txt" "$output_dir/chaos.txt" | dnsx -silent -o "$output_dir/dnsx.txt"

# HTTPX - Probe HTTP Services
echo "[INFO] Running HTTPX..."
cat "$output_dir/dnsx.txt" | httpx -silent -o "$output_dir/httpx.txt"

# Katana - URL Crawling
echo "[INFO] Running Katana..."
katana -list "$output_dir/httpx.txt" -o "$output_dir/katana.txt"

# Naabu - Port Scanning
echo "[INFO] Running Naabu..."
naabu -host "$domain" -o "$output_dir/naabu.txt"

# Nuclei - Vulnerability Scanning
echo "[INFO] Running Nuclei..."
nuclei -u "$domain" -o "$output_dir/nuclei.txt"

# Uncover - Find Exposed Assets
echo "[INFO] Running Uncover..."
uncover -d "$domain" -o "$output_dir/uncover.txt"

# Notify - Send Notifications (Optional)
echo "[INFO] Running Notify..."
notify -data "$output_dir/nuclei.txt"

# CVE Map - Fetch CVE Details
echo "[INFO] Running CVE Map..."
cat "$output_dir/nuclei.txt" | cvemap -o "$output_dir/cvemap.txt"

# Interactsh - OOB Interaction Testing
echo "[INFO] Running Interactsh..."
interactsh-client -d "$domain" -o "$output_dir/interactsh.txt"

# PDTM - Template Management (Optional)
echo "[INFO] Running PDTM to update templates..."
pdtm -update-all

# Completion Message
echo "[INFO] Reconnaissance completed. Results saved in $output_dir."
