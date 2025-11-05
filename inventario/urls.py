from django import views
from django.urls import path
from inventario.views import inicio_views, login_views, venta_views
from inventario.views import inventario_views
from inventario.views.inventario_views import panel_inventario


urlpatterns = [

    # Pagina inicial
    path('', inicio_views.inicio, name='inicio'),


    # Login y logut
    path('login', login_views.login, name='login'),
    path('logout', login_views.logout, name='logout'),
    

    # Detalles Inventario

    path('inicio/inventario' , inventario_views.panel_inventario,name='inventario'),

    path('inicio/inventario/actualizar/<int:id_detalle_inventario>', inventario_views.actualizar_producto_inventario, name='actualizar_producto_inventario'),
    
    path('inicio/inventario/eliminar/<int:id_detalle_inventario>', inventario_views.eliminar_producto_inventario,name='eliminar_producto_inventario'),


    # Ingreso

    path('inicio/inventario/ingreso', inventario_views.panel_ingreso_inventario, name='ingreso_inventario'),

    path('inicio/inventario/ingreso/nuevoIngreso', inventario_views.ingreso_inventario, name='agregar_inventario'),

    path('inicio/inventario/ingreso/actualizar/<int:id_ingreso_inventario>', inventario_views.actualizar_ingreso_inventario , name='actualizar_ingreso_inventario'),

    path('inicio/inventario/ingreso/eliminar/<int:id_ingreso_inventario>', inventario_views.eliminar_ingreso_inventario, name='eliminar_ingreso_inventario'),


    # Detalles ingreso

    path('inicio/inventario/ingreso/detalle/<int:id_ingreso_inventario>', inventario_views.panel_detalle_ingreso, name='detalle_ingreso'),

    path('inicio/inventario/ingreso/detalle/<int:id_ingreso_inventario>/agregar',
    inventario_views.agregar_detalle_ingreso,
    name='agregar_detalle_ingreso'),

    path('inicio/inventario/ingreso/detalle/actualizar/<int:id_detalle_ingreso>', inventario_views.actualizar_detalle_ingreso, name='actualizar_detalle_ingreso'),

    path('inicio/inventario/ingreso/detalle/eliminar/<int:id_detalle_ingreso>/<int:id_ingreso_inventario>', inventario_views.eliminar_detalle_ingreso, name='eliminar_detalle_ingreso'),

    

    # Traslado

    path('inicio/inventario/traslado', inventario_views.panel_traslado_inventario, name='traslado_inventario'),

    path('inicio/inventario/traslado/agregar', inventario_views.agregar_traslado_inventario, name='agregar_traslado_inventario'),

    path('inicio/inventario/traslado/eliminar/<int:id_traslado_inventario>', inventario_views.eliminar_traslado_inventario, name='eliminar_traslado_inventario'),



    # Detalles traslado 
    

    path('inicio/inventario/traslado/detalle/<int:id_traslado_inventario>', inventario_views.panel_detalle_traslado,name='detalle_traslado'),
    
    path('inicio/inventario/traslado/detalle/<int:id_traslado_inventario>/agregar',
    inventario_views.agregar_detalle_traslado,
    name='agregar_detalle_traslado'),

    path('inicio/inventario/traslado/detalle/actualizar/<int:id_detalle_traslado>', inventario_views.actualizar_detalle_traslado, name='actualizar_detalle_traslado'),


    path('inicio/inventario/traslado/detalle/eliminar/<int:id_detalle_traslado>/<int:id_traslado_inventario>', inventario_views.eliminar_detalle_traslado, name='eliminar_detalle_traslado'),




    # VENTA
     path('inicio/venta' , venta_views.panel_venta,name='venta'),


     path('inicio/venta/agregar',
    venta_views.agregar_venta,
    name='agregar_venta'),



     path('inicio/venta/eliminar/<int:id_venta>', venta_views.eliminar_venta, name='eliminar_venta'),

     


     # Detalle venta

     path('inicio/venta/detalle/<int:id_venta>', venta_views.panel_detalle_venta,name='detalle_venta'),

     path('inicio/venta/detalle/<int:id_venta>/agregar',
     venta_views.agregar_detalle_venta,
     name='agregar_detalle_venta'),


     path('inicio/venta/detalle/actualizar/<int:id_detalle_venta>', venta_views.actualizar_detalle_venta , name='actualizar_detalle_venta'),



     path('inicio/venta/detalle/eliminar/<int:id_detalle_venta>/<int:id_venta>', venta_views.eliminar_detalle_venta, name='eliminar_detalle_ingreso')
    


    
    
] 