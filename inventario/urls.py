from django.urls import path
from inventario.views import inicio_views, login_views
from inventario.views import inventario_views
from inventario.views.inventario_views import panel_inventario

from . import views
urlpatterns = [
    path('', inicio_views.inicio, name='inicio'),
    path('login', login_views.login, name='login'),
    path('logout', login_views.logout, name='logout'),
    path('inicio/inventario' , inventario_views.panel_inventario,name='inventario')
] 