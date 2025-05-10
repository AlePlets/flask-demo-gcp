#!/bin/bash

apt-get update
apt-get install -y python3-pip wget

wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/bin/cloud_sql_proxy
chmod +x /usr/bin/cloud_sql_proxy

mkdir -p /opt/app /cloudsql
cd /opt/app

cat <<EOF > app.py
from flask import Flask
import psycopg2
import os

app = Flask(__name__)

@app.route('/')
def index():
    try:
        conn = psycopg2.connect(
            host="/cloudsql/${INSTANCE_CONNECTION_NAME}",
            dbname="${DB_NAME}",
            user="${DB_USER}",
            password="${DB_PASSWORD}"
        )
        cur = conn.cursor()
        cur.execute('SELECT NOW();')
        now = cur.fetchone()[0]
        cur.close()
        conn.close()
        return f"Hello, DB time is {now}"
    except Exception as e:
        return f"Error: {e}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

cat <<EOF > requirements.txt
Flask==2.3.2
psycopg2-binary==2.9.9
EOF

pip3 install -r requirements.txt

cloud_sql_proxy -dir=/cloudsql -instances=${INSTANCE_CONNECTION_NAME} &

echo "export INSTANCE_CONNECTION_NAME='${INSTANCE_CONNECTION_NAME}'" >> /etc/profile
echo "export DB_NAME='${DB_NAME}'" >> /etc/profile
echo "export DB_USER='${DB_USER}'" >> /etc/profile
echo "export DB_PASSWORD='${DB_PASSWORD}'" >> /etc/profile

python3 app.py &
