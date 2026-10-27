# Estrategia de versionamiento de Bearstards Wiki

## 1. Propósito y alcance

Esta estrategia establece cómo se registran, revisan e integran los cambios de Bearstards Wiki, una aplicación Flutter de consulta complementaria al videojuego, dirigida a Android e iOS.

Cubre código, pruebas, documentación, configuración de las plataformas móviles y recursos gráficos. Su propósito es mantener un historial trazable, permitir la revisión del trabajo y recuperar estados anteriores sin perder las aportaciones del equipo.

## 2. Herramienta y plataforma seleccionadas

Se utiliza **Git** como sistema de control de versiones y **GitHub** como plataforma para alojar y consultar el repositorio remoto.

Repositorio configurado: [Bearstards_Movil_Application](https://github.com/CrazyBread7364/Bearstards_Movil_Application).

Git se seleccionó porque permite:

- Registrar versiones identificadas por un hash y revisar las diferencias entre ellas.
- Trabajar en ramas para desarrollar y verificar cambios antes de integrarlos.
- Crear commits localmente, incluso sin conexión.
- Consultar autores, fechas y descripciones de los cambios.
- Recuperar una versión anterior o revertir un cambio conservando el historial.

GitHub se seleccionó porque permite centralizar el repositorio compartido y consultar desde una interfaz web sus ramas, commits y diferencias. Esto facilita la colaboración del equipo y la presentación de evidencias académicas del proyecto.

Git y GitHub tienen funciones diferentes: un commit registra un cambio en el repositorio local; un push lo envía al remoto. Un commit local no implica que el cambio ya esté disponible en GitHub.

## 3. Organización de ramas

Se adopta un flujo con ramas de trabajo, una rama de integración y una rama estable, utilizando los nombres existentes en el repositorio.

| Rama | Responsabilidad | Regla de trabajo |
| --- | --- | --- |
| `main` | Conservar versiones estables que el responsable haya aceptado. | Recibe cambios revisados y verificados. |
| `development` | Integrar los cambios de desarrollo antes de estabilizarlos. | Recibe las ramas de trabajo aprobadas. |
| Ramas de trabajo | Desarrollar una mejora o corregir un problema con un objetivo definido. | Los cambios y commits se preparan aquí. |

El nombre de una rama de trabajo sigue el formato:

```text
tipo/responsable/descripcion-breve
```

Ejemplos:

- `feat/gmd/pulir-diseno-y-funcionalidad`: rama actual de mejoras.
- `fix/gmd/corregir-navegacion`: ejemplo para una corrección futura.
- `docs/gmd/plan-de-pruebas`: ejemplo para documentación futura.
- `test/gmd/recorridos-moviles`: ejemplo para pruebas futuras.

Las nuevas ramas parten de `development` cuando esta contiene la base requerida. Si una tarea depende de cambios todavía no integrados de otra rama, se identifica y comunica esa dependencia antes de elegir su punto de partida.

La rama actual continúa el trabajo de diseño previo. No se recrea ni se reescribe su historial para adaptar retroactivamente el trabajo a esta estrategia.

El flujo de integración previsto es:

```text
rama de trabajo → revisión del responsable → development → validación de versión → main
```

Este flujo es la política acordada para las siguientes integraciones. No acredita que las integraciones, protecciones de GitHub o publicaciones ya se hayan realizado.

## 4. Política de commits

Cada commit debe representar un cambio coherente que pueda revisarse y explicarse por sí mismo. Cuando un cambio necesita modificar varios archivos para quedar consistente, esos archivos se registran juntos.

Se utiliza la convención:

```text
tipo(ambito): descripcion breve
```

| Tipo | Uso |
| --- | --- |
| `feat` | Incorporar o mejorar una función. |
| `fix` | Corregir un comportamiento incorrecto. |
| `refactor` | Reorganizar la implementación. |
| `test` | Añadir o mejorar pruebas y sus evidencias. |
| `docs` | Crear o actualizar documentación. |
| `chore` | Mantener configuración, recursos o plataformas. |

Ejemplos existentes en el historial:

- `refactor(wiki): introduce feature-first MVVM and mobile design system`.
- `test(design): add reproducible mobile screen previews`.
- `chore(platforms): retain Android and iOS targets only`.

Antes de registrar un commit se revisan el estado del repositorio y las diferencias de los archivos seleccionados. Se incluyen únicamente los archivos correspondientes al cambio; los trabajos ajenos o no relacionados se preservan.

Los mensajes históricos se conservan. La convención se aplica a los nuevos commits.

El mínimo académico de 30 commits se alcanza mediante entregas reales: funcionalidades, correcciones, pruebas, documentación y mejoras de calidad. No se crean commits vacíos ni se divide artificialmente una misma modificación para incrementar el conteo.

## 5. Responsabilidades y publicación

**El responsable del proyecto revisa el código y realiza todos los pushes. El agente no ejecuta push en ningún momento.**

| Actividad | Responsable |
| --- | --- |
| Implementar, documentar y verificar los cambios solicitados | Agente o colaborador asignado |
| Revisar diferencias y preparar commits locales en la rama de trabajo | Agente o colaborador asignado |
| Revisar y aceptar el código antes de publicarlo | Responsable del proyecto |
| Enviar ramas, commits o etiquetas al remoto | Exclusivamente el responsable del proyecto |
| Autorizar y realizar integraciones hacia `development` y `main` | Responsable del proyecto |

El agente entrega los hashes de los commits locales, un resumen del cambio, las comprobaciones realizadas y cualquier limitación pendiente. Esa entrega no autoriza una publicación.

El agente tampoco publica etiquetas ni modifica el remoto para eludir esta revisión. Las operaciones de publicación e integración quedan bajo control del responsable.

## 6. Revisión e integración

Antes de aceptar una rama se comprueba:

1. Que los cambios respeten el alcance de la wiki y las plataformas Android e iOS.
2. Que el código y los assets correspondan al objetivo de la rama.
3. Que las comprobaciones sean adecuadas al cambio.
4. Que la documentación y las evidencias necesarias estén actualizadas.
5. Que los conflictos estén resueltos y se hayan revisado sus resultados.
6. Que el responsable haya revisado y aceptado el código.

Para cambios de implementación se emplean `flutter analyze` y las pruebas pertinentes con `flutter test`. Los cambios visuales requieren revisar capturas o ejecutar los recorridos afectados. Para una versión candidata se verifica también la compilación móvil; iOS requiere un entorno con macOS y Xcode.

Los cambios solo de documentación se verifican mediante revisión de contenido, enlaces y diferencias; no requieren recompilar la aplicación.

La integración debe conservar los commits originales para mantener la trazabilidad de la bitácora académica. Se propone merge sin squash. El responsable decide cuándo realizar esa integración después de su revisión.

Las protecciones de ramas o automatizaciones que se incorporen posteriormente deberán documentarse como configuradas solo después de verificarlas. Esta estrategia no modifica la configuración de GitHub.

## 7. Numeración de versiones y recuperación

La versión de la app se configura en `pubspec.yaml` como:

```text
MAJOR.MINOR.PATCH+BUILD
```

- **MAJOR:** cambio que rompe compatibilidad con una versión anterior.
- **MINOR:** incorporación de funciones compatibles.
- **PATCH:** correcciones o ajustes compatibles.
- **BUILD:** identificador numérico que aumenta para cada compilación distribuida.

El valor configurado actualmente es `1.0.0+1`; ese valor no acredita por sí mismo una versión publicada o aprobada. Los commits cotidianos no requieren incrementar la versión de distribución.

Cuando el responsable apruebe una entrega, podrá identificar el commit exacto con una etiqueta de versión, por ejemplo `v1.0.0`, y registrar el número de compilación asociado. La creación y publicación de esa entrega quedan a su cargo.

Para deshacer un cambio ya compartido se prioriza `git revert`, que registra la corrección sin borrar el historial. No se reescribe el historial compartido ni se utiliza force push como parte de este flujo.

Se versionan fuentes, pruebas, documentación, recursos y configuraciones necesarias. Se excluyen secretos, credenciales, cachés y salidas generadas en `build/`. Las capturas seleccionadas en `designs/previews/` sí se conservan como evidencia revisable.

## 8. Bitácora y evidencia académica

La bitácora se obtiene del historial real de la rama que se presentará. Cada registro debe contener hash, fecha, autor, descripción y, cuando el responsable lo publique, su enlace correspondiente en GitHub.

Comandos locales de consulta:

```sh
git branch --show-current
git status --short
git log --reverse --date=iso-strict --pretty=format:"%h | %ad | %an | %s"
git rev-list --count HEAD
git rev-list --count --no-merges HEAD
```

El conteo considera commits únicos del historial alcanzable desde la rama seleccionada. No se suman los conteos de varias ramas que comparten los mismos commits. Se distingue el trabajo registrado localmente de la evidencia disponible en GitHub.

Este documento cubre la estrategia y justificación de herramientas del punto 1.a de la rúbrica. La presentación de la bitácora (1.b) y el mínimo de 30 commits (1.c) deben comprobarse por separado en la entrega final.
