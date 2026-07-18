import json
import os
import socket
from datetime import datetime, timezone

DATA_DIR = "/data"


def private_ip():
    ip = os.environ.get("POD_IP")
    if ip:
        return ip
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("10.255.255.255", 1))
        return s.getsockname()[0]
    finally:
        s.close()


def main():
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H-%M-%SZ")
    ip = private_ip()

    final_path = os.path.join(DATA_DIR, f"{ts}.txt")
    tmp_path = f"{final_path}.tmp"
    with open(tmp_path, "w") as f:
        f.write(f"IP privada: {ip}\n")
        f.write(f"Timestamp de ejecución: {ts}\n")
    # rename atómico: el sidecar solo ve archivos .txt completos
    os.replace(tmp_path, final_path)

    print(f"Timestamp de ejecución: {ts}", flush=True)
    print(
        json.dumps(
            {
                "level": "info",
                "event": "file_created",
                "file": final_path,
                "private_ip": ip,
                "timestamp": ts,
            }
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
