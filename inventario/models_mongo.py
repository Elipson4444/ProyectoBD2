from mongoengine import Document, StringField, DateTimeField, DictField
from datetime import datetime

class EventoSistema(Document):
    usuario = StringField(required=True)
    accion = StringField(required=True)
    descripcion = StringField()
    datos = DictField()
    ip = StringField()
    fecha = DateTimeField(default=datetime.utcnow)
