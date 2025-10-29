from django.urls import path
from . import views
urlpatterns = [
    path('', views.hello),
    path('about/',views.about),
    path('nombre/<str:nombre>',views.nombre),
    path('animal/<str:animal>',views.animal),
    path('producto/',views.lista_productos)
] 