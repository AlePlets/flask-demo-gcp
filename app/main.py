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
            INSERT INTO clientes (full_name, cpf, email, password, address, city, neighborhood, phone)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        ''', (full_name, cpf, email, password, address, city, neighborhood, phone))
        conn.commit()
        cur.close()
        conn.close()
        flash('Usuário cadastrado com sucesso!')
        return redirect('/login')
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT * FROM clientes WHERE email = %s AND password = %s', (email, password))
        user = cur.fetchone()
        cur.close()
        conn.close()
        if user:
            session['user'] = user[1]  # full_name
            return redirect('/dashboard')
        else:
            flash('Login inválido')
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'user' not in session:
        return redirect('/login')
    return render_template('dashboard.html', user=session['user'])

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect('/')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7070)
