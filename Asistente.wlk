import Productora.*

class NoPuedeComprarEntradaException inherits Exception {

}

class Asistente {
    var property abono
    const historialDeEntradas = []
    var dineroDisponible

    method dineroDisponible() = dineroDisponible
    method tieneSaldoPositivo() = dineroDisponible > 0
    method comprarEntrada(unaBanda, unaFecha) {
       if(!self.tieneSaldoPositivo()){
            throw new NoPuedeComprarEntradaException(message = "No puede comprar entrada, tiene saldo negativo :(")
        }
        const unaEntrada = productora.emitirEntrada(unaBanda, unaFecha)
        self.pagar(unaEntrada)
        historialDeEntradas.add(unaEntrada)
    }
    method montoAPagar(unaEntrada) = abono.precioConDescuento(unaEntrada.precioFinal())
    method pagar(unaEntrada) {
        dineroDisponible -= self.montoAPagar(unaEntrada)
    }
    method entradasDelAnioAnterior() = historialDeEntradas.filter({unaEntrada => unaEntrada.esDelAnio(new Date().year() - 1)})
    method bandasPorLasQueComproEntrada() = historialDeEntradas.map({unaEntrada => unaEntrada.banda().nombre()}).asSet()
    method cantidadDeEntradas() = historialDeEntradas.size()
    method cantidadDeEntradasDe(unaBanda) = historialDeEntradas.count({unaEntrada => unaEntrada.esDeLaBanda(unaBanda)})
    method gastoTotalEnEntradas() = historialDeEntradas.sum({unaEntrada => unaEntrada.precioFinal()})
    method bonificar() {
        abono.bonificar()
    }
}