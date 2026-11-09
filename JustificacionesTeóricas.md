# PDEP Entertainment

## Decisiones de diseño

1. **La productora es wko (`object productora`).** Hay una sola y es quien fija el impuesto, que es el mismo para todas las entradas y puede cambiar. Cambiar `productora.impuesto(...)` impacta en todas las entradas sin tocar nada más. Además concentra los reportes porque es quien conoce a las bandas y a los asistentes.
2. **La entrada conoce a la productora que la emitió y calcula su precio.** `Entrada.precioFinal()` es `precioBase * (1 + productora.impuesto())` y consulta el impuesto vigente en cada llamada, que se expresa como fracción (0.2 = 20%). Muestra que el impuesto puede variar y no se guarda ningún precio. La entrada la crea la productora con `emitirEntrada(banda, fecha)`, porque es quien la emite. 
3. **Los abonos son objetos polimórficos (`fan` y `Vip`).** El asistente le delega el cálculo del precio y la bonificación al abono, sin preguntar de qué tipo es. `fan` no tiene estado, por eso es un objeto; `Vip` es una clase porque cada asistente tiene su propio porcentaje de descuento. Como el abono es una referencia modificable, un asistente podría cambiar de abono.
4. **Las bandas usan herencia con un método abstracto.** `Banda` define `presupuesto() = canon + gastoExtra` una sola vez y las subclases (`Rock`, `Trap`, `Indie`) completan `gastoExtra()` y `popularidad()`. Se redefine `canon()` usando `super()` para reutilizar el canon base.
5. **La compra se pide con banda y fecha: `comprarEntrada(banda, fecha)`.** El asistente le pide la entrada a la productora y la agrega a su historial. **Valida antes de modificar.** Si el saldo no es positivo se lanza una `Exception` con un mensaje y no se toca ni el dinero ni el historial. Si es positivo, la compra se hace completa (el dinero puede quedar negativo después).
6. **La productora no abre los historiales: le pregunta a cada asistente.** Los asistentes se registran con `registrarAsistente` y se guardan en un `Set` (una persona no se repite). La `gananciaTotal()` consulta a cada asistente su `gastoTotalEnEntradas()` (suma del precio de sus entradas, sin descuento vip) y resta el presupuesto de las bandas; la cantidad de entradas y las vendidas por banda también se piden a cada asistente. El historial es la única fuente y es privado.
7. **La banda más popular se calcula sobre las bandas registradas**, no sobre las entradas, para contemplar bandas que todavía no vendieron entradas.
8. **Las entradas del año anterior se filtran por la fecha del show**, porque la entrada sólo conoce la fecha en la que toca la banda.
9. **Los nombres de bandas se devuelven como conjunto**, para no repetir una banda si el asistente compró varias entradas para ella.
10. **`bonificar()` en `fan` no hace nada.** Evita preguntar por tipo (`if esVip`) y permite que la productora bonifique a todos los asistentes con un simple `forEach`.

## Conceptos

**Polimorfismo** `fan` / `Vip` (`precioConDescuento`, `bonificar`); `Rock` / `Trap` / `Indie` (`popularidad`, `gastoExtra`). Quien envía el mensaje (`Asistente`, `productora`) trata igual a todos los que lo entienden. Se evitan los `if` por tipo y se pueden agregar abonos o géneros nuevos sin modificar código existente. 
**Herencia**  `Banda` → `Rock`, `Trap`, `Indie` Las tres bandas comparten nombre, canon base y cálculo del presupuesto; la herencia evita código repetido y expresa la relación "es una banda". 
**Método abstracto** `Banda.gastoExtra()` y `Banda.popularidad()` son abstractos; `Banda.presupuesto()` es el método plantilla que los usa. La fórmula del presupuesto (`canon + gastoExtra`) se define una vez en la superclase y cada subclase completa el paso que cambia.
**Method override y `super`** El canon reutiliza el canon común y lo multiplica por su popularidad, sin repetir el valor 1.000.000. 
**Encapsulamiento y delegación** `Asistente` delega en `abono` y en `Entrada`; `Entrada.esDelAnio`  Cada objeto es responsable de su propio estado y comportamiento; los demás interactúan sólo por mensajes. 
**Objetos bien conocidos**  `productora`, `fan`. Hay una única productora (impuesto compartido) y un único abono fan sin estado. 
**Composición** `Asistente` tiene un `abono` y una colección de `Entrada`; `Entrada` conoce a su `Banda` | Se modela el dominio con objetos que colaboran, y se puede cambiar el abono de un asistente en tiempo de ejecución. 
**Colecciones y orden superior** `filter`, `map`, `sum`, `count`, `max`, `forEach`  Los reportes y consultas se expresan de forma declarativa, sin ciclos ni acumuladores manuales.
**Excepciones** Se notifica el error y se evita que el sistema quede en un estado inconsistente.
**Separación entre comandos y consultas** `comprarEntrada` / `bonificar` (efecto) vs. `montoAPagar` / `precioFinal` / reportes (devuelven valores). Las consultas no modifican el estado.
