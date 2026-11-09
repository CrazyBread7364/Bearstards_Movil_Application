# Contexto de trabajo: Bearstards Wiki (app móvil de Little Bearstards)

Resumen de la conversación de trabajo, del 30 de octubre al 4 de noviembre de 2026. Sirve para retomar el proyecto sin releer todo. Los datos salen del repositorio, de los documentos del equipo y de lo ejecutado en la sesión.

## 1. El proyecto

- **Producto:** Little Bearstards (título alterno Bastardosos), videojuego de PC de sigilo PvP 1 contra 1 con deducción social. Dos jugadores controlan osos de peluche, se esconden entre osos NPC casi idénticos y eliminan al rival con la aguja de coser o la pistola de dardos.
- **Equipo:** Turbo Studios, UTCH, grupo IDGS101N. Integrantes: Angel David Arras Orozco (Scrum Master), Guillermo Martínez Delgadillo (Product Owner, el usuario), Víctor Hugo Baeza Rocha (modelado 3D), Dylan Muñoz Flores, Jesús Arturo Castilla González y Ángel Guillermo González Gómez.
- **Ecosistema de tres componentes:**
  - Videojuego en Unity 6.6 (`KonigAstaroth/Bearstards`, rama `develop`).
  - PWA de ranking con React y Django (`StingerBlade/BEARSTARDS_PWA`), sitio `littlebearstards.com`.
  - **App móvil Flutter (este repo):** `CrazyBread7364/Bearstards_Movil_Application`. Es una wiki de consulta sin conexión para Android e iOS.
- **Fecha de entrega del MVP:** 20 de noviembre de 2026.
- **Materia de este repo:** Desarrollo Móvil Integral.

## 2. Requerimientos del profesor y estado

| Requerimiento | Estado |
| --- | --- |
| 1a. Plataforma de versionamiento y justificación | Cubierto: `docs/versioning-strategy.md` (Git y GitHub) |
| 1b. Bitácora de commits | Pendiente: generar `docs/commit-log.md` al final con `git log` |
| 1c. Mínimo 30 commits | Pendiente: había 19 al 30/oct; faltan unos 11 |
| 2. Plan de pruebas (a–g) | Hecho: `docs/test-plan.md` |
| 3. Suite de pruebas (8 columnas) | Hecho: `docs/test-suite.md`, con 14 casos aprobados y 9 manuales pendientes |
| 4. App Flutter con ≥ 4 funciones | Cubierto con 6 secciones de lectura; se quiere reforzar con funciones interactivas |

## 3. Reglas de trabajo acordadas

- Cada implementación va en **su propia rama**, con nombre `tipo/gmd/descripcion` (por ejemplo `feat/gmd/...`, `fix/gmd/...`, `chore/gmd/...`).
- Cada rama se divide en una **lista numerada de commits**, para avanzar despacio y de forma ordenada.
- **El agente prepara los cambios y verifica; el usuario prueba, hace los commits y todos los push.** El agente no hace push ni commits. (Antes el agente hizo dos commits locales con permiso explícito; el flujo cambió después.)
- Mensajes de commit con formato `tipo(ambito): descripcion breve`. Tipos: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`. Sin líneas de atribución (`Co-Authored-By`).
- Se probó un `attribution` vacío en `C:\Users\memo\.claude\settings.json` y se revirtió; el archivo quedó como estaba.
- Flujo de integración: rama de trabajo, revisión del responsable, `development`, validación de versión, `main`.
- Entorno: Flutter 3.47.6 stable y Dart 3.13.5 (`toolchain.json`). Preparación con `dart tool/verify_environment.dart` y `flutter pub get --enforce-lockfile`. Comprobaciones con `flutter analyze --no-pub` y `flutter test --no-pub`.

## 4. Estado de las ramas

Al 4 de noviembre de 2026:

| Rama | Contenido |
| --- | --- |
| `main` | Proyecto Flutter recién creado (`0593577`) |
| `development` (remota) | Wiki de diseño más la rama chore integrada (`3c3402a`) |
| `chore/gmd/dependencias-reproducibles` | Lockfile, `toolchain.json`, `tool/verify_environment.dart`, `CONTRIBUTING.md`, `docs/versioning-strategy.md`, `docs/reproducible-environment.md` |
| `feat/gmd/funciones-interactivas` | Mis dos commits locales de pruebas (`9a2f1a2` plan, `da1a927` suite). **No están en `origin/development`**. Todavía sin funciones |
| `feat/gmd/analisis-little-bearstards` | Nombre al que renombré la rama de la sesión. Hoy apunta al merge `3c3402a` |
| **`feat/gmd/rediseno-toon`** | Rama actual. Sale de `origin/development`. Contiene el paso 1 del rediseño sin commitear |

El código vive en un worktree aparte: `.claude/worktrees/little-bearstards-analysis-d3ba8f`. Una misma rama no puede estar abierta en dos worktrees a la vez.

## 5. Análisis de la wiki (hallazgos)

### Arquitectura
Feature-first con MVVM (`docs/architecture.md`):
- `lib/main.dart` solo arranca.
- `lib/app/`: raíz de composición, repositorio inyectado y router.
- `lib/core/`: tema, widgets reutilizables y registro de assets.
- `lib/features/wiki/`: `domain/` (modelos, contrato `WikiRepository`), `data/` (`LocalWikiRepository`) y `presentation/` (pantallas, ViewModels, widgets).
- Solo Sigilo y Fases tienen ViewModel. El mapeo de arte y color vive en `WikiPresentation` con `switch` exhaustivos.

### Contenido frente a las reglas del MVP (Portafolio funcional)
Coincide en todo lo verificado:
- Aguja: 25 de daño, 4 golpes (5 con casco).
- Pistola: 50 de daño, 6 dardos sin recarga, 2 impactos (3 con casco), aparece en la fase 2.
- Casco: vida máxima 125, no se acumula, se pierde al ser eliminado.
- Hilo: +25 de vida sin pasar del máximo.
- Puntos: +200 eliminación, +350 con sigilo, +400 con dardos, −50 por golpear a un NPC.
- Golpe a la cabeza elimina al instante, incluso con casco.
- Reaparición con 100 de vida. Tres fases de igual duración. En la fase 3 la mitad de los NPC regresa a los estantes.
- Desempate: más eliminaciones al rival; si sigue igual, empate.

### Discrepancias y problemas encontrados
1. **Casco 125 contra 150:** otro documento (Evidencia 2) dice 150. La wiki conserva 125 y lo documenta en `docs/mvp-content.md`. Decisión pendiente del Product Owner; la Evidencia 2 no fue proporcionada.
2. **Empate no soportado en el contrato:** el portafolio define victoria, derrota o empate, pero el esquema `resultado-partida.schema.json` solo admite `victoria` y `derrota`.
3. **Fórmula del costo de oportunidad** en el documento de negocio: escribe `9 × 4.345`, pero el resultado de USD 8,078 corresponde a `9 ÷ 4.345` meses.
4. **La aguja:** en el Portafolio funcional es un objeto recogible; la PWA dice "siempre disponible"; la wiki no explica cómo se obtiene.
5. **Fin de partida y munición** del juego en Unity: dardos ilimitados y la partida no termina al agotarse el tiempo (pruebas P-01 y P-04). La wiki documenta la regla prevista.
6. **El documento de negocio dice que el contenido de la wiki está en JSON;** en el código está escrito en Dart.
7. **El documento de negocio dice que la wiki cubre "controles";** no hay pantalla de controles.
8. **El documento de negocio afirma que el pipeline compila un APK;** no existe `.github/` en el repo.
9. **Portada:** enlaza Personajes, Sigilo, Arsenal y La Juguetería, pero no Objetos. Objetos solo está en la navegación inferior; Personajes no.

### Deuda del repositorio
- No hay CI (`.github/`), plantilla de PR ni `CODEOWNERS`.
- Unos 80 MB de imágenes sin usar: `assets/images/mvp/` (70.6 MB) y `assets/images/wiki_v2/` (9.5 MB). Las imágenes usadas son PNG y pesan unos 29 MB.
- `.idea/` y `tmp/pdfs/` están versionados.
- Identificador de Android `com.example.bearstards_movil_application`.
- Versión `1.0.0+1`, mientras la estrategia de versionamiento usa `v0.x` hasta la entrega.
- Sin plan de pruebas móvil (ya resuelto con `docs/test-plan.md`).

## 6. Lo ya implementado

### Plan de pruebas y suite (commits `9a2f1a2` y `da1a927`, rama `feat/gmd/funciones-interactivas`)
- `docs/test-plan.md`: introducción, alcance (RF-01 a RF-11), fuera de alcance, tipos de prueba, ambiente, datos de prueba y riesgos.
- `docs/test-suite.md`: 23 casos con caso, prioridad, precondiciones, datos de entrada, pasos, resultado esperado, resultado obtenido y estado.
  - 14 casos automatizados, todos Aprobados.
  - 9 casos manuales Pendientes (contenido de armas y objetos, modo avión, botón atrás de Android, APK, iOS, TalkBack).
  - Tres observaciones: OBS-01 (portada sin Objetos), OBS-02 (125 contra 150) y OBS-03 (diferencias con Unity).
- Enlace en el README.
- Resultados reales del 30/oct/2026: `flutter analyze` sin problemas y `flutter test` con 17 pruebas aprobadas y 1 omitida (las capturas, que solo corren con `GENERATE_PREVIEWS=true`).

### Paso 1 del rediseño (sin commitear, rama `feat/gmd/rediseno-toon`)
En `lib/core/widgets/guide_components.dart`:
- `StatPill` ahora es una píldora con borde de tinta de 2.5 px y sombra dura.
- Nuevo `EyebrowChip`: etiqueta inclinada −2° sobre los títulos (rosa sobre fondo oscuro, amarilla sobre tarjetas).
- `GuideHeading` usa ese chip.
- Verificación: `flutter analyze` sin problemas y 17 pruebas aprobadas. No se ha visto en emulador.
- Mensaje de commit sugerido: `feat(design): add toon pills and tilted eyebrow chips`.

## 7. Análisis de la PWA (referencia visual)

El sitio `littlebearstards.com` no cargó desde el equipo del agente (error de certificado `ERR_CERT_AUTHORITY_INVALID`); no se evadió. Conviene revisarlo desde un teléfono. El análisis salió del repo `StingerBlade/BEARSTARDS_PWA`.

Qué hace distinta a la PWA frente a la app:
- **Tipografía:** fuente del juego `Taste Bread` (uso personal, Khurasan) con Lilita One y Fredoka de respaldo, y títulos con contorno de texto.
- **Estilo toon:** bordes de 3 a 4 px en tinta y sombra dura (`5px 5px 0`). Corrección importante: la app ya usa sombra dura y borde de 2.5 px en `StitchedCard`, pero sobre el fondo oscuro la sombra no se ve.
- **Ritmo de secciones:** alterna fondo noche y crema con bordes ondulados.
- **Piezas inclinadas:** chips y tarjetas con ±1° de rotación.
- **Movimiento:** entrada al hacer scroll con rebote, cinta de texto en marquee con botón de pausa, armas que se mecen y una linterna que sigue al cursor sobre el render del juego.
- **Imágenes del juego:** render y capturas del HUD, la vida y la pantalla de carga. Las 26 imágenes son WebP y suman 948 KB.
- **Contenido:** tarjetas de puntos (+200, +350, +400, −50) y reglas numeradas.
- Paleta casi idéntica a la de la app, así que el cambio no es de color.

## 8. Plan pendiente

### Rama `feat/gmd/rediseno-toon` (commits por orden)
1. Chips y píldoras toon. **Hecho, sin commitear.**
2. Fuentes display: empaquetar Lilita One y Fredoka (licencia OFL) y definir estilos de título con contorno. **Requiere que el usuario autorice la descarga**, o se usa solo Vera con contorno y peso.
3. Tema tipográfico aplicado a toda la app y ajuste de las pruebas de adaptación.
4. Secciones crema con borde ondulado (`CustomPainter`), aplicadas en las pantallas.
5. Portada con título con contorno y linterna que sigue al dedo.
6. Navegación inferior y encabezado con estilo toon.
7. Animaciones de entrada (reveal al hacer scroll, armas que se mecen), respetando `disableAnimations`.
8. Regenerar las capturas de `designs/previews/` y actualizar la suite de pruebas.

### Rama `feat/gmd/funciones-interactivas`
- **Calculadora de eliminaciones:** arma, con o sin casco y cabeza o cuerpo, devuelve los golpes necesarios. Propuesta: parte de la vida completa, 100 sin casco y 125 con casco, que coincide con las pruebas de Unity (aguja: 4 y 5 golpes). Decisión pendiente: si el usuario prefiere elegir una vida actual.
- **Buscador** sobre armas, objetos y reglas.
- **Guardados (favoritos)** persistentes.
- Corrección de la portada para enlazar Objetos (OBS-01).
- Una sección de puntos con la cuadrícula +200, +350, +400, −50.

### Rama `chore/gmd/assets-webp`
- Convertir las imágenes usadas a WebP (la PWA suma 948 KB; la app, unos 29 MB), quitar o ignorar `assets/images/mvp/`, `assets/images/wiki_v2/` y `tmp/pdfs/`, y sacar `.idea/` del seguimiento.

### Otras ramas por definir
- **CI de Flutter** en `.github/workflows/`: `flutter analyze`, `flutter test` y APK de depuración, tal como lo describe el caso de estudio.
- **Identidad de la app:** cambiar `com.example...` y alinear la versión con la estrategia (`v0.x` hasta la entrega).
- **Bitácora de commits** (`docs/commit-log.md`) generada con `git log` al final.
- **Corregir el contrato** para admitir `empate`, en el repo de Unity y en el de la API.

### Meta de commits
- Mínimo 30 en el repositorio. Había 19 al 30 de octubre, con los 2 de pruebas incluidos. Los 8 pasos del rediseño, las funciones, la limpieza y el CI superan el mínimo sin dividir cambios de forma artificial.

## 9. Pendientes que dependen del usuario

- Autorizar o no la descarga de Lilita One y Fredoka (paso 2).
- Decidir 125 o 150 de vida máxima con casco, y entregar la Evidencia 2 si procede.
- Ejecutar los 9 casos manuales de la suite y anotar el resultado obtenido.
- Completar los nombres de los autores en el plan de pruebas.
- Revisar `littlebearstards.com` desde un teléfono por el error de certificado.
- Repartir ramas entre integrantes si se quiere mostrar autoría de equipo (14 de los 15 commits sin merges son de una sola persona).
- Probar el paso 1 del rediseño en emulador y hacer su commit.
