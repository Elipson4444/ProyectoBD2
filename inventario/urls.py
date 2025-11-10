from django import views
from django.urls import path
from inventario.views import inicio_views, login_views
from inventario.views import inventario_views
from inventario.views.inventario_views import panel_inventario
from inventario.views import personal_views
from .views import auditoria_views

urlpatterns = [
    # ✅ RUTA DE AUDITORÍA ARREGLADA
    path('historial/', auditoria_views.historial_auditoria, name='historial_auditoria'),

    path('', inicio_views.inicio, name='inicio'),
    path('login', login_views.login, name='login'),
    path('logout', login_views.logout, name='logout'),

    path('inicio/inventario' , inventario_views.panel_inventario, name='inventario'),

    path('inicio/inventario/actualizar/<int:id_detalle_inventario>', inventario_views.actualizar_producto_inventario, name='actualizar_producto_inventario'),
    path('inicio/inventario/eliminar/<int:id_detalle_inventario>', inventario_views.eliminar_producto_inventario, name='eliminar_producto_inventario'),

    path('inicio/inventario/engreso', inventario_views.panel_ingreso_inventario, name='ingreso_inventario'),
    path('inicio/inventario/ingreso/nuevoIngreso', inventario_views.ingreso_inventario, name='agregar_inventario'),

    path('inicio/inventario/ingreso/actualizar/<int:id_ingreso_inventario>', inventario_views.actualizar_ingreso_inventario , name='actualizar_ingreso_inventario'),
    path('inicio/inventario/ingreso/eliminar/<int:id_ingreso_inventario>', inventario_views.eliminar_ingreso_inventario, name='eliminar_ingreso_inventario'),

    path('inicio/inventario/ingreso/detalle/<int:id_ingreso_inventario>', inventario_views.panel_detalle_ingreso, name='detalle_ingreso'),

    path('inicio/inventario/ingreso/detalle/<int:id_ingreso_inventario>/agregar',
        inventario_views.agregar_detalle_ingreso,
        name='agregar_detalle_ingreso'),

    path('inicio/inventario/ingreso/detalle/actualizar/<int:id_detalle_ingreso>', inventario_views.actualizar_detalle_ingreso, name='actualizar_detalle_ingreso'),

    path('inicio/inventario/ingreso/detalle/eliminar/<int:id_detalle_ingreso>/<int:id_ingreso_inventario>', inventario_views.eliminar_detalle_ingreso, name='eliminar_detalle_ingreso'),


    # --- TRASLADOS ---
    path('inicio/inventario/traslado', inventario_views.panel_traslado_inventario, name='traslado_inventario'),
    path('inicio/inventario/traslado/agregar', inventario_views.agregar_traslado_inventario, name='agregar_traslado_inventario'),
    path('inicio/inventario/traslado/eliminar/<int:id_traslado_inventario>', inventario_views.eliminar_traslado_inventario, name='eliminar_traslado_inventario'),

    # --- PERSONAL ---
    path('personal/', personal_views.panel_personal, name='personal'),
    path('personal/registrar', personal_views.registrar_personal, name='registrar_personal'),
    path('personal/editar/<int:id_usuario>', personal_views.editar_personal, name='editar_personal'),
    path('personal/eliminar/<int:id_usuario>', personal_views.eliminar_personal, name='eliminar_personal'),
]
