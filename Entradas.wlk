class Entrada {
    const property banda
    const property fecha
    const precioBase = 1000

    method precioFinal() = precioBase + productora.impuesto()

    method esDelAnio(anio) = fecha.year() == anio
}

class Asistente {
    var property abono
    const property historialDeEntradas = []
    var property dineroDisponible

    method tieneSaldoPositivo() = dineroDisponible > 0
    method comprarEntrada(unaEntrada) {
       if(self.tieneSaldoPositivo()){
            self.pagar(unaEntrada)
            historialDeEntradas.add(unaEntrada)
        } else {
            throw new NoPuedeComprarEntradaException(message = "No puede comprar entrada, tiene saldo negativo :(")
        }
    }
    method montoAPagar(unaEntrada) = abono.precioConDescuento(unaEntrada.precioFinal())
    method pagar(unaEntrada) {
        dineroDisponible -= self.montoAPagar(unaEntrada)
    }
    method entradasDelAnioAnterior() = historialDeEntradas.filter({unaEntrada => unaEntrada.esDelAnio(new Date().year() - 1)})
    method bandasPorLasQueComproEntrada() = historialDeEntradas.map({unaEntrada => unaEntrada.banda().nombre()}).asSet()
    method bonificar() {
        abono.bonificar()
    }
}

class NoPuedeComprarEntradaException inherits Exception {

}

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

class Banda {
    const property nombre

    method canon() = 1000000
    method presupuesto() = self.canon() + self.gastoExtra()
    method gastoExtra()
    method popularidad()
}

class BandaDeRock inherits Banda {
    var property cantidadSolosGuitarra

    override method gastoExtra() = 10000
    override method popularidad() = cantidadSolosGuitarra * 100
}

class BandaDeTrap inherits Banda {
    var property tienenHielo

    override method canon() = super() * self.popularidad()
    override method gastoExtra() = 0
    override method popularidad() {
        if(tienenHielo) {
            return 1000
        } else {
            return 0
        }
    }  
}

class BandaIndie inherits Banda {
    const cantidadDeInstrumentos

    override method popularidad() = 3.14 * nombre.length()
    override method gastoExtra() = cantidadDeInstrumentos * 500
}

object productora {
    const bandasConLasQueTrabaja = []
    const asistentes = []
    var property impuesto = 20

    method trabajarConNuevaBanda(unaBanda) {
        bandasConLasQueTrabaja.add(unaBanda)
    }
    method entradasVendidas() = asistentes.flatMap({unAsistente => unAsistente.historialDeEntradas()})
    method cantidadEntradasVendidas() = self.entradasVendidas().size()
    method recaudacionDeEntradas() = self.entradasVendidas().sum({unaEntrada => unaEntrada.precioFinal()})
    method presupuestoDeBandas() = bandasConLasQueTrabaja.sum({unaBanda => unaBanda.presupuesto()})
    method gananciaTotal() = self.recaudacionDeEntradas() - self.presupuestoDeBandas()
    method entradasVendidasDe(unaBanda) = self.entradasVendidas().count({unaEntrada => unaEntrada.banda() == unaBanda})
    method bandaMasPopular() = bandasConLasQueTrabaja.max({unaBanda => self.entradasVendidasDe(unaBanda)})
    method bonificarAsistentes() {
       asistentes.forEach({unAsistente => unAsistente.bonificar() })
    }
}