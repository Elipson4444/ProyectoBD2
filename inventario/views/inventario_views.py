from django.db import connection
from django.shortcuts import redirect, render

import inventario

def panel_inventario(request):

    with connection.cursor() as cursor:
        cursor.callproc('sp_inventario_tienda',[1])
        productos = cursor.fetchall()

    print(productos)    
    return render(request,'panel_inventario.html',{'productos':productos})