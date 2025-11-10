from django.db import connection
from django.shortcuts import redirect, render
from inventario.models_mongo import EventoSistema



# PARTE INVENTARIO

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

    

def actualizar_producto_inventario(request,id_detalle_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    if request.method == 'POST':
        cantidad = request.POST.get('cantidad')
        stock_minimo = request.POST.get('stock_minimo')
        stock_maximo = request.POST.get('stock_maximo')

        with connection.cursor() as cursor:
            cursor.callproc('sp_actualizarDetallesInventario',[id_detalle_inventario,cantidad,stock_minimo,stock_maximo])
            connection.commit()

        #  AUDITORÍA
        EventoSistema(
            usuario=request.session.get('nombre'),
            accion="ACTUALIZAR_PRODUCTO_INVENTARIO",
            descripcion=f"Detalle #{id_detalle_inventario} → Cantidad: {cantidad}, Min: {stock_minimo}, Max: {stock_maximo}",
            ip=request.META.get('REMOTE_ADDR')
        ).save()

        return redirect('inventario')

def eliminar_producto_inventario(request,id_detalle_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    with connection.cursor() as cursor:
        cursor.callproc('sp_eliminarDetalleInventario',[id_detalle_inventario])
        connection.commit()

    # AUDITORÍA
    EventoSistema(
        usuario=request.session.get('nombre'),
        accion="ELIMINAR_PRODUCTO_INVENTARIO",
        descripcion=f"Se eliminó el detalle de inventario #{id_detalle_inventario}",
        ip=request.META.get('REMOTE_ADDR')
    ).save()

    return redirect('inventario')





# PARTE INGRESO INVENTARIO


def panel_ingreso_inventario(request):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    id_tienda = request.session.get('id_tienda')
    rol = request.session.get('rol')

    with connection.cursor() as cursor :
        cursor.callproc('sp_mostrarIngresosInventario',[id_tienda])
        detalles_ingresos = cursor.fetchall()

    return render(request,'panel_ingreso_inventario.html',{'detalles_ingresos':detalles_ingresos , 'rol':rol})



def ingreso_inventario(request):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    if request.method == 'POST':

        motivo = request.POST.get('motivo')
        id_tienda = request.session.get('id_tienda')
        id_usuario = request.session.get('id_usuario')

        with connection.cursor() as cursor:
            cursor.callproc('sp_ingresoInventario',[id_tienda,id_usuario,motivo])
            connection.commit()

        #  AUDITORÍA
        EventoSistema(
            usuario=request.session.get('nombre'),
            accion="NUEVO_INGRESO_INVENTARIO",
            descripcion=f"Motivo: {motivo}",
            ip=request.META.get('REMOTE_ADDR')
        ).save()

    return redirect('ingreso_inventario')


def actualizar_ingreso_inventario(request, id_ingreso_inventario):
     if 'id_usuario' not in request.session:
        return redirect('login')
     
     if request.method == 'POST':
         motivo = request.POST.get('motivo')
        
         with connection.cursor() as cursor:
            cursor.callproc('sp_actualizarIngresoInventario',[id_ingreso_inventario,motivo])
        
            return redirect('ingreso_inventario')


def eliminar_ingreso_inventario(request,id_ingreso_inventario):
     if 'id_usuario' not in request.session:
        return redirect('login')
     
     with connection.cursor() as cursor :
         cursor.callproc('sp_eliminarIngresoInventario',[id_ingreso_inventario])
         return redirect('ingreso_inventario')




# PARTE DETALLE INGRESO


def panel_detalle_ingreso(request,id_ingreso_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')
    rol = request.session.get('rol')
    with connection.cursor() as cursor1:
        cursor1.callproc('sp_mostrarDetallesIngreso',[id_ingreso_inventario])
        detalles = cursor1.fetchall()

    with connection.cursor() as cursos2:
        cursos2.callproc('sp_ConsultarTodoProducto')  
        productos = cursos2.fetchall()  

    return render(request,'panel_detalle_inventario.html',{'detalles':detalles,'rol':rol,'productos':productos,'id_ingreso_inventario':id_ingreso_inventario})




def agregar_detalle_ingreso(request, id_ingreso_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')

    if request.method == 'POST':
        id_producto = request.POST.get('id_producto')
        cantidad = request.POST.get('cantidad')

        with connection.cursor() as cursor:
            cursor.callproc('sp_registrarDetalleIngreso', [id_ingreso_inventario, id_producto, cantidad])
            connection.commit()

        # AUDITORÍA
        EventoSistema(
            usuario=request.session.get('nombre'),
            accion="AGREGAR_PRODUCTO_INGRESO",
            descripcion=f"Ingreso #{id_ingreso_inventario} → Producto {id_producto} x{cantidad}",
            ip=request.META.get('REMOTE_ADDR')
        ).save()

        return redirect('detalle_ingreso', id_ingreso_inventario=id_ingreso_inventario)

    
def actualizar_detalle_ingreso(request, id_detalle_ingreso):
     if 'id_usuario' not in request.session:
        return redirect('login')
     
     if request.method == 'POST':
         cantidad = request.POST.get('cantidad')
         id_ingreso = request.POST.get('id_ingreso')

         with connection.cursor() as cursor:
            cursor.callproc('sp_actualizarDetalleIngreso',[id_detalle_ingreso,cantidad])
        
            return redirect('detalle_ingreso', id_ingreso_inventario=id_ingreso)
                            



def eliminar_detalle_ingreso(request, id_detalle_ingreso,id_ingreso_inventario):
    if 'id_usuario' not in request.session:
        return redirect('login')

    with connection.cursor() as cursor:
        cursor.callproc('sp_eliminarDetalleIngreso',[id_detalle_ingreso])

        return redirect('detalle_ingreso', id_ingreso_inventario=id_ingreso_inventario)



# TRASLADO INVENTARIO

def panel_traslado_inventario(request):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    rol = request.session.get('rol')
    id_tienda = request.session.get('id_tienda')
    tienda_emplado = None

    with connection.cursor() as cursor1:
        cursor1.callproc('sp_mostrarTrasladoInventario',[id_tienda])
        traslados = cursor1.fetchall()

    with connection.cursor() as cursor2:

        cursor2.callproc('sp_seleccionarTienda')
        tiendas = cursor2.fetchall()

        for i in tiendas:
            if i[0] == id_tienda:
                tienda_emplado = i
                break


        return render(request,'panel_traslado_inventario.html',{'traslados':traslados ,'tiendas':tiendas, 'rol':rol,'tienda':tienda_emplado})
    



def agregar_traslado_inventario(request):
    if 'id_usuario' not in request.session:
        return redirect('login')
    
    if request.method =='POST':

        origen = request.POST.get('origen')
        destino = request.POST.get('destino')
        id_usuario = request.session.get('id_usuario')

        with connection.cursor() as cursor:
            cursor.callproc('sp_registrarTrasladoInventario',[origen,destino,id_usuario])
            connection.commit()

        #  AUDITORÍA
        EventoSistema(
            usuario=request.session.get('nombre'),
            accion="TRASLADO_INVENTARIO",
            descripcion=f"Traslado de tienda {origen} → {destino}",
            ip=request.META.get('REMOTE_ADDR')
        ).save()

    return redirect('traslado_inventario')






def eliminar_traslado_inventario(request,id_traslado_inventario):
     if 'id_usuario' not in request.session:
        return redirect('login')
     
     with connection.cursor() as cursor :
         cursor.callproc('sp_eliminarTraslado',[id_traslado_inventario])
         return redirect('traslado_inventario')