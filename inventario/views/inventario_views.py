from django.shortcuts import redirect, render

def panel_inventario(request):
    return render(request,'panel_inventario.html')