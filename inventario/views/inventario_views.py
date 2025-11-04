from django.db import connection
from django.shortcuts import redirect, render



def panel_inventario(request):
    if 'id_usuario' not in request.session:
        return redirect('login')

    with connection.cursor() as cursor1:
        cursor1.callproc('sp_mostrarProductosInventario',[request.session.get('id_tienda')])
        productos = cursor1.fetchall()
        
    with connection.cursor() as cursor2:
        cursor2.callproc('sp_mostrarInfoInventario',[request.session.get('id_tienda')])
        inventario_info = cursor2.fetchone()


    return render(request,'panel_inventario.html',{'productos':productos,'inventario_info':inventario_info,'rol':request.session.get('rol')})


def panel_ingreso_inventario(request):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    id_tienda = request.session.get('id_tienda')

    with connection.cursor() as cursor :
        cursor.callproc('sp_mostrarIngresosInventario',[id_tienda])
        detalles_ingresos = cursor.fetchall()

    return render(request,'panel_ingreso_inventario.html',{'detalles_ingresos':detalles_ingresos})


def ingreso_inventario(request):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    if request.method =='POST':

        motivo = request.POST.get('motivo')
        id_tienda = request.session.get('id_tienda')
        id_usuario = request.session.get('id_usuario')

        with connection.cursor() as cursor:

            cursor.callproc('sp_ingresoInventario',[id_tienda,id_usuario,motivo])
            connection.commit()

    return redirect('ingreso_inventario')
    

def panel_detalle_ingreso(request,id_ingreso_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    with connection.cursor() as cursor:
        cursor.callproc('sp_mostrarDetallesIngreso',[id_ingreso_inventario])
        detalles = cursor.fetchall()
    

    return render(request,'panel_detalle_inventario.html',{'detalles':detalles})




def actualizar_producto_inventario(request,id_detalle_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    if request.method == 'POST':
        cantidad = request.POST.get('cantidad')
        stock_minimo =request.POST.get('stock_minimo')
        stock_maximo = request.POST.get('stock_maximo')

        with connection.cursor() as cursor:
            cursor.callproc('sp_actualizarDetallesInventario',[id_detalle_inventario,cantidad,stock_minimo,stock_maximo])
            connection.commit()

            return redirect('inventario')

def eliminar_producto_inventario(request,id_detalle_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    with connection.cursor() as cursor:
        cursor.callproc('sp_eliminarDetalleInventario',[id_detalle_inventario])
        connection.commit()
    return redirect('inventario')



