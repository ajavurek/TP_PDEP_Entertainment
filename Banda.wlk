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