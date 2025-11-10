from django.shortcuts import render
from inventario.models_mongo import EventoSistema

def historial_auditoria(request):
    # Trae los últimos 50 eventos (para no cargar tanto)
    eventos = EventoSistema.objects.all().order_by('-fecha')[:50]

    return render(request, 'historial_auditoria.html', {'eventos': eventos})
