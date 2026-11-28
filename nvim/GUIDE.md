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

### Formato manual

El formato se ejecuta con `Space f`: en modo normal formatea el archivo y, en modo visual, la selección. Guardar con `Space w` o `:w` no formatea ni elimina espacios finales. Después de formatear, guardá cuando quieras escribir los cambios en disco.

| Lenguajes | Formateador |
| --- | --- |
| JavaScript / Node.js, TypeScript y React (`.jsx`, `.tsx`) | Prettier |
| HTML, CSS, SCSS, Less, JSON y JSONC | Prettier |
| Java | google-java-format |
| SQL y MySQL | sql-formatter |

Los ejecutables se gestionan con Mason. Para instalarlos en otra máquina:

```vim
:MasonInstall prettier google-java-format sql-formatter@15.9.0
```

Conform busca el Prettier del proyecto cuando está disponible y respeta su configuración, como `.prettierrc`. Para SQL, podés definir el dialecto y el estilo en `.sql-formatter.json`; no hace falta una conexión a la base de datos para formatear. El tipo de archivo `mysql` usa el dialecto MySQL.

Conform se carga al usar el atajo o `:ConformInfo`, que muestra los formateadores disponibles para el archivo actual. Si falta el ejecutable configurado y el LSP ofrece formato, se usa como alternativa.

Para formatear los bloques modificados del archivo actual, usá `Space gf` en modo normal. Compara el buffer, incluidos los cambios sin guardar, con el índice de Git. Procesa las líneas agregadas o modificadas que todavía no están staged; omite las eliminaciones puras. El archivo debe estar seguido por Git.

El formato se aplica por rangos: algunos formateadores pueden ajustar la instrucción o bloque que contiene la línea modificada. Revisá el resultado con `Space gd` y guardá con `Space w`. El atajo no guarda ni agrega cambios al stage. Para un archivo nuevo que Git aún no sigue, usá `Space f`.

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

En Telescope, presioná `Enter` para abrir el resultado elegido y `Esc` para cerrar directamente el panel. `Ctrl+q` envía los resultados a quickfix, donde podés recorrerlos con `:cnext` y `:cprev`. Usá `:Telescope` para descubrir otros buscadores.

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

1. Poné el cursor sobre un símbolo. Usá `gd` para ir a su definición o `grr` para abrir sus referencias en Telescope con vista previa. La lista muestra el nombre del archivo, la línea y la columna. Podés escribir para filtrar los resultados. `Enter` salta a la referencia elegida y cierra el panel. `Esc` lo cierra sin moverte.
2. Presioná `Space rn`, escribí el nuevo nombre y confirmá con `Enter`. El servidor actualiza la declaración y las referencias que reconoce en el proyecto. Revisá los cambios y guardá los buffers modificados con `:wall`.
3. Presioná `Space a` sobre un símbolo o desde una selección visual para ver sus acciones de código en un menú compacto de Telescope. Escribí para filtrar, recorré las opciones con `Ctrl+n` / `Ctrl+p` o las flechas y elegí con `Enter`; el menú se cierra al aplicar la acción. `Esc` cierra sin aplicar cambios. El servidor decide qué acciones ofrece, como implementar métodos, generar constructores o extraer una función a partir de las líneas seleccionadas.

Para resaltar las referencias del símbolo en el archivo actual, poné el cursor sobre el nombre y pulsá `Space rh`. `Space n` quita el resaltado.

Al detener el cursor sobre una palabra durante unos 300 ms, se resaltan sutilmente sus coincidencias completas en el archivo. El resaltado se limpia al mover el cursor, entrar en modo insertar o pulsar `Space n`.

En modo insertar, usá `Ctrl+x Ctrl+o` para pedir sugerencias. También podés usar `Alt+Space`. El menú se abre automáticamente con los caracteres de activación del servidor, como `.` en TypeScript. Recorré las sugerencias con `Tab` y `Shift+Tab` y aceptá la seleccionada con `Enter`. En un snippet, `Tab` y `Shift+Tab` también mueven el cursor entre campos.

### Imports y acciones de desarrollo

Estos atajos usan el servidor del lenguaje del proyecto:

| Atajo | Acción |
| --- | --- |
| `Space ia` | Agregar imports faltantes en JavaScript, TypeScript, React o Java |
| `Space io` | Ordenar y organizar imports |
| `Space iu` | Eliminar imports sin usar en JavaScript, TypeScript y React |
| `Space cf` | Aplicar las correcciones de archivo que ofrece el servidor |
| `Space re` | Elegir con Telescope una extracción de variable, función o método; también desde una selección visual |
| `Space rn` | Renombrar un símbolo y sus referencias |

En Java, `Space ia` y `Space io` usan **Organize Imports** de JDTLS: agrega imports resolubles, ordena y elimina los innecesarios. Si hay varios tipos con el mismo nombre, elegí el paquete correcto. En TypeScript, `Space io` ordena los imports y `Space iu` elimina los que no se usan.

Para una corrección puntual, poné el cursor sobre el error y usá `Space a`; también ofrece generar constructores, implementar métodos o cambiar una firma cuando el servidor lo permite. `Space cf` ejecuta las acciones `source.fixAll` disponibles, por ejemplo convertir una función con `await` en `async`. Para las correcciones de ESLint, seguí usando `Space ef`. Los atajos directos aplican una acción única; si hay varias, elegí una en Telescope. La integración usa `telescope-ui-select.nvim` y se carga con Telescope al conectarse el primer LSP o al abrir un buscador.

Los imports dependen de que el servidor haya indexado el proyecto y pueda resolver sus dependencias. Revisá los cambios y guardá con `Space w` o `:wall` si se modificaron varios archivos.

### Renombrar o mover archivos y actualizar referencias

[nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations) conecta el árbol con los servidores de lenguaje. Se carga al abrir el árbol.

1. Abrí un archivo del proyecto y esperá a que su servidor termine de iniciar e indexar.
2. Usá `Space E` para localizarlo en el árbol y `r` para cambiar su nombre. Con `u` podés editar la ruta completa para moverlo a otra carpeta.
3. El servidor actualiza los imports y referencias que reconoce. Por ejemplo, al renombrar `math.ts` a `greeting.ts`, un import desde `./math` pasa a `./greeting`, incluso en archivos que estaban cerrados.
4. El nombre cambia en disco. Las ediciones de referencias quedan en buffers para revisarlas; guardalas con `:wall`.

La actualización depende del soporte del servidor y se activa al renombrar desde el árbol de Neovim. Para renombrar variables, funciones o clases, usá `Space rn` sobre el símbolo.

### Sugerencias de IA con GitHub Copilot

Copilot se carga al invocar `:Copilot`. Necesita Node.js 22 o posterior y una cuenta de GitHub con acceso a Copilot. Para usarlo por primera vez, ejecutá `:Copilot auth` y completá el inicio de sesión. En sesiones siguientes, activalo con `:Copilot enable`. Copilot usa el contexto del código para generar sugerencias en línea. Aceptalas con `Alt+l` y desactivá Copilot con `:Copilot disable`.

## Edición y varios cursores

El autocierre lo hace [nvim-autopairs](https://github.com/windwp/nvim-autopairs), que se carga al entrar en modo insertar. Escribir una comilla, paréntesis, llave o corchete de apertura agrega su cierre y deja el cursor entre los dos.

Presioná `Enter` entre `()`, `{}` o `[]` para abrir una línea interior indentada y dejar el cierre en su propia línea. La indentación usa Tree-sitter y las reglas del lenguaje, respetando la configuración del archivo. Por ejemplo, dentro de un método Java (`|` representa el cursor):

```java
class Example {
  void run() {
    |
  }
}
```

Si hay una sugerencia de autocompletado seleccionada, `Enter` la acepta. Sin una sugerencia seleccionada, inserta el salto de línea. No hace falta instalar otro plugin para este comportamiento.

Para cambiar el formato de un texto, seleccioná con `v`, pulsá `Space C` y elegí un estilo con `Enter`. Por ejemplo, `nombre de usuario` se puede convertir en `nombreDeUsuario`, `nombre_de_usuario`, `Nombre De Usuario` o `nombre-de-usuario`.

Para modificar coincidencias de texto en el mismo archivo, poné el cursor sobre una palabra y presioná `Ctrl+n` una vez por cada coincidencia que quieras seleccionar. También podés empezar con texto seleccionado en modo visual. Presioná `c`, escribí el reemplazo y pulsá `Esc` para terminar de insertar y otra vez para salir de Visual Multi.

Usá `\\A` (dos barras invertidas y una A mayúscula) para seleccionar todas las coincidencias. Agregá un cursor en la línea de abajo con `Space mj` o `Ctrl+↓`, y en la de arriba con `Space mk` o `Ctrl+↑`. Para cambiar el nombre de un símbolo y sus referencias, usá `Space rn`.

Con varias coincidencias seleccionadas, pulsá `Space C` y después `c` para camelCase, `s` para snake_case, `t` para Title Case, `P` para PascalCase o `-` para kebab-case. Cada selección se convierte por separado.

## Git

Usá `Space G` desde un archivo del repositorio para abrir LazyGit. Desde ahí podés revisar cambios, preparar commits y gestionar ramas. Pulsá `q` para volver al editor.

En el panel de archivos de LazyGit, `e` oculta la ventana de LazyGit y abre el archivo seleccionado como buffer en la ventana principal de Neovim. Desde el diff, también conserva la línea seleccionada. Volvé a LazyGit con `Space G`. `o` usa la aplicación asociada del sistema operativo.

Usá `:Git` para abrir Fugitive, `Space gd` para comparar el archivo actual con HEAD y `Space gH` para ver su historial. Podés ejecutar `:Git pull` y `:Git push` desde el editor. Para navegar los bloques de cambios en el archivo, usá `[c` y `]c` con Gitsigns.

`Space gf` formatea los bloques con cambios sin stage del archivo actual. Los cambios que solo están staged quedan fuera de esta comparación.

Para comparar el archivo con otra rama, pulsá `Space gD` y escribí, por ejemplo, `develop` u `origin/develop`. `Tab` completa los nombres disponibles y `Enter` abre la comparación. `Esc` cancela.

En archivos de Git, la barra de estado muestra el autor y la fecha y hora del último cambio de la línea actual. `Sin commit` indica que la línea tiene cambios pendientes. Usá `Space gb` para mostrar u ocultar ese dato.

## Flujos por lenguaje

- **Node.js, TypeScript y React.** Abrí el proyecto desde la raíz e instalá sus dependencias. Un mismo servidor atiende `.js`, `.jsx`, `.ts` y `.tsx`, con el `tsconfig.json` o `jsconfig.json` del proyecto para resolver el entorno y los imports. `Space x` ejecuta el archivo JavaScript actual con Node. Para iniciar un proyecto React, corré su script habitual en la terminal integrada, que se abre con `Ctrl+\`.
- **ESLint.** Instalá ESLint como dependencia del proyecto y usá la configuración del repositorio. Cuando se conecte el servidor, `Space ef` aplica las correcciones automáticas disponibles.
- **HTML, CSS y JSON.** Abrí archivos de estos tipos para activar sus servidores. Usá completado, diagnósticos y el formateador del proyecto desde los mismos atajos.
- **Java.** Abrí un archivo del proyecto Maven o Gradle y dejá que JDTLS importe e indexe el proyecto la primera vez. Si se demora al iniciar, verificá que el JDK con el que arranca JDTLS sea 21 o posterior. En una clase de prueba de Maven, `Space jt` ejecuta esa clase desde el módulo que contiene su `pom.xml` con el comando `mvn`.
- **SQL.** Abrí un archivo `.sql` después de instalar `sqls`. Si querés completar nombres de tablas y columnas con el esquema real, configurá una conexión en `~/.config/sqls/config.yml` o en `$XDG_CONFIG_HOME/sqls/config.yml` si usás ese directorio. [Configuración de sqls](https://github.com/sqls-server/sqls#db-configuration)

Usá `:Lazy profile` para revisar el costo de carga. Los plugins se declaran en `lua/plugins/`. Al sumar uno, elegí el comando, atajo, evento o tipo de archivo que activa la función.
