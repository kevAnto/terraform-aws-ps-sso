#!/bin/bash
sudo -i 
#!/bin/bash
# Simple Hello World web server script for Amazon Linux 1
# Uses Python's built-in HTTP server on port 8000

# Create directory for web content
mkdir -p /var/www/hello

# Create a simple HTML file
cat > /var/www/hello/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
            background-color: #f5f5f5;
        }
        h1 {
            color: #333;
            font-size: 48px;
        }
        .container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 400px;
            margin: 0 auto;
            padding: 40px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello World</h1>
        <p>Running on port 8000</p>
    </div>
</body>
</html>
EOF

# Install Python if not already installed
yum install -y python

# Create startup script
cat > /etc/init.d/helloworld << 'EOF'
#!/bin/bash
# chkconfig: 2345 95 20
# description: Hello World Python Web Server

PIDFILE="/var/run/helloworld.pid"
LOGFILE="/var/log/helloworld.log"
WEBDIR="/var/www/hello"

start() {
    echo "Starting Hello World Web Server on port 8000"
    cd $WEBDIR
    nohup python -m SimpleHTTPServer 8000 > $LOGFILE 2>&1 &
    echo $! > $PIDFILE
}

stop() {
    echo "Stopping Hello World Web Server"
    if [ -f $PIDFILE ]; then
        PID=$(cat $PIDFILE)
        kill $PID
        rm -f $PIDFILE
    else
        echo "Server not running"
    fi
}

status() {
    if [ -f $PIDFILE ]; then
        PID=$(cat $PIDFILE)
        if ps -p $PID > /dev/null; then
            echo "Server is running (PID: $PID)"
        else
            echo "Server is not running (stale PID file)"
            rm -f $PIDFILE
        fi
    else
        echo "Server is not running"
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
EOF

# Make the script executable
chmod +x /etc/init.d/helloworld

# Configure it to start on boot
chkconfig --add helloworld
chkconfig helloworld on

# Start the server
service helloworld start

# Show IP and port
INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Hello World server is running on port 8000"
echo "Access it at http://${INSTANCE_IP}:8000"

# Check status
service helloworld status
