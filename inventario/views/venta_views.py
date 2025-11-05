from django.db import connection
from django.shortcuts import redirect, render



# Ventas

def panel_venta(request):

    if 'id_usuario' not in request.session:
        return redirect('login')

    with connection.cursor() as cursor:
        cursor.callproc('sp_mostrarVenta',[request.session.get('id_tienda')])
        ventas = cursor.fetchall()

    return render (request,'panel_venta.html',{'ventas':ventas,'rol':request.session.get('rol')})



def agregar_venta(request):
    if 'id_usuario' not in request.session:
        return redirect('login')
    

    id_tienda = request.session.get('id_tienda')
    id_usuario = request.session.get('id_usuario')

    with connection.cursor() as cursor:

        cursor.callproc('sp_registrarVenta',[id_tienda,id_usuario])
        connection.commit()

    return redirect('venta')





def eliminar_venta(request,id_venta):
     if 'id_usuario' not in request.session:
        return redirect('login')
     
     with connection.cursor() as cursor :
         cursor.callproc('sp_eliminarVenta',[id_venta])
         return redirect('venta')
     



def eliminar_ingreso_inventario(request,id_venta):
     if 'id_usuario' not in request.session:
        return redirect('login')
     
     with connection.cursor() as cursor :
         cursor.callproc('sp_eliminarVenta',[id_venta])
         return redirect('venta')




# Detalle ventas

def panel_detalle_venta(request,id_venta):
    if 'id_usuario' not in request.session:
        return redirect('login')
    rol = request.session.get('rol')
    with connection.cursor() as cursor1:
        cursor1.callproc('sp_mostrarDetalleVenta',[id_venta])
        detalles = cursor1.fetchall()

    with connection.cursor() as cursos2:
        cursos2.callproc('sp_ConsultarTodoProducto')  
        productos = cursos2.fetchall()  

    return render(request,'panel_detalle_venta.html',{'detalles':detalles,'rol':rol,'productos':productos,'id_venta':id_venta})



def agregar_detalle_venta(request, id_venta):
    if 'id_usuario' not in request.session:
        return redirect('login')

    if request.method == 'POST':
        id_producto = request.POST.get('id_producto')
        cantidad = request.POST.get('cantidad')
       


        with connection.cursor() as cursor:
            cursor.callproc('sp_registrarDetalleVenta', [id_venta, id_producto, cantidad])
            

        return redirect('detalle_venta', id_venta=id_venta)
    



def actualizar_detalle_venta(request,id_detalle_venta):
     if 'id_usuario' not in request.session:
        return redirect('login')
     
     if request.method == 'POST':
         cantidad = request.POST.get('cantidad')
         id_venta = request.POST.get('id_venta')

         with connection.cursor() as cursor:
            cursor.callproc('sp_actualizarDetalleVenta',[id_detalle_venta,cantidad])
        
            return redirect('detalle_venta', id_venta=id_venta)
                            



def eliminar_detalle_venta(request, id_detalle_venta,id_venta):
    if 'id_usuario' not in request.session:
        return redirect('login')

    with connection.cursor() as cursor:
        cursor.callproc('sp_eliminarDetalleVenta',[id_detalle_venta])

        return redirect('detalle_venta', id_venta=id_venta)



