# Atajos de Neovim

`Space` es la tecla líder. Usá el modo normal salvo donde se indica otro.

## Proyecto y búsqueda

| Atajo | Acción |
| --- | --- |
| `Space e` o `:tree` | Abrir o cerrar el árbol |
| `Space E` | Revelar el archivo actual en el árbol |
| `Enter`, `a`, `r` en el árbol | Abrir, crear y renombrar |
| `U` en el árbol | Activar o desactivar el filtro de carpetas |
| `g?` en el árbol | Ver los atajos del árbol |
| `Space p` o `Space fs` | Encontrar un archivo con Telescope |
| `Space rg` | Buscar texto en el proyecto con Telescope |
| `Space P` | Buscar la palabra actual o la selección visual de una línea |
| `Space n` | Limpiar el resaltado de búsqueda y de referencias |
| `Space s` | Escribir dos caracteres y saltar con EasyMotion |
| `Space rf` | Buscar y reemplazar en el archivo actual con vista previa y confirmación |
| `Space rr` | Buscar y reemplazar con una expresión regular en el archivo actual |
| `Space rp` | Abrir el panel de reemplazo en el proyecto |
| `R` en el panel de reemplazo | Aplicar al disco los reemplazos del proyecto |
| `Esc` y luego `Space c` en el panel de reemplazo | Cerrar el panel |
| `Space bf` | Buscar en buffers abiertos |
| `Space da` | Buscar diagnósticos con Telescope |
| `Ctrl+q` en Telescope | Enviar resultados a quickfix |

## LSP y formato

| Atajo | Acción |
| --- | --- |
| `gd`, `gy`, `gi` | Ir a la definición, tipo e implementación |
| `grr` | Buscar referencias en Telescope con vista previa del archivo |
| `Space rh` | Resaltar las referencias del símbolo en el archivo actual |
| `Enter` o `Esc` en el panel de referencias | Ir a la referencia elegida o cerrar el panel |
| `K` | Ver documentación del símbolo |
| `Space rn` o `grn` | Renombrar el símbolo |
| `Space a` o `gra` | Pedir acciones de código en modo normal o visual |
| `Space f` | Formatear el archivo o la selección |
| `Space ef` | Aplicar correcciones automáticas de ESLint |
| `[g`, `]g` | Ir al diagnóstico anterior y siguiente |
| `Space dd` | Ver el diagnóstico bajo el cursor |
| `Ctrl+x Ctrl+o` o `Alt+Space` | Pedir completado LSP en modo insertar |
| `Space uh` | Mostrar u ocultar las anotaciones de tipos y parámetros del LSP |
| `Tab`, `Shift+Tab` | Recorrer sugerencias o campos de un snippet |
| `Enter` o `Ctrl+y` | Aceptar la sugerencia seleccionada |
| `Alt+l` | Aceptar la sugerencia en línea si Copilot está activado |
| `:LspTypescriptSourceAction` | Ver acciones sobre todo el archivo de TypeScript o JavaScript |

## Multicursor y edición

| Atajo | Acción |
| --- | --- |
| `(`, `{`, `[`, `"`, `'` en modo insertar | Insertar el par y dejar el cursor entre ambos |
| `Space C` con texto seleccionado | Elegir un formato como camelCase, snake_case o Title Case |
| `Space C` con selecciones de Visual Multi | Convertir todas las selecciones con `c` para camelCase, `s` para snake_case o `t` para Title Case |
| `Ctrl+n` | Seleccionar la siguiente coincidencia en modo normal o visual |
| `\\A` | Seleccionar todas las coincidencias en modo normal o visual |
| `Space mk` o `Ctrl+↑` | Agregar un cursor arriba |
| `Space mj` o `Ctrl+↓` | Agregar un cursor abajo |
| `c` con regiones activas | Reemplazar las coincidencias seleccionadas |
| `Esc` | Salir de Visual Multi. En modo insertar, presionalo dos veces |
| `gcc` o `Ctrl+/` | Comentar o descomentar la línea |
| `gc` o `Ctrl+/` en modo visual | Comentar o descomentar la selección |
| `J`, `K` en modo visual | Mover la selección hacia abajo y arriba |
| `Ctrl+c` en modo visual | Copiar al portapapeles |
| `Space ;` | Agregar punto y coma al final de la línea |

## Historial del cursor

| Atajo | Acción |
| --- | --- |
| Clic izquierdo en otra línea en modo normal | Registrar la posición anterior en la ventana de edición activa |
| `Space -` o `Ctrl+o` | Volver a la posición anterior |
| `Space =` | Avanzar en el historial |
| `:jumps` | Ver el historial de la ventana actual |

## Macros

| Atajo | Acción |
| --- | --- |
| `qa` y luego `q` | Empezar a grabar en el registro `a` y detener la grabación |
| `@a` o `3@a` | Ejecutar la macro `a` una o tres veces |
| `@@` | Repetir la última macro |

## Buffers, ventanas y pestañas

| Atajo | Acción |
| --- | --- |
| `Space w`, `Space q`, `Space Q` | Guardar, cerrar la ventana o cerrarla descartando cambios |
| `Tab`, `Shift+Tab` en modo normal | Siguiente buffer y buffer anterior |
| Clic en el nombre o en `×` en la barra superior | Abrir o cerrar el archivo |
| Clic en `×` en la cabecera de un split | Cerrar ese split |
| `Alt+→`, `Alt+←` | Siguiente buffer y buffer anterior |
| `Space bd`, `Space bD`, `Space F4` | Cerrar, forzar el cierre o eliminar el buffer |
| `gt`, `gT` | Pestaña siguiente y anterior |
| `:tabnew`, `:tabclose` | Crear y cerrar la pestaña actual |
| `Space ur` o `:e!` | Recargar el archivo desde disco y descartar los cambios sin guardar |
| `Space L` | Abrir el panel de plugins de Lazy |
| `Ctrl+j`, `Ctrl+k` | Desplazar la ventana diez líneas abajo y arriba |
| `Space h`, `Space l` | Reducir y ampliar el ancho de la ventana |

## Git y terminal

| Atajo | Acción |
| --- | --- |
| `Space G` | Abrir LazyGit en la raíz del repositorio |
| `q` en LazyGit | Cerrar LazyGit y volver al editor |
| `:Git` | Abrir el estado de Git con Fugitive |
| `Space gd` | Comparar el archivo actual con HEAD |
| `Space gc` | Crear un commit con los cambios agregados al índice |
| `Space gH` | Ver el historial del archivo actual |
| `s`, `u`, `=`, `cc` en el estado de Git | Agregar al índice, sacar del índice, mostrar diff y abrir el editor de commit |
| `[c`, `]c` | Ir al bloque de cambios anterior y siguiente |
| `Space gb` | Mostrar u ocultar el autor y la fecha del cambio de la línea actual en la barra de estado |
| `Space ghp`, `Space ghs`, `Space ghr` | Previsualizar, agregar al índice o revertir el bloque de cambios |
| `Ctrl+\` | Abrir o cerrar la terminal horizontal |
| `Space tf` | Abrir la terminal flotante |
| `Space ai` | Abrir Claude Code en una terminal flotante si el CLI está instalado |
| `Space x` | Ejecutar el archivo actual con Node.js |
| `Space jt` | Ejecutar la clase de prueba actual con Maven |
