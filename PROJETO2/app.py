'''
TODO:
    -> No RENOVAR, Verificar prazo quando for renovar, se passou do prazo não renovar, limite de 3 renovações
    -> No LISTAR_EMPRESTIMO, tem aluno com mais de um empréstimo.
    ->


'''

from flask import Flask, flash, redirect, url_for, request, session, render_template, jsonify
from flask_bootstrap import Bootstrap
from flask_nav import Nav
from flask_nav.elements import Navbar, View, Subgroup
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy import create_engine, MetaData, Table, Column, ForeignKey
from datetime import datetime, timedelta, date

# https://fontawesome.com/icons
from flask_fontawesome import FontAwesome

# Salvando senhas de maneira apropriada no banco de dados.
# https://werkzeug.palletsprojects.com/en/1.0.x/utils/#module-werkzeug.security
# Para gerar a senha a ser salva no DB, faça:
# senha = generate_password_hash('1234')
from werkzeug.security import generate_password_hash, check_password_hash

from forms.login import LoginForm
from forms.emprestimo import EmprestimoForm
from forms.consultar import consultarForm

app = Flask(__name__)
app.secret_key = "SECRET_KEY"

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://francin:(Fran1234)@localhost:3306/projeto2bcd'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

Base = automap_base()
Base.prepare(db.engine, reflect=True)

Usuario = Base.classes.Usuario
Aluno = Base.classes.Aluno
Emprestimo = Base.classes.Emprestimo
Equipamento = Base.classes.Equipamento
Calendario = Base.classes.CalendarioAcademico
Funcionario = Base.classes.Funcionario

boostrap = Bootstrap(app)
fa = FontAwesome(app)

nav = Nav()
nav.init_app(app)


@nav.navigation()
def meunavbar():
    global menu
    id_usuario = session.get('idUsuario')
    tipo_usuario = db.session.query(Usuario).filter(Usuario.idUsuario == id_usuario).first()

    if tipo_usuario.tipo == 0:
        menu = Navbar('Sistema de empréstimo')
        menu.items = [View('Inicial', 'inicio'), ]
        menu.items.append(View('Consultar empréstimos', 'consultar_emprestimo_aluno'))
        menu.items.append(View('Sair', 'logout'))
    else:
        menu = Navbar('Sistema de empréstimo')
        menu.items = [View('Inicial', 'inicio'), ]
        menu.items.append(View('Solicitar empréstimo', 'efetuar_emprestimo'))
        menu.items.append(View('Consultar empréstimos', 'consultar_emprestimo_id'))
        menu.items.append(View('Listar todos os empréstimos ativos', 'listar_emprestimos'))
        menu.items.append(View('Sair', 'logout'))
    return menu


@app.route('/login', methods=['GET', 'POST'])
def autenticar():
    if session.get('logged_in'):
        return redirect(url_for('inicio'))
    form = LoginForm()
    if form.validate_on_submit():
        usuario = db.session.query(Usuario).filter(Usuario.login == form.username.data).first()
        if usuario:
            if check_password_hash(usuario.senha, form.password.data):
                session['logged_in'] = True
                session['login'] = usuario.login
                session['idUsuario'] = usuario.idUsuario
                return redirect(url_for('inicio'))
        flash('Usuário ou senha inválidos')
        return redirect(url_for('autenticar'))
    return render_template('login.html', title='Autenticação de usuários', form=form)


@app.route('/')
def inicio():
    global nome
    if not session.get('logged_in'):
        return redirect(url_for('autenticar'))
    else:
        id_usuario = session.get('idUsuario')
        tipo_usuario = db.session.query(Usuario).filter(Usuario.idUsuario == id_usuario).first()

        if tipo_usuario.tipo == 0:
            aluno = db.session.query(Aluno).filter(Aluno.idUsuario == id_usuario).first()
            nome = aluno.Nome + " " + aluno.Sobrenome
        else:
            funcionario = db.session.query(Funcionario).filter(Funcionario.idUsuario == id_usuario).first()
            nome = funcionario.Nome + " " + funcionario.Sobrenome
        return render_template('index.html', title='Inicial', usuario=nome)


@app.route("/logout")
def logout():
    '''
    Para encerrar a sessão autenticada de um usuário
    :return: redireciona para a página inicial
    '''
    session.clear()
    return redirect(url_for('inicio'))


@app.errorhandler(404)
def page_not_found(e):
    '''
    Para tratar erros de páginas não encontradas - HTTP 404
    :param e:
    :return:
    '''
    return render_template('404.html'), 404


# TODO No LISTAR_EMPRESTIMO, tem aluno com mais de um empréstimo.
@app.route('/listar_emprestimos')
def listar_emprestimos():
    if session.get('logged_in'):
        # global patrimonio, matricula
        # equipamento = db.session.query(Equipamento).filter(Equipamento.Patrimonio == 3001).first()
        #
        # # Adicionando linha Emprestimo
        # novo = Emprestimo()
        # novo.idEmprestimo = 11
        # novo.Matricula = 202010060
        # novo.idAtividade = 1
        # novo.DataEmprestimo = date(2021,8,1)
        # novo.DataPrevisaoEntrega = date (2021,8,10)
        #
        # # Adicionando linha na Emprestimo_Equipamento
        # equipamento.emprestimo_collection.append(novo)
        #
        # db.session.add(novo)
        # db.session.commit()
        #
        # teste = db.session.query(Emprestimo, Aluno)\
        #      .filter(Aluno.Matricula == Emprestimo.Matricula and Aluno.Matricula == 202010060) \
        #      .filter(Emprestimo.DataDevolucao == None).all()
        #
        # for emp in teste:
        #     for patr in emp._data[0].equipamento_collection:
        #         print(patr.Patrimonio)
        #
        # patrimonio = teste[6]._data[0].equipamento_collection[0].Patrimonio

        emprestimos_ativos = db.session.query(Emprestimo, Aluno) \
            .filter(Aluno.Matricula == Emprestimo.Matricula) \
            .filter(Emprestimo.DataDevolucao == None).all()

        # for e in emprestimos_ativos:
        #     print(e.Emprestimo.Matricula)

        # for emp in emprestimos_ativos:
        #     for patr in emp._data[0].equipamento_collection:
        #         patrimonio = patr.Patrimonio
        #         i = 1
        #         for id in patr[0].idEmprestimo:
        #             if id == id[i]:
        #                 patrimonio = patrimonio + ', ' + patr.Patrimonio

        return render_template('listar_emprestimos.html', emprestimos=emprestimos_ativos)
    return redirect(url_for('autenticar'))


@app.route('/solicitar_emprestimo', methods=['GET', 'POST'])
def efetuar_emprestimo():
    if session.get('logged_in'):
        form = EmprestimoForm()

        if form.validate_on_submit():
            matricula = request.form['matricula']
            patrimonio = request.form['patrimonio']
            atividade = request.form['atividade']

            e = db.session.query(Emprestimo).filter(Emprestimo.Matricula == matricula).all()
            if len(e) != 0:
                for emp in e:
                    if emp.DataDevolucao is None:
                        flash('Solicitação de empréstimo inválida. Aluno com empréstimo em andamento!')
            else:
                de = date.today()
                dpe = verifica_data(atividade)

                equipamento = db.session.query(Equipamento).filter(Equipamento.Patrimonio == patrimonio).first()

                # Adicionando linha Emprestimo
                novo_emp = Emprestimo()
                novo_emp.Matricula = matricula
                novo_emp.idAtividade = atividade
                novo_emp.DataEmprestimo = de
                novo_emp.DataPrevisaoEntrega = dpe
                novo_emp.QuantidadeRenovacao = 0

                # Adicionando linha na Emprestimo_Equipamento
                equipamento.emprestimo_collection.append(novo_emp)

                db.session.add(novo_emp)
                db.session.commit()
                flash('Empréstimo realizado!')

            return redirect(url_for('inicio'))
    return render_template('efetuar_emprestimo.html', title='Solicitação de empréstimo', form=form)

@app.route('/consultar_emp_aluno', methods=['GET', 'POST'])
def consultar_emprestimo_aluno():
    e = p = ''
    if session.get('logged_in'):
        id_usuario = session.get('idUsuario')

        aluno = db.session.query(Aluno).filter(Aluno.idUsuario == id_usuario).first()
        e = db.session.query(Emprestimo).filter(Emprestimo.Matricula == aluno.Matricula).first()

        for patr in e.equipamento_collection:
            p = patr.Patrimonio

    return render_template('consultar_emprestimo_aluno.html', title='Consultar empréstimo', emprestimo=e, patrimonio=p)


@app.route('/consultar_id_aluno', methods=['GET', 'POST'])
def consultar_emprestimo_id():
    global patrimonio, emprestimo
    if session.get('logged_in'):
        form = consultarForm()
        if form.validate_on_submit():
            idEmprestimo = request.form['idEmprestimo']

            emprestimo = db.session.query(Emprestimo).filter(Emprestimo.idEmprestimo == idEmprestimo).first()
            aluno = db.session.query(Aluno).filter(Aluno.Matricula == emprestimo.Matricula).first()
            for patr in emprestimo.equipamento_collection:
                patrimonio = patr.Patrimonio
            return render_template('consultar_emprestimo_id.html', title='Consultar empréstimo',
                                   emprestimo=emprestimo, patrimonio=patrimonio, aluno=aluno)
        return render_template('consultar.html', title='Consultar empréstimo', form=form)


@app.route('/finalizar', methods=['GET', 'POST'])
def finalizar_emprestimos():
    if session.get('logged_in'):
        id_emprestimo = int(request.args.get('id'))
        e = db.session.query(Emprestimo).filter(Emprestimo.idEmprestimo == id_emprestimo).first()
        if e:
            e.DataDevolucao = date.today()
            db.session.add(e)
            db.session.commit()
            flash('Empréstimo Finalizado')
        return redirect(url_for('inicio'))
    return render_template('finalizar.html', title='Finalizar empréstimo')


@app.route('/renovar', methods=['GET', 'POST'])
def renovar_emprestimos():
    global qr
    if session.get('logged_in'):
        id_emprestimo = int(request.args.get('id'))
        e = db.session.query(Emprestimo).filter(Emprestimo.idEmprestimo == id_emprestimo).first()
        data = verifica_data(e.idAtividade)

        if e.DataDevolucao is None:
            if date.today() >= e.DataPrevisaoEntrega and e.DataDevolucao is None:
                dias = abs((date.today() - e.DataPrevisaoEntrega).days)
                flash('Renovação inválida. Empréstimo está atrasado {} dias!'.format(dias))
            else:
                if e.QuantidadeRenovacao < 3:
                    qr = e.QuantidadeRenovacao + 1
                else:
                    flash('Renovação inválida. Limite máximo de renovação atingido!')
                    return redirect(url_for('inicio'))

                if e:
                    e.DataEmprestimo = date.today()
                    e.DataPrevisaoEntrega = data
                    e.QuantidadeRenovacao = qr
                    db.session.add(e)
                    db.session.commit()
                    flash('Item Renovado')
        else:
            flash('Renovação inválida. Empréstimo já finalizado!')
        return redirect(url_for('inicio'))
    return redirect(url_for('autenticar'))


# FUNCIONANDO
def dataFim():
    year = date.today().year
    calendario = db.session.query(Calendario).filter(Calendario.Ano == year).filter(Calendario.Semestre == 1).first()

    return calendario.Fim


# FUNCIONANDO
def verifica_data(atividade):
    global data_def
    de = date.today()
    dpe = de + timedelta(days=15)

    cFim = dataFim()

    if atividade == 1:
        if (de == cFim or dpe > cFim):
            data_def = cFim
        else:
            data_def = dpe
    else:
        data_def = cFim

    return data_def


if __name__ == '__main__':
    app.run(debug=True)
