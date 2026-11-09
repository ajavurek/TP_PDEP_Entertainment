object fan {

    method precioConDescuento(precio) = precio // no tiene descuento
    method bonificar() {
        // no hace nada
    }
}

class Vip { //el porcentaje de descuento es particular de cada asistente
    var porcentajeDescuento

    method porcentajeDescuento() = porcentajeDescuento
    method precioConDescuento(precio) = precio * (100 - porcentajeDescuento) / 100
    method bonificar() {
        porcentajeDescuento += 1
    }
}