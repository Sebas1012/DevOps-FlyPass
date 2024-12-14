import socket
import time

private_ip = socket.gethostbyname(socket.gethostname())

print(f'Private IP: {private_ip}')

timestamp = str(int(time.time()))

print(f'Writing IP to file: {timestamp}.txt')

with open(f"./{timestamp}.txt", "w") as file:
    file.write(private_ip)

