from django.contrib import messages
from django.db import connection
from django.shortcuts import redirect, render
from django.http import HttpResponse




def hello(request):
    return HttpResponse ("<h1>Hola mundo<h1>")

def about(request):
    return HttpResponse("About") 

def nombre (request, nombre):
    return HttpResponse(nombre)

def animal (request, animal):
    return HttpResponse("<h1>Animal %s<h1>" % animal)


def base (request):
    return render(request,'login/base.html')

def lista_productos(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM producto;")
        productos = cursor.fetchall() 
    return render(request, 'login/lista_inventario.html', {'productos': productos})


def login (request):
    if request.method == 'POST':
        num_documento = request.POST.get('num_documento')
        clave = request.POST.get('clave')

        with connection.cursor() as cursor:
            cursor.callproc("sp_login",[num_documento,clave])
            credencial = cursor.fetchall()
            
            if credencial[0][0]  is not None:
                id_usuario,nombre,rol = credencial[0]
                request.session['id_usuario']=id_usuario
                request.session['nombre']=nombre
                request.session['rol']=rol
                return redirect ('inicio')
            else:
                messages.error(request,'Credencial no valida.')

    return render(request,'login/login.html')


def logout (request):
    request.session.flush()
    return redirect('login')
    