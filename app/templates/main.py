
from flask import Flask, render_template, request, redirect, session, flash
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.secret_key = 'supersecretkey'

def get_db_connection():
    return psycopg2.connect(
        host="/cloudsql/{}".format(os.environ['INSTANCE_CONNECTION_NAME']),
        dbname=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD']
    )

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        full_name = request.form['full_name']
        cpf = request.form['cpf']
        email = request.form['email']
        password = request.form['password']
        address = request.form['address']
        city = request.form['city']
        neighborhood = request.form['neighborhood']
        phone = request.form['phone']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            INSERT INTO users (full_name, cpf, email, password, address, city, neighborhood, phone)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        ''', (full_name, cpf, email, password, address, city, neighborhood, phone))
        conn.commit()
        cur.close()
        conn.close()
        flash('Usuário cadastrado com sucesso!')
        return redirect('/login')
    return render_template('register.html')
