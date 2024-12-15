import socket

private_ip = socket.gethostbyname(socket.gethostname())

with open("/data/ip_log.txt", "w") as file:
    file.write(private_ip)

