from django import views
from django.urls import path
from inventario.views import inicio_views, login_views
from inventario.views import inventario_views
from inventario.views.inventario_views import panel_inventario


urlpatterns = [
    path('', inicio_views.inicio, name='inicio'),
    path('login', login_views.login, name='login'),
    path('logout', login_views.logout, name='logout'),
    path('inicio/inventario' , inventario_views.panel_inventario,name='inventario'),

    path('inicio/inventario/actualizar/<int:id_detalle_inventario>', inventario_views.actualizar_producto_inventario, name='actualizar_producto_inventario'),
    
    path('inicio/inventario/eliminar/<int:id_detalle_inventario>', inventario_views.eliminar_producto_inventario,name='eliminar_producto_inventario'),

    path('inicio/inventario/ingreso', inventario_views.panel_ingreso_inventario, name='ingreso_inventario'),

    path('inicio/inventario/ingreso/nuevoIngreso', inventario_views.ingreso_inventario, name='agregar_inventario'),

    path('inicio/inventario/ingreso/detalle/<int:id_ingreso_inventario>', inventario_views.panel_detalle_ingreso, name='detalle_ingreso')
    
] 