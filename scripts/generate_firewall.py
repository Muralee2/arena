#!/usr/bin/env python3
import sys
import json
import subprocess
import os

# Fixed cluster info
CLUSTER_NAME = "og-cluster"
REGION = "us-central1"
PROJECT_ID = "ilver-tape-467818-r9"
CACHE_FILE = "/tmp/master_cidr_cache.json"  # cache location

def fetch_master_cidr():
    """
    Fetch master IPv4 CIDR from GKE using gcloud command.
    """
    cmd = [
        "gcloud", "container", "clusters", "describe", CLUSTER_NAME,
        "--region", REGION,
        "--project", PROJECT_ID,
        "--format=value(privateClusterConfig.masterIpv4CidrBlock)"
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    return result.stdout.strip()

def get_master_cidr(force_refresh=False):
    """
    Get master CIDR, using cache if available unless force_refresh is True.
    """
    if not force_refresh and os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, "r") as f:
                cached_data = json.load(f)
                return cached_data.get("master_cidr")
        except Exception:
            pass

    master_cidr = fetch_master_cidr()
    with open(CACHE_FILE, "w") as f:
        json.dump({"master_cidr": master_cidr}, f)
    return master_cidr

def main():
    try:
        req = json.load(sys.stdin)
    except Exception:
        req = {}

    network = req.get("network", "")
    force_refresh = req.get("force_refresh", "false").lower() == "true"

    master_cidr = get_master_cidr(force_refresh=force_refresh)

    rules = {
        "egress_to_gke_master": {
            "name": f"{CLUSTER_NAME}-egress-master",
            "direction": "EGRESS",
            "priority": 1000,
            "network": network,
            "destination_ranges": [master_cidr],
            "allowed": [
                {"IPProtocol": "tcp"},
                {"IPProtocol": "udp"}
            ]
        },
        "node_to_pod_all": {
            "name": f"{CLUSTER_NAME}-node-pod-all",
            "direction": "INGRESS",
            "priority": 1000,
            "network": network,
            "source_ranges": ["10.0.0.0/8"],  # adjust for your pod CIDR
            "allowed": [
                {"IPProtocol": "all"}
            ]
        }
    }

    print(json.dumps(rules))

if __name__ == "__main__":
    main()
