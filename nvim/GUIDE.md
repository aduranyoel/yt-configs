# Neovim como IDE

`Space` es la tecla líder. La mayoría de los atajos de esta guía se usan en modo normal. Consultá la [referencia de atajos](./KEYMAPS.md) para ver los demás.

## Primera instalación

Necesitás Neovim 0.11.3 o posterior, Git, Node.js con npm, ripgrep (`rg`) y un compilador de C para los parsers de Tree-sitter. Para Java necesitás un JDK 21 o posterior para ejecutar JDTLS, Python 3.9 o posterior para su lanzador y el JDK que pida tu proyecto. Para instalar `sqls` con Mason necesitás Go.

1. Abrí Neovim y esperá a que lazy.nvim instale los plugins. Usá `Space L` para abrir el panel y `:Lazy restore` para recuperar las versiones de `lazy-lock.json`.
2. Ejecutá en Neovim los comandos de Mason que correspondan a los lenguajes que usás. También podés elegir los paquetes desde `:Mason`.

   ```vim
   :MasonInstall typescript-language-server html-lsp css-lsp json-lsp
   :MasonInstall eslint-lsp
   :MasonInstall jdtls
   :MasonInstall sqls
   ```

3. Cuando termine la instalación, volvé a abrir el archivo del proyecto. Si el servidor no se conecta, revisá `:checkhealth vim.lsp` en ese archivo y `:MasonLog` para errores de instalación.

Para formatear, Conform busca el Prettier del proyecto cuando está disponible. Podés instalar los formateadores con `:MasonInstall prettier google-java-format`. Presioná `Space f` para formatear el archivo o la selección. Conform también formatea al guardar y puede recurrir al LSP si el servidor ofrece formato. `:ConformInfo` muestra qué formateadores encontró para el archivo actual.

## Apariencia

Neovim usa **OneDark** con la variante `dark` al iniciar.

La cabecera de cada split muestra su archivo. La barra de estado incluye el modo, la ruta, la rama Git, el símbolo en el que estás cuando el LSP lo informa, y la posición del cursor. Los iconos y separadores se ven con una fuente compatible con Nerd Font en el terminal.

Las guías verticales muestran la indentación. Los servidores compatibles muestran tipos y nombres de parámetros junto al código. Usá `Space uh` para mostrar u ocultar esas anotaciones en el archivo actual.

## Abrir y navegar un proyecto

Desde la raíz del repositorio, ejecutá `nvim .` para abrir el árbol o `nvim` para empezar con un buffer vacío. Telescope busca desde el directorio actual, que podés consultar con `:pwd`.

| Atajo | Acción |
| --- | --- |
| `Space e` | Abrir o cerrar el árbol |
| `Space E` | Revelar el archivo actual en el árbol |
| `U` dentro del árbol | Mostrar u ocultar las carpetas filtradas, como `node_modules`, `target` y `dist` |
| `Space p` | Buscar un archivo por nombre con Telescope |
| `Space rg` | Buscar texto en el proyecto con ripgrep |
| `Space P` | Buscar la palabra bajo el cursor o la selección visual de una línea desde la raíz Git o el directorio actual |
| `Space n` | Limpiar el resaltado de búsqueda y de referencias |
| `Space s` | Saltar a dos caracteres visibles con EasyMotion |
| `Space bf` | Buscar entre los buffers abiertos |

En Telescope, presioná `Enter` para abrir el resultado elegido. `Ctrl+q` envía los resultados a quickfix, donde podés recorrerlos con `:cnext` y `:cprev`. Usá `:Telescope` para descubrir otros buscadores.

### Buscar y reemplazar

- **Archivo actual con `Space rf`.** Escribí el texto que querés buscar, pulsá `→` para pasar al reemplazo y escribí el texto nuevo. Revisá la vista previa y pulsá `Enter`. En cada coincidencia, `y` reemplaza, `n` salta, `a` aplica las restantes y `q` termina. Guardá el archivo para escribir los cambios en disco.
- **Expresión regular con `Space rr`.** Usá el mismo flujo con la sintaxis *very magic* de Vim. Por ejemplo, buscá `id_([0-9]+)` y reemplazá por `item_\1` para convertir `id_42` en `item_42`.
- **Proyecto con `Space rp`.** El panel busca desde la raíz Git o el directorio actual. Guardá los cambios que quieras incluir, completá **Search** y **Replace** y revisá los resultados. Podés acotar por ruta o extensión con **Files Filter**. Pulsá `Esc` y luego `R` para aplicar el reemplazo en disco. Para cerrar el panel, pulsá `Esc` y después `Space c`.

### Historial del cursor

En modo normal, al hacer clic en otra línea de la ventana de edición activa se guarda la posición anterior. Después de hacer clic en las líneas 10, 25 y 40, usá `Space -` para volver a 25 y 10, y `Space =` para avanzar. También podés retroceder con `Ctrl+o`. Cada ventana mantiene su propio historial, que podés consultar con `:jumps`.

### Buffers, ventanas y pestañas

La barra superior muestra los archivos abiertos. Hacé clic en el nombre para cambiar de archivo y en `×` para cerrarlo. Si ves `●`, hay cambios sin guardar. Al guardar, vuelve a aparecer `×`.

Una ventana muestra un buffer y una pestaña de Neovim agrupa ventanas.

| Qué querés hacer | Atajo o comando |
| --- | --- |
| Cambiar de buffer | `Tab` adelante, `Shift+Tab` atrás o `Space bf` para elegir |
| Cerrar el buffer actual | `Space bd` |
| Volver a la última versión guardada y descartar los cambios sin guardar | `Space ur` o `:e!` |
| Cambiar de pestaña | `gt` adelante, `gT` atrás |
| Crear o cerrar una pestaña | `:tabnew` o `:tabclose` |
| Cerrar la ventana actual | `Space q` |

## Grabar y repetir macros

En modo normal, presioná `qa` para grabar tus teclas en el registro `a`. Neovim muestra `recording @a` mientras grabás. Volvé a modo normal y presioná `q` para terminar. `@a` ejecuta la macro, `@@` repite la última y `3@a` ejecuta la macro de `a` tres veces.

Por ejemplo, para agregar un punto y coma al final de varias líneas, grabá `qa` → `A;` → `Esc` → `j` → `q`. La primera línea ya quedó editada durante la grabación. Usá `3@a` para aplicar el cambio a las tres siguientes.

## Navegar y refactorizar código

1. Poné el cursor sobre un símbolo. Usá `gd` para ir a su definición o `grr` para abrir sus referencias en Telescope con vista previa. Podés escribir para filtrar los resultados. `Enter` salta a la referencia elegida y cierra el panel. `Esc` lo cierra sin moverte.
2. Presioná `Space rn`, escribí el nuevo nombre y confirmá con `Enter`. El servidor actualiza la declaración y las referencias que reconoce en el proyecto. Revisá los cambios y guardá los buffers modificados con `:wall`.
3. Presioná `Space a` sobre un símbolo o desde una selección visual para pedir acciones de código. El servidor decide qué acciones ofrece, como extraer una función a partir de las líneas seleccionadas.

Para resaltar las referencias del símbolo en el archivo actual, poné el cursor sobre el nombre y pulsá `Space rh`. `Space n` quita el resaltado.

En modo insertar, usá `Ctrl+x Ctrl+o` para pedir sugerencias. También podés usar `Alt+Space`. El menú se abre automáticamente con los caracteres de activación del servidor, como `.` en TypeScript. Recorré las sugerencias con `Tab` y `Shift+Tab` y aceptá la seleccionada con `Enter`. En un snippet, `Tab` y `Shift+Tab` también mueven el cursor entre campos.

### Sugerencias de IA con GitHub Copilot

Copilot se carga al invocar `:Copilot`. Necesita Node.js 22 o posterior y una cuenta de GitHub con acceso a Copilot. Para usarlo por primera vez, ejecutá `:Copilot auth` y completá el inicio de sesión. En sesiones siguientes, activalo con `:Copilot enable`. Copilot usa el contexto del código para generar sugerencias en línea. Aceptalas con `Alt+l` y desactivá Copilot con `:Copilot disable`.

## Edición y varios cursores

En modo insertar, escribir una comilla, paréntesis, llave o corchete de apertura agrega su cierre y deja el cursor entre los dos.

Para cambiar el formato de un texto, seleccioná con `v`, pulsá `Space C` y elegí un estilo con `Enter`. Por ejemplo, `nombre de usuario` se puede convertir en `nombreDeUsuario`, `nombre_de_usuario`, `Nombre De Usuario` o `nombre-de-usuario`.

Para modificar coincidencias de texto en el mismo archivo, poné el cursor sobre una palabra y presioná `Ctrl+n` una vez por cada coincidencia que quieras seleccionar. También podés empezar con texto seleccionado en modo visual. Presioná `c`, escribí el reemplazo y pulsá `Esc` para terminar de insertar y otra vez para salir de Visual Multi.

Usá `\\A` (dos barras invertidas y una A mayúscula) para seleccionar todas las coincidencias. Agregá un cursor en la línea de abajo con `Space mj` o `Ctrl+↓`, y en la de arriba con `Space mk` o `Ctrl+↑`. Para cambiar el nombre de un símbolo y sus referencias, usá `Space rn`.

Con varias coincidencias seleccionadas, pulsá `Space C` y después `c` para camelCase, `s` para snake_case, `t` para Title Case, `P` para PascalCase o `-` para kebab-case. Cada selección se convierte por separado.

## Git

Usá `Space G` desde un archivo del repositorio para abrir LazyGit. Desde ahí podés revisar cambios, preparar commits y gestionar ramas. Pulsá `q` para volver al editor.

Usá `:Git` para abrir Fugitive, `Space gd` para comparar el archivo actual con HEAD y `Space gH` para ver su historial. Podés ejecutar `:Git pull` y `:Git push` desde el editor. Para navegar los bloques de cambios en el archivo, usá `[c` y `]c` con Gitsigns.

En archivos de Git, la barra de estado muestra el autor y la fecha y hora del último cambio de la línea actual. `Sin commit` indica que la línea tiene cambios pendientes. Usá `Space gb` para mostrar u ocultar ese dato.

## Flujos por lenguaje

- **Node.js, TypeScript y React.** Abrí el proyecto desde la raíz e instalá sus dependencias. Un mismo servidor atiende `.js`, `.jsx`, `.ts` y `.tsx`, con el `tsconfig.json` o `jsconfig.json` del proyecto para resolver el entorno y los imports. `Space x` ejecuta el archivo JavaScript actual con Node. Para iniciar un proyecto React, corré su script habitual en la terminal integrada, que se abre con `Ctrl+\`.
- **ESLint.** Instalá ESLint como dependencia del proyecto y usá la configuración del repositorio. Cuando se conecte el servidor, `Space ef` aplica las correcciones automáticas disponibles.
- **HTML, CSS y JSON.** Abrí archivos de estos tipos para activar sus servidores. Usá completado, diagnósticos y el formateador del proyecto desde los mismos atajos.
- **Java.** Abrí un archivo del proyecto Maven o Gradle y dejá que JDTLS importe e indexe el proyecto la primera vez. Si se demora al iniciar, verificá que el JDK con el que arranca JDTLS sea 21 o posterior. En una clase de prueba de Maven, `Space jt` ejecuta esa clase desde el módulo que contiene su `pom.xml` con el comando `mvn`.
- **SQL.** Abrí un archivo `.sql` después de instalar `sqls`. Si querés completar nombres de tablas y columnas con el esquema real, configurá una conexión en `~/.config/sqls/config.yml` o en `$XDG_CONFIG_HOME/sqls/config.yml` si usás ese directorio. [Configuración de sqls](https://github.com/sqls-server/sqls#db-configuration)

Usá `:Lazy profile` para revisar el costo de carga. Los plugins se declaran en `lua/plugins/`. Al sumar uno, elegí el comando, atajo, evento o tipo de archivo que activa la función.
