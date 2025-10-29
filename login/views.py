from django.db import connection
from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
def hello(request):
    return HttpResponse ("<h1>Hola mundo<h1>")

def about(request):
    return HttpResponse("About") 

def nombre (request, nombre):
    return HttpResponse(nombre)

def animal (request, animal):
    return HttpResponse("<h1>Animal %s<h1>" % animal)


def lista_productos(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM producto;")
        productos = cursor.fetchall() 
    return render(request, 'login/lista_inventario.html', {'productos': productos})


