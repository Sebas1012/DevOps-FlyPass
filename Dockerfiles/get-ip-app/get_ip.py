import socket
import requests
import time

def obtener_ip_privada():
    try:
        hostname = socket.gethostname()
        ip_privada = socket.gethostbyname(hostname)
        return ip_privada
    except Exception as e:
        return f"Error obteniendo IP privada: {e}"

def obtener_ipv6():
    try:
        direcciones = socket.getaddrinfo(socket.gethostname(), None, socket.AF_INET6)
        if direcciones:
            return direcciones[0][4][0]
        else:
            return "No disponible"
    except Exception as e:
        return f"Error obteniendo IPv6: {e}"

def obtener_ip_publica():
    try:
        response = requests.get("https://api.ipify.org?format=text", timeout=5)
        if response.status_code == 200:
            return response.text
        else:
            return "Error al obtener IP pública"
    except Exception as e:
        return f"Error obteniendo IP pública: {e}"

def guardar_ips_en_archivo(archivo, ip_privada, ipv6, ip_publica):
    try:
        with open(archivo, "w") as file:
            file.write(f"IP Privada: {ip_privada}, IPV6: {ipv6}, IP Pública: {ip_publica}\n")
    except Exception as e:
        print(f"Error al guardar las IPs en el archivo: {e}")

def main():
    archivo = "/data/ip_log.txt"
    while True:
        ip_privada = obtener_ip_privada()
        ipv6 = obtener_ipv6()
        ip_publica = obtener_ip_publica()

        print(f"IP Privada: {ip_privada}, IPV6: {ipv6}, IP Publica: {ip_publica}")
        guardar_ips_en_archivo(archivo, ip_privada, ipv6, ip_publica)

        time.sleep(60)

if __name__ == "__main__":
    main()


