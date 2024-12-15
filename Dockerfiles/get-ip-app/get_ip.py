import socket
import time

private_ip = socket.gethostbyname(socket.gethostname())

print(f'Private IP: {private_ip}')

with open("/data/ip_log.txt", "w") as file:
    file.write(private_ip)

