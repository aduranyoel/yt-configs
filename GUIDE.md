# Guía de uso diario — Neovim

**Leader key:** `Space`

> Esta guía cubre las operaciones más frecuentes en el desarrollo día a día.
> Para el listado completo de atajos customizados, ver [KEYMAPS.md](./KEYMAPS.md).

---

## Modos

Neovim tiene modos. Siempre sabé en cuál estás (lo muestra la statusline).

| Modo | Cómo entrar | Para qué |
|------|-------------|----------|
| **Normal** | `Esc` / `Ctrl+C` | Navegar y ejecutar comandos |
| **Insert** | `i` `a` `o` `I` `A` `O` | Escribir código |
| **Visual** | `v` `V` `Ctrl+V` | Seleccionar texto |
| **Command** | `:` | Ejecutar comandos de Vim |

---

## Navegación dentro del archivo

### Movimiento básico
```
h j k l       ← ↓ ↑ →  (movimiento por caracteres)
w             saltar al inicio de la próxima palabra
b             saltar al inicio de la palabra anterior
e             saltar al final de la próxima palabra
W B E         igual que w/b/e pero ignorando puntuación
```

### Primera y última línea
```
gg            ir a la primera línea del archivo
G             ir a la última línea del archivo
:42           ir a la línea 42
42G           ir a la línea 42
```

### Inicio y fin de línea
```
0             inicio de línea (posición 0)
^             primer caracter no-vacío de la línea
$             fin de línea
```

### Mitad de pantalla y scroll
```
Ctrl+J        scroll 10 líneas abajo  (custom)
Ctrl+K        scroll 10 líneas arriba (custom)
zz            centrar la pantalla en el cursor
zt            cursor al top de pantalla
zb            cursor al bottom de pantalla
Ctrl+D        bajar media pantalla
Ctrl+U        subir media pantalla
```

### Saltar a la declaración o referencia
```
gd            ir a la definición      (LSP)
gy            ir al tipo              (LSP)
gi            ir a la implementación  (LSP)
gr            ver todas las referencias (LSP)
K             ver documentación del símbolo bajo el cursor
Ctrl+O        volver atrás en el historial de saltos
Ctrl+I        avanzar en el historial de saltos
Leader+-      volver atrás  (alias de Ctrl+O)
Leader+=      avanzar       (alias de Ctrl+I)
```

### Salto rápido con easymotion
```
Leader+s      buscar 2 caracteres y saltar a cualquier lugar visible
```

### Matching bracket
```
%             saltar al bracket/paréntesis/llave que hace par
```

---

## Navegación entre archivos

### File explorer
```
Leader+e      abrir explorer y revelar el archivo actual
Leader+E      toggle explorer
```

### Buscar archivo por nombre
```
Leader+p      buscar archivo en el proyecto (FZF fuzzy)
Leader+fs     ídem (alias)
```

### Buscar texto en todo el proyecto
```
Leader+rg     buscar texto con ripgrep (abre resultados navegables)
```

### Entre buffers (archivos abiertos)
```
Tab           siguiente buffer
Shift+Tab     buffer anterior
Alt+→         siguiente buffer
Alt+←         buffer anterior
Leader+bf     buscar entre buffers abiertos (FZF)
Leader+bd     cerrar buffer actual
```

### Historial reciente
```
Leader+bf     muestra buffers abiertos — el más cercano al reciente está arriba
```

---

## Buscar y reemplazar

### Buscar en el archivo actual
```
/texto        buscar "texto" hacia adelante
?texto        buscar "texto" hacia atrás
n             siguiente resultado
N             resultado anterior
*             buscar la palabra bajo el cursor (hacia adelante)
#             buscar la palabra bajo el cursor (hacia atrás)
:noh          limpiar el highlight de búsqueda
```

### Reemplazar en el archivo actual
```
:%s/viejo/nuevo/g         reemplazar todas las ocurrencias en el archivo
:%s/viejo/nuevo/gc        reemplazar con confirmación (y/n/a/q)
:10,20s/viejo/nuevo/g     reemplazar solo entre líneas 10 y 20
```

### Reemplazar en selección visual
```
1. Seleccionar con V o v
2. :s/viejo/nuevo/g       (el rango se completa solo con '<,'>)
```

### Reemplazar en todo el proyecto
```
Leader+rg     buscar con ripgrep → navegar resultados
              Tip: usar :cdo s/viejo/nuevo/g | update  para reemplazar en todos los archivos del quickfix
```

---

## Deshacer y rehacer
```
u             deshacer
Ctrl+R        rehacer
U             deshacer todos los cambios en la línea actual
```

---

## Edición rápida

### Insertar texto
```
i             insertar antes del cursor
a             insertar después del cursor
I             insertar al inicio de la línea
A             insertar al final de la línea
o             nueva línea abajo y entrar en insert
O             nueva línea arriba y entrar en insert
```

### Modificar una palabra / línea
```
ciw           cambiar la palabra bajo el cursor (change inner word)
caw           cambiar la palabra + espacios alrededor
ci"           cambiar el contenido dentro de comillas dobles
ci(           cambiar el contenido dentro de paréntesis
ci{           cambiar el contenido dentro de llaves
C             cambiar desde el cursor hasta el fin de línea
cc            cambiar toda la línea
```

### Borrar
```
x             borrar caracter bajo el cursor
dd            borrar línea completa
dw            borrar hasta el fin de la palabra
diw           borrar la palabra bajo el cursor
D             borrar desde el cursor hasta el fin de línea
d$            ídem que D
```

### Copiar y pegar
```
yy            copiar línea completa (yank)
yw            copiar hasta el fin de la palabra
yiw           copiar la palabra bajo el cursor
y$            copiar hasta el fin de línea
p             pegar después del cursor
P             pegar antes del cursor
Ctrl+C        copiar selección al clipboard del sistema (visual mode)
```

### Mover líneas
```
K             (visual) mover selección hacia arriba
J             (visual) mover selección hacia abajo
```

### Indentación
```
>>            indentar línea actual
<<            des-indentar línea actual
>             (visual) indentar selección
<             (visual) des-indentar selección
=             auto-indentar selección (visual) o línea actual
gg=G          auto-indentar todo el archivo
```

### Repetir la última acción
```
.             repetir la última operación de edición
```

---

## Selección visual

```
v             modo visual (por caracteres)
V             modo visual lineal (líneas completas)
Ctrl+V        modo visual de bloque (columnas)
viw           seleccionar la palabra bajo el cursor
vi"           seleccionar contenido dentro de comillas
vi(           seleccionar contenido dentro de paréntesis
vi{           seleccionar contenido dentro de llaves
vit           seleccionar contenido dentro de tag HTML/JSX
```

---

## Comentarios
```
Ctrl+/        toggle comentario (línea o selección visual)
```

---

## Multi-cursor
```
Ctrl+N        seleccionar palabra bajo cursor, agregar cursor en siguiente ocurrencia
Ctrl+N (x2)   continuar seleccionando más ocurrencias
```

---

## Splits y ventanas

### Abrir splits
```
:sp           split horizontal
:vsp          split vertical
:sp archivo   abrir archivo en split horizontal
```

### Navegar entre splits
```
Ctrl+W h      ir al split de la izquierda
Ctrl+W l      ir al split de la derecha
Ctrl+W j      ir al split de abajo
Ctrl+W k      ir al split de arriba
Leader+Ctrl+H/J/K/L   navegar splits (Tmux-aware)
```

### Redimensionar
```
Leader+h      achicar el split actual (ancho -20)
Leader+l      agrandar el split actual (ancho +20)
```

### Cerrar
```
:q            cerrar split/ventana
Leader+q      ídem
```

---

## Autocompletado (nvim-cmp)

```
(escribir)    el menú aparece automáticamente
Tab           siguiente opción / expandir snippet
Shift+Tab     opción anterior
Enter         confirmar selección
Alt+Space     forzar apertura del menú manualmente
Ctrl+E        cerrar el menú sin confirmar
Ctrl+B        scroll docs arriba
Ctrl+F        scroll docs abajo
```

---

## Diagnósticos y errores

```
[g            error/warning anterior en el archivo
]g            error/warning siguiente en el archivo
Space+a       ver todos los diagnósticos del proyecto
Leader+a      code action (quick fix, extract, etc.)
K             ver descripción del error bajo el cursor
```

---

## Formateo y refactoring

```
Leader+f      formatear selección (o archivo completo)
Leader+rn     renombrar símbolo en todo el proyecto
Leader+a      ver code actions disponibles (extract method, etc.)
Leader+ef     ESLint fix del archivo
```

---

## Terminal integrado

```
Ctrl+\        abrir/cerrar terminal horizontal
Leader+tf     abrir/cerrar terminal flotante
Leader+ai     abrir Claude Code
i             (dentro del terminal) entrar en modo insert para escribir
Ctrl+\  N     (dentro del terminal) salir al modo normal del terminal
```

---

## Git

```
Leader+gg     abrir lazygit  → navegación visual de todo git
Leader+gd     ver diff del archivo actual vs HEAD
Leader+gh     historia de commits del archivo actual
Leader+gm     ver conflictos de un merge
Leader+gx     cerrar diffview
```

### Dentro de lazygit
```
s             stage/unstage archivo
c             commit
P             push
p             pull
b             gestionar branches
?             ver todos los atajos de lazygit
q             cerrar lazygit
```

---

## Guardar y salir

```
Leader+w      guardar
Leader+q      salir
Leader+Q      salir forzado (sin guardar)
Leader+ur     descartar TODOS los cambios del archivo (revert to saved)
:wq           guardar y salir
:wa           guardar todos los archivos abiertos
Leader+so     recargar la configuración de nvim
```

---

## Tips del día a día

**Buscar y editar todos los que coinciden en el proyecto:**
1. `Leader+rg` → buscar el término
2. Los resultados van al quickfix list
3. `:cdo s/viejo/nuevo/g | update` → aplica el reemplazo en todos los archivos

**Ir a una clase/función rápido:**
1. `Leader+rg` → buscar por nombre en todo el proyecto
2. `gi` → ir a la implementación directamente desde el cursor

**Ver qué hace una función sin perder el lugar:**
1. Posicionar cursor sobre el nombre
2. `K` → muestra la documentación en float
3. `gi` → ir a la implementación (`Ctrl+O` para volver)

**Cambiar todos los nombres de una variable en el archivo:**
1. Posicionar cursor sobre la variable
2. `<Leader>rn` → rename → escribe el nuevo nombre → `Enter`
3. Aplica en todo el proyecto (no solo el archivo)

**Extraer un método (Java/TypeScript):**
1. Seleccionar el bloque de código en visual mode (`V`)
2. `<Leader>a` → elegir "Extract Method/Function"

**Navegar entre errores rápido:**
```
[g  →  ]g  →  [g  →  ]g ...   (loop entre todos los errores del archivo)
```
