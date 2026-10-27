# PDEP Entertainment

## Decisiones de diseño

1. **La productora es wko (`object productora`).** Hay una sola y es quien fija el impuesto, que es el mismo para todas las entradas y puede cambiar. Cambiar `productora.impuesto(...)` impacta en todas las entradas sin tocar nada más. Además concentra los reportes porque es quien conoce a las bandas y a los asistentes.
2. **El precio de la entrada se calcula, no se guarda.** `precioAlPublico()` consulta el impuesto vigente en cada llamada. Es simple y refleja "el impuesto puede variar". Si se quisiera congelar el precio al momento de la compra, habría que guardarlo en la entrada al crearla.
3. **Los abonos son objetos polimórficos (`fan` y `Vip`).** El asistente le delega el cálculo del precio y la bonificación al abono, sin preguntar de qué tipo es. `fan` no tiene estado, por eso es un objeto; `Vip` es una clase porque cada asistente tiene su propio porcentaje de descuento. Como el abono es una referencia modificable, un asistente podría cambiar de abono.
4. **Las bandas usan herencia con un método abstracto.** `Banda` define `presupuesto() = canon + gastoExtra` una sola vez y las subclases (`Rock`, `Trap`, `Indie`) completan `gastoExtra()` y `popularidad()`. `Trap` redefine `canon()` usando `super()` para reutilizar el canon base.
5. **La compra valida antes de modificar.** Si el saldo no es positivo se lanza una `Exception` con un mensaje claro y no se toca ni el dinero ni el historial. Si es positivo, la compra se hace completa (el dinero puede quedar negativo después).
6. **La productora obtiene las entradas vendidas desde los historiales de los asistentes.** Así el historial es la única fuente y no hay datos duplicados que puedan desincronizarse.
7. **La banda más popular se calcula sobre las bandas registradas**, no sobre las entradas, para contemplar bandas que todavía no vendieron entradas.
8. **Las entradas del año anterior se filtran por la fecha del show**, porque la entrada sólo conoce la fecha en la que toca la banda.
9. **Los nombres de bandas se devuelven como conjunto**, para no repetir una banda si el asistente compró varias entradas para ella.
10. **`bonificar()` en `fan` no hace nada.** Evita preguntar por tipo (`if esVip`) y permite que la productora bonifique a todos los asistentes con un simple `forEach`.

## Conceptos

**Polimorfismo** `fan` / `Vip` (`precioConDescuento`, `bonificar`); `Rock` / `Trap` / `Indie` (`popularidad`, `gastoExtra`) Quien envía el mensaje (`Asistente`, `productora`) trata igual a todos los que lo entienden. Se evitan los `if` por tipo y se pueden agregar abonos o géneros nuevos sin modificar código existente. 
| **Herencia** | `Banda` → `Rock`, `Trap`, `Indie` | Las tres bandas comparten nombre, canon base y cálculo del presupuesto; la herencia evita código repetido y expresa la relación "es una banda". |
| **Método abstracto / Template Method** | `Banda.presupuesto()` y los métodos abstractos `gastoExtra()` y `popularidad()` | El algoritmo del presupuesto se define una vez en la superclase y cada subclase completa el paso que cambia. |
| **Method override y `super`** El canon reutiliza el canon común y lo multiplica por su popularidad, sin repetir el valor 1.000.000. |
| **Encapsulamiento y delegación** | `Asistente` delega en `abono` y en `Entrada`; `Entrada.esDelAnio` | Cada objeto es responsable de su propio estado y comportamiento; los demás interactúan sólo por mensajes. |
| **Objetos bien conocidos ** | `productora`, `fan` | Hay una única productora (impuesto compartido) y un único abono fan sin estado. |
| **Composición (colaboración entre objetos)** | `Asistente` tiene un `abono` y una colección de `Entrada`; `Entrada` conoce a su `Banda` | Se modela el dominio con objetos que colaboran, y se puede cambiar el abono de un asistente en tiempo de ejecución. |
**Colecciones y orden superior** `filter`, `map`, `flatMap`, `sum`, `count`, `max`, `forEach` | Los reportes y consultas se expresan de forma declarativa, sin ciclos ni acumuladores manuales.
**Excepciones** Se notifica el error de forma adecuada y se evita que el sistema quede en un estado inconsistente.
**Separación entre comandos y consultas** `comprarEntrada` / `bonificar` (efecto) vs. `montoAPagar` / `precioFinal` / reportes (devuelven valores) | Las consultas no modifican el estado.
