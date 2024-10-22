import os
import http.server
import socketserver

PORT = 3000

DIRECTORY = "public"

class Handler(http.server.SimpleHTTPRequestHandler):
    def translate_path(self, path):
        # Always serve from the specified directory
        return os.path.join(DIRECTORY, path[1:])

# Create the server object
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at port {PORT}")
    httpd.serve_forever()
