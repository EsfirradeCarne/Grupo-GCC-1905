from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = 'sua-chave-secreta-aqui'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Modelo da Tarefa
class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    titulo = db.Column(db.String(100), nullable=False)
    descricao = db.Column(db.Text, nullable=True)
    prioridade = db.Column(db.String(20), nullable=False, default='Média')
    status = db.Column(db.String(20), nullable=False, default='Pendente')
    data_criacao = db.Column(db.DateTime, default=datetime.utcnow)
    data_atualizacao = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f'<Task {self.titulo}>'

    def to_dict(self):
        return {
            'id': self.id,
            'titulo': self.titulo,
            'descricao': self.descricao,
            'prioridade': self.prioridade,
            'status': self.status,
            'data_criacao': self.data_criacao.isoformat() if self.data_criacao else None,
            'data_atualizacao': self.data_atualizacao.isoformat() if self.data_atualizacao else None
        }

# Criar tabelas
with app.app_context():
    db.create_all()

def get_priority_order(prioridade):
    """Retorna número para ordenação por prioridade"""
    priority_map = {'Alta': 1, 'Média': 2, 'Baixa': 3}
    return priority_map.get(prioridade, 2)

@app.route('/')
def index():
    # Filtros
    status_filter = request.args.get('status', '')
    priority_filter = request.args.get('priority', '')
    
    # Query base
    query = Task.query
    
    # Aplicar filtros
    if status_filter:
        query = query.filter(Task.status == status_filter)
    if priority_filter:
        query = query.filter(Task.prioridade == priority_filter)
    
    # Buscar todas as tarefas e ordenar por prioridade
    tasks = query.all()
    tasks = sorted(tasks, key=lambda x: get_priority_order(x.prioridade))
    
    return render_template('index.html', tasks=tasks, 
                         current_status=status_filter, 
                         current_priority=priority_filter)

@app.route('/add', methods=['GET', 'POST'])
def add_task():
    if request.method == 'POST':
        titulo = request.form['titulo']
        descricao = request.form['descricao']
        prioridade = request.form['prioridade']
        status = request.form['status']
        
        if not titulo:
            flash('Título é obrigatório!', 'error')
            return render_template('add_task.html')
        
        new_task = Task(
            titulo=titulo,
            descricao=descricao,
            prioridade=prioridade,
            status=status
        )
        
        try:
            db.session.add(new_task)
            db.session.commit()
            flash('Tarefa criada com sucesso!', 'success')
            return redirect(url_for('index'))
        except Exception as e:
            db.session.rollback()
            flash('Erro ao criar tarefa!', 'error')
            return render_template('add_task.html')
    
    return render_template('add_task.html')

@app.route('/edit/<int:id>', methods=['GET', 'POST'])
def edit_task(id):
    task = Task.query.get_or_404(id)
    
    if request.method == 'POST':
        titulo = request.form['titulo']
        descricao = request.form['descricao']
        prioridade = request.form['prioridade']
        status = request.form['status']
        
        if not titulo:
            flash('Título é obrigatório!', 'error')
            return render_template('edit_task.html', task=task)
        
        task.titulo = titulo
        task.descricao = descricao
        task.prioridade = prioridade
        task.status = status
        task.data_atualizacao = datetime.utcnow()
        
        try:
            db.session.commit()
            flash('Tarefa atualizada com sucesso!', 'success')
            return redirect(url_for('index'))
        except Exception as e:
            db.session.rollback()
            flash('Erro ao atualizar tarefa!', 'error')
    
    return render_template('edit_task.html', task=task)

@app.route('/delete/<int:id>')
def delete_task(id):
    task = Task.query.get_or_404(id)
    
    try:
        db.session.delete(task)
        db.session.commit()
        flash('Tarefa excluída com sucesso!', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Erro ao excluir tarefa!', 'error')
    
    return redirect(url_for('index'))

@app.route('/complete/<int:id>')
def complete_task(id):
    task = Task.query.get_or_404(id)
    task.status = 'Concluída'
    task.data_atualizacao = datetime.utcnow()
    
    try:
        db.session.commit()
        flash('Tarefa marcada como concluída!', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Erro ao marcar tarefa como concluída!', 'error')
    
    return redirect(url_for('index'))

# API Routes para testes
@app.route('/api/tasks', methods=['GET'])
def api_get_tasks():
    tasks = Task.query.all()
    return jsonify([task.to_dict() for task in tasks])

@app.route('/api/tasks', methods=['POST'])
def api_create_task():
    data = request.get_json()
    
    if not data.get('titulo'):
        return jsonify({'error': 'Título é obrigatório'}), 400
    
    new_task = Task(
        titulo=data['titulo'],
        descricao=data.get('descricao', ''),
        prioridade=data.get('prioridade', 'Média'),
        status=data.get('status', 'Pendente')
    )
    
    try:
        db.session.add(new_task)
        db.session.commit()
        return jsonify(new_task.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Erro ao criar tarefa'}), 500

@app.route('/api/tasks/<int:id>', methods=['GET'])
def api_get_task(id):
    task = Task.query.get_or_404(id)
    return jsonify(task.to_dict())

@app.route('/api/tasks/<int:id>', methods=['PUT'])
def api_update_task(id):
    task = Task.query.get_or_404(id)
    data = request.get_json()
    
    if 'titulo' in data:
        task.titulo = data['titulo']
    if 'descricao' in data:
        task.descricao = data['descricao']
    if 'prioridade' in data:
        task.prioridade = data['prioridade']
    if 'status' in data:
        task.status = data['status']
    
    task.data_atualizacao = datetime.utcnow()
    
    try:
        db.session.commit()
        return jsonify(task.to_dict())
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Erro ao atualizar tarefa'}), 500

@app.route('/api/tasks/<int:id>', methods=['DELETE'])
def api_delete_task(id):
    task = Task.query.get_or_404(id)
    
    try:
        db.session.delete(task)
        db.session.commit()
        return jsonify({'message': 'Tarefa excluída com sucesso'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Erro ao excluir tarefa'}), 500

if __name__ == '__main__':
    import os
    port = int(os.environ.get('PORT', 5001))
    app.run(debug=True, port=port, host='0.0.0.0')
