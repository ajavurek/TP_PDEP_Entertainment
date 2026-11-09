import Productora.*

class Entrada {
    const property banda
    const property fecha
    const productora
    const precioBase = 1000

    method precioFinal() = precioBase * (1 + productora.impuesto())

    method esDelAnio(anio) = fecha.year() == anio
    method esDeLaBanda(unaBanda) = banda == unaBanda
}