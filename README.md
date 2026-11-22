# Bearstards Wiki

Wiki móvil de consulta del juego Bearstards, desarrollada con Flutter para Android e iOS.

## Ejecutar

Utiliza Flutter **3.47.6 stable**, con Dart **3.13.5**, y un emulador o dispositivo móvil. La referencia exacta está en `toolchain.json`; los requisitos Android/iOS y las actualizaciones controladas se explican en [Entorno y dependencias reproducibles](docs/reproducible-environment.md).

```sh
dart tool/verify_environment.dart
flutter pub get --enforce-lockfile
flutter run --no-pub
```

```sh
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug --no-pub
```

Para compilar iOS se necesita macOS con Xcode y la configuración de firma del equipo:

```sh
flutter build ios --no-codesign --no-pub
```

El proyecto incluye únicamente los targets android/ e ios/. No contiene targets de escritorio ni web.

## Colaboración y versionamiento

Se utiliza Git con GitHub y un flujo de ramas de trabajo, `development` y `main`. La justificación, las reglas de commits y la preparación de versiones están en [Estrategia de versionamiento](docs/versioning-strategy.md).

El responsable del proyecto revisa el código y realiza todos los pushes. El agente trabaja y registra commits localmente; no publica cambios. Consulta la [guía de colaboración](CONTRIBUTING.md).

## Organización

main.dart solo arranca la aplicación. La arquitectura feature-first con MVVM, los límites de dependencias y la navegación se documentan en [docs/architecture.md](docs/architecture.md).

Las reglas de referencia y las diferencias entre los portafolios están en [docs/mvp-content.md](docs/mvp-content.md). Los prompts y las notas de producción de assets están en [designs/asset_production_notes.md](designs/asset_production_notes.md).

La wiki funciona sin red: Personajes, Sigilo, Objetos, Arsenal y La Juguetería consultan un catálogo local inyectado mediante WikiRepository. Usa los modelos tipados y los componentes existentes al añadir contenido.

## Resultados globales

La única pantalla que usa red es **Resultados globales**: lee el ranking público de la API de la PWA (`GET /api/ranking/`), sin enviar contraseñas ni tokens. Se abre desde la portada y muestra el podio, la lista, y los estados de carga, vacío, error y datos antiguos (si una recarga falla, conserva el último ranking cargado en la sesión).

La dirección de la API es `https://littlebearstards.com/api` y se puede cambiar al compilar:

```sh
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

`10.0.2.2` es la máquina anfitriona vista desde el emulador de Android. Las pruebas nunca usan la red real: inyectan un repositorio falso (`test/support/results_fakes.dart`) o un cliente HTTP simulado.

## Historias de usuario y suite de pruebas (entrega)

La suite sigue la plantilla del curso: ocho **historias de usuario** (Como / Quiero / Para y criterios de aceptación) y la **suite de pruebas** con las columnas No, Caso de prueba, Prioridad, Precondiciones, Datos de entrada, Pasos, Resultados esperado, Resultado obtenido y Estado (OK, FALLO o PENDIENTE), agrupada por área funcional.

- Las historias están en `test/suite/user_stories.dart`; cada caso pertenece a exactamente una.
- Los casos automatizados (TC-xx) están en `test/suite/cases.dart` y los ejecuta `flutter test test/suite`. Su resultado y estado salen de esa ejecución.
- Los casos manuales (MC-xx), que necesitan un emulador, un teléfono o la red real, están en `test/suite/manual_cases.dart`. Quien los ejecuta anota el resultado obtenido y el estado en ese archivo.
- El documento de entrega, con el formato de la plantilla, está en [docs/entrega/suite-de-pruebas.pdf](docs/entrega/suite-de-pruebas.pdf) (y su [HTML](docs/entrega/suite-de-pruebas.html)). Se regenera con:

```sh
dart run tool/generate_suite_report.dart --pdf
```

El comando ejecuta la suite, usa las versiones de `toolchain.json`, escribe el HTML y, con `--pdf`, el PDF con Chrome o Edge. Termina con código 1 si algún caso automatizado falla.

## Revisión visual

```sh
flutter test test/visual_preview_test.dart --dart-define=GENERATE_PREVIEWS=true
```

Genera capturas reales de Flutter en designs/previews/. Las pruebas normales no reescriben estos archivos.

## Plan de pruebas

### 1. Introducción

Este plan define cómo se verifica Bearstards Wiki: que el contenido de consulta sea fiel a las reglas del MVP del videojuego, que la navegación funcione, que las pantallas se adapten a distintos tamaños y que los defectos se registren y se corrijan antes de la entrega. Complementa el plan del videojuego en Unity, que excluye la aplicación móvil. Las reglas de referencia están en [docs/mvp-content.md](docs/mvp-content.md).

### 2. Alcance de las pruebas

| ID | Requerimiento |
| --- | --- |
| RF-01 | Portada con acceso a las secciones, navegación inferior entre capítulos y botón Volver. |
| RF-02 | Personajes: jugador, osos NPC y reglas de eliminación y reaparición. |
| RF-03 | Sigilo: elegir una acción y ver si es discreta o delatora. |
| RF-04 | Objetos: casco y rollo de hilo, con estadísticas y reglas. |
| RF-05 | Arsenal: aguja de coser y pistola de dardos, con ficha de detalle. |
| RF-06 | La Juguetería: mapa, selector de las tres fases y regla de desempate. |
| RF-07 | Fidelidad del contenido con las reglas del MVP (daño, golpes, puntos, vida, munición, fases). |
| RF-08 | La wiki (catálogo local) funciona sin conexión a red. |
| RF-09 | Adaptación a pantalla pequeña (320×568), texto al 180 % y orientación horizontal. |
| RF-10 | Etiquetas de accesibilidad (Semantics) en los elementos interactivos. |
| RF-11 | Integridad técnica: catálogo inmutable, assets empaquetados y entorno reproducible. |
| RF-12 | Resultados globales: pantalla accesible desde la portada que muestra el ranking público de la API (podio y lista). |
| RF-13 | Contenido del ranking: orden del servidor, puntos (también negativos), partidas y porcentaje de victorias, con un guion si no hay partidas. |
| RF-14 | Errores y falta de conexión: estados de carga, vacío y error con Reintentar, y datos antiguos conservados si una recarga falla. |
| RF-15 | Privacidad: la lectura del ranking es pública y no envía contraseñas, tokens ni cookies. |

### 3. Fuera del alcance

- El videojuego en Unity, el multijugador con Photon y el servidor y la interfaz web de la PWA, que tienen su propio plan. De la PWA solo se prueba el cliente de la app contra el contrato de `GET /api/ranking/`.
- Pruebas de carga, de seguridad y de penetración: la app no guarda datos personales ni maneja contraseñas; solo lee el ranking público.
- Tabletas, escritorio y web: el proyecto solo incluye Android e iOS.
- Publicación en tiendas y firma de aplicaciones.
- Funciones que la app no implementa: partidas, estadísticas personales, registro e inicio de sesión. Resultados globales es solo lectura del ranking público.

### 4. Tipos de pruebas

| Tipo | Descripción | Herramienta |
| --- | --- | --- |
| Estática | Análisis del código con `flutter_lints`. | `flutter analyze` |
| Unitarias | Catálogo inmutable y completo, ViewModels que notifican solo ante cambios reales, validación del entorno. | `flutter test` |
| De widgets | Recorridos de navegación, selecciones y detalles con la aplicación real. | `flutter test` |
| De recursos | Las ilustraciones usadas existen en el paquete y no se empaquetan recursos no usados. | `flutter test` |
| De contrato (cliente HTTP) | El cliente lee el formato real de `GET /api/ranking/`, distingue fallos del servidor de datos inválidos y no envía credenciales. | `flutter test` con `http/testing` |
| Con la API real (manual) | Una consulta a producción y un recorrido de la pantalla en emulador con red, sin red y con el servidor caído. | `curl`, emulador Android |
| De adaptación | Sin desbordes en 320×568, 390×844 con texto al 180 % y 844×390. | `flutter test` |
| Revisión visual | Capturas reales de los widgets para revisión humana. | `GENERATE_PREVIEWS=true` |
| Funcionales manuales | Casos MC-xx en emulador o dispositivo: contenido contra las reglas del MVP, modo avión, botón atrás, instalación del APK y TalkBack. | Emulador Android, teléfono físico |
| De contenido | Cada cifra y regla mostrada se compara con el Portafolio funcional. | Revisión cruzada |
| De regresión | Tras corregir un defecto se repite la prueba que lo detectó y se ejecuta la suite completa. | `flutter test` y recorrido manual |

Una prueba se da por aprobada cuando su resultado obtenido coincide con el esperado y es repetible. Los defectos se registran como Issues con pasos para reproducirlos, versión de la compilación y captura.

### 5. Ambiente de prueba

| Elemento | Valor |
| --- | --- |
| Repositorio | `CrazyBread7364/Bearstards_Movil_Application` |
| Ramas | Trabajo en `tipo/responsable/descripcion` hacia `development`; versiones estables en `main` |
| Flutter / Dart | 3.47.6 stable / 3.13.5 (`toolchain.json`) |
| Preparación | `dart tool/verify_environment.dart` y `flutter pub get --enforce-lockfile` |
| Plataforma principal | Emulador Android y, de ser posible, un teléfono físico |
| iOS | Requiere macOS con Xcode; si no hay equipo disponible queda registrado como pendiente |
| API | `https://littlebearstards.com/api` (`AppConfig.apiBaseUrl`); se cambia con `--dart-define=API_BASE_URL=...` |
| Red | Con red y en modo avión para RF-08 y RF-14 |
| Automatización | GitHub Actions (`.github/workflows/ci.yml`): análisis, pruebas y APK de depuración |

### 6. Datos de prueba

La aplicación no recibe datos del usuario: los datos de prueba son el contenido del catálogo local y los parámetros de cada prueba.

- Aguja de coser: 25 de daño; 4 golpes sin casco y 5 con casco.
- Pistola de dardos: 6 dardos, 50 de daño; 2 impactos sin casco y 3 con casco; sin recarga.
- Casco: vida máxima 125, no se acumula. Rollo de hilo: +25 de vida sin pasar del máximo.
- Puntos: +200 eliminación normal, +350 con sigilo, +400 con dardos, −50 por golpear a un NPC.
- Un golpe a la cabeza elimina de inmediato, incluso con casco. Reaparición con 100 de vida. Tres fases de igual duración.
- Entradas de interacción: las cuatro acciones de sigilo, las tres fases y las cuatro entradas del catálogo.
- Tamaños de pantalla 320×568, 390×844 y 844×390, con escala de texto 1.0 y 1.8.
- Ranking de ejemplo (formato real de la API): memo 600, CarlOso 500, AngelOso 200, celaya 0 (sin partidas) y memo2 −150.
- Casos límite del ranking: lista vacía, jugador sin partidas, puntos negativos, nombres largos, nombres con acento.
- Respuestas simuladas del servidor: códigos 404, 500 y 503, sin conexión, tiempo agotado, texto que no es JSON y un jugador sin puntos.

### 7. Riesgos

| Riesgo | Probabilidad | Impacto | Mitigación |
| --- | --- | --- | --- |
| Las fuentes difieren en la vida máxima con casco (125 contra 150) | Media | Alto | Se conserva 125 y se documenta en `docs/mvp-content.md`; confirmar con el Product Owner |
| El juego aún tiene defectos abiertos (dardos ilimitados, la partida no termina al acabar el tiempo) y la wiki describe la regla prevista | Alta | Medio | Documentar que la wiki muestra el comportamiento previsto, no el de una compilación |
| El contenido está escrito en el código: un cambio de balance puede dejar la wiki desactualizada sin que falle una prueba | Media | Medio | Casos de contenido contra los valores de referencia y revisión cruzada |
| Sin equipo macOS no se puede compilar ni probar iOS | Alta | Medio | Registrar iOS como pendiente y priorizar Android |
| Desbordes con texto ampliado o pantallas pequeñas | Media | Alto | Pruebas automáticas de adaptación en tres tamaños |
| Poco tiempo de pruebas antes de la entrega del 20 de noviembre | Alta | Alto | Ejecutar la suite en cada integración y reservar los últimos días para corrección |
| Defectos reportados sin datos suficientes | Media | Medio | Issue con pasos, versión de la compilación y captura |
| Resultados globales depende de un servicio externo (API, hosting y base de datos gratuitos que pueden pausarse o caer) | Media | Medio | Estados de error con Reintentar, últimos datos conservados en la sesión y aviso al usuario (TC-24 a TC-26) |
| La PWA cambia el formato de `/api/ranking/` sin avisar | Media | Alto | El modelo rechaza campos ausentes o de otro tipo y el cliente lo reporta como formato inesperado (TC-27, TC-28); coordinar cambios con el responsable de la PWA |
| La pantalla muestra nombres de usuario de otros jugadores | Baja | Medio | Solo muestra lo que la API ya publica en su ranking público y no envía credenciales (TC-29) |
| Android lanza un primer fotograma de ancho cero y Impeller aborta al decodificar imágenes de 1 píxel | Media | Alto | Protección en `WikiArtwork` y altura de tarjetas no negativa (TC-18) |
| El ranking no se guarda en disco: sin conexión al abrir la app por primera vez no hay datos que mostrar | Alta | Bajo | Se muestra el mensaje de error con Reintentar; guardar en disco queda fuera del alcance actual |
