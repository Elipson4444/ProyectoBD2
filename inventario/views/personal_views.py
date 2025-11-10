from django.shortcuts import render, redirect
from django.db import connection
from django.contrib import messages
import hashlib


def panel_personal(request):
    if 'id_usuario' not in request.session:
        return redirect('login')

    with connection.cursor() as cursor:
        cursor.callproc("sp_consultarPersonal")
        personal_data = cursor.fetchall()

    personal = [
        {
            "id_usuario": p[0],
            "nombre": p[1],
            "num_documento": p[2],
            "rol": p[3],
            "id_tienda": p[4],
            "nombre_tienda": p[5],
        }
        for p in personal_data
    ]

    rol = request.session.get("rol", "").lower()


    return render(request, "personal.html", {"personal": personal, "rol": rol})


def registrar_personal(request):
    if request.method == "POST":
        id_tienda = request.session.get("id_tienda")
        nombre = request.POST.get("nombre")
        num_documento = request.POST.get("num_documento")
        rol = request.POST.get("rol")
        clave = request.POST.get("clave")

        hash_clave = hashlib.blake2b(clave.encode(), digest_size=20).hexdigest()

        with connection.cursor() as cursor:
            cursor.callproc("sp_registrarPersonal", [id_tienda, nombre, num_documento, rol, hash_clave])

        messages.success(request, "Personal registrado correctamente.")
        return redirect("personal")

    return redirect("personal")


def editar_personal(request, id_usuario):
    if request.method == "POST":
        id_tienda = request.session.get("id_tienda")
        nombre = request.POST.get("nombre")
        num_documento = request.POST.get("num_documento")
        rol = request.POST.get("rol")

        with connection.cursor() as cursor:
            cursor.callproc("sp_actualizarPersonal", [id_usuario, id_tienda, nombre, num_documento, rol])

        messages.success(request, "Personal actualizado correctamente.")
        return redirect("personal")

    return redirect("personal")


def eliminar_personal(request, id_usuario):
    with connection.cursor() as cursor:
        cursor.callproc("sp_eliminarPersonal", [id_usuario])

    messages.success(request, "Personal eliminado.")
    return redirect("personal")

