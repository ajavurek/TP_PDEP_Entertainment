import Entradas.*

object productora {
    const bandasConLasQueTrabaja = []
    const asistentes = #{}
    var property impuesto = 0.2 // el 20%

    method trabajarConNuevaBanda(unaBanda) {
        bandasConLasQueTrabaja.add(unaBanda)
    }
    method registrarAsistente(unAsistente) {
        asistentes.add(unAsistente)
    }

    method emitirEntrada(unaBanda, unaFecha) = new Entrada(banda = unaBanda, fecha = unaFecha, productora = self)

    method cantidadEntradasVendidas() = asistentes.sum({unAsistente => unAsistente.cantidadDeEntradas()})
    method recaudacionDeEntradas() = asistentes.sum({unAsistente => unAsistente.gastoTotalEnEntradas()})
    method presupuestoDeBandas() = bandasConLasQueTrabaja.sum({unaBanda => unaBanda.presupuesto()})
    method gananciaTotal() = self.recaudacionDeEntradas() - self.presupuestoDeBandas()
    method entradasVendidasDe(unaBanda) = asistentes.sum({unAsistente => unAsistente.cantidadDeEntradasDe(unaBanda)})
    method bandaMasPopular() = bandasConLasQueTrabaja.max({unaBanda => self.entradasVendidasDe(unaBanda)})
    method bonificarAsistentes() {
       asistentes.forEach({unAsistente => unAsistente.bonificar() })
    }
}