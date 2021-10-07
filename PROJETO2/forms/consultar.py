from flask_wtf import FlaskForm
from wtforms import SubmitField, StringField, DateField, HiddenField, validators

class consultarForm(FlaskForm):
    idEmprestimo = StringField('Digite o id do empréstimo',[validators.DataRequired()])
    btnAtualizar = SubmitField('Confirmar')