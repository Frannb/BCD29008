from flask_wtf import FlaskForm
from wtforms import SubmitField, StringField, DateField, HiddenField, validators

class EmprestimoForm(FlaskForm):
    idEmprestimo = HiddenField('idEmprestimo')
    matricula = StringField('Matrícula',[validators.DataRequired()])
    patrimonio = StringField('Patrimônio',[validators.DataRequired()])
    atividade = StringField('Atividade',[validators.DataRequired()])
    btnAtualizar = SubmitField('Confirmar')
