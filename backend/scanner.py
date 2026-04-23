import nmap
import socket
import logging

logging.basicConfig(level=logging.INFO)

def run_scan(target, scan_type):
    vulnerabilities = []
    
    # Resolve IP if target is domain
    try:
        ip = socket.gethostbyname(target)
    except socket.gaierror:
        ip = target # Might already be an IP

    # Nmap scan
    try:
        nm = nmap.PortScanner()
        arguments = '-F' if scan_type == 'Quick' else '-sV -sC'
        logging.info(f"Scanning {ip} with args: {arguments}")
        nm.scan(ip, arguments=arguments)
        
        for host in nm.all_hosts():
            for proto in nm[host].all_protocols():
                lport = list(nm[host][proto].keys())
                for port in lport:
                    state = nm[host][proto][port]['state']
                    service = nm[host][proto][port]['name']
                    product = nm[host][proto][port].get('product', '')
                    version = nm[host][proto][port].get('version', '')
                    
                    if state == 'open':
                        # Basic Vulnerability heuristics
                        if port in [21, 23, 25]:
                            vulnerabilities.append({
                                "title": f"Insecure Service Port {port} ({service}) Open",
                                "severity": "High",
                                "description": f"The port {port} runs an unencrypted service which is vulnerable to sniffing.",
                                "fix": "Disable this service or use an encrypted alternative (e.g., SSH instead of Telnet)."
                            })
                        elif port == 80:
                            vulnerabilities.append({
                                "title": "HTTP Service Port 80 Open",
                                "severity": "Medium",
                                "description": "Port 80 is open. It is recommended to use HTTPS (443) instead of HTTP.",
                                "fix": "Ensure all traffic is redirected to HTTPS."
                            })
                        else:
                            # Info level finding
                            vulnerabilities.append({
                                "title": f"Open Port: {port} ({service})",
                                "severity": "Low",
                                "description": f"Port {port} is open running {service} {product} {version}.",
                                "fix": "Review if this port needs to be exposed."
                            })
                            
    except Exception as e:
        logging.error(f"Nmap scan failed: {e}")
        vulnerabilities.append({
            "title": "Nmap Scan Error",
            "severity": "Low",
            "description": f"Could not complete port scanning. Error: {str(e)}",
            "fix": "Check target reachability or scanner permissions. Nmap must be installed on the system."
        })

    # Simulated ZAP/Web Scan for demonstration
    if scan_type != 'Quick':
        vulnerabilities.append({
            "title": "Missing Security Headers",
            "severity": "Low",
            "description": "The web server is missing security headers like X-Frame-Options or Content-Security-Policy.",
            "fix": "Configure the web server to return appropriate security headers."
        })

    return vulnerabilities
