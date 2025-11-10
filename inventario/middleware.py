from django.utils.deprecation import MiddlewareMixin
from .models_mongo import EventoSistema

class AuditoriaMiddleware(MiddlewareMixin):

    def process_view(self, request, view_func, view_args, view_kwargs):
        # Ignorar admin
        if request.path.startswith('/admin/'):
            return None

        # Obtener usuario desde tu SESIÓN personalizada:
        usuario = request.session.get('nombre', 'anonimo')

        # Obtener IP
        ip = request.META.get('REMOTE_ADDR')

        # Registrar evento
        EventoSistema(
            usuario=usuario,
            accion=view_func.__name__,
            descripcion=f"Vista ejecutada: {view_func.__name__}",
            ip=ip
        ).save()

        return None
