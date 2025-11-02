from django.shortcuts import redirect, render

def inicio(request):
    id_usuario = request.session.get('id_usuario') 
    if not id_usuario:
        return redirect('login')
    nombre = request.session.get('nombre')
    rol = request.session.get('rol') 

    

    info_usuario ={ 
     'id_usuario': id_usuario,
       'nombre' : nombre, 
        'rol' :rol 
    }

    return render(request,'inicio.html',info_usuario)


