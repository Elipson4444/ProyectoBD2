from django.contrib import messages
from django.db import connection
from django.shortcuts import redirect, render
import hashlib

def login(request):
    if request.method == 'POST':
        num_documento = request.POST.get('num_documento')
        clave = request.POST.get('clave')

        hash_clave = hashlib.blake2b(clave.encode(), digest_size=20).hexdigest()

        with connection.cursor() as cursor:
            cursor.callproc("sp_login", [num_documento, hash_clave])
            credencial = cursor.fetchall()
            
            # SE AGREGA ESTA VALIDACIÓN
            if not credencial or credencial[0][0] is None:
                messages.error(request, 'Credenciales inválidas.')
                return render(request, 'login.html')

            id_usuario, id_tienda, nombre, rol = credencial[0]

            # GUARDAMOS SESIÓN CORRECTAMENTE
            request.session['id_usuario'] = id_usuario
            request.session['id_tienda'] = id_tienda
            request.session['nombre'] = nombre
            request.session['rol'] = rol

            return redirect('inicio')

    return render(request, 'login.html')


def logout(request):
    request.session.flush()
    return redirect('login')
