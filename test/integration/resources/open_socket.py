import socket
sock = socket.socket()
sock.connect(('www.google.com', 80))
print('consegui conectar no google')