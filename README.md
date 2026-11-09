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
| RF-08 | Funcionamiento sin conexión a red. |
| RF-09 | Adaptación a pantalla pequeña (320×568), texto al 180 % y orientación horizontal. |
| RF-10 | Etiquetas de accesibilidad (Semantics) en los elementos interactivos. |
| RF-11 | Integridad técnica: catálogo inmutable, assets empaquetados y entorno reproducible. |

### 3. Fuera del alcance

- El videojuego en Unity, el multijugador con Photon y la PWA de ranking, que tienen su propio plan.
- Pruebas de carga, de seguridad y de penetración: la app no usa red ni guarda datos personales.
- Tabletas, escritorio y web: el proyecto solo incluye Android e iOS.
- Publicación en tiendas y firma de aplicaciones.
- Funciones que la wiki no implementa: partidas, estadísticas personales, ranking y cuentas.

### 4. Tipos de pruebas

| Tipo | Descripción | Herramienta |
| --- | --- | --- |
| Estática | Análisis del código con `flutter_lints`. | `flutter analyze` |
| Unitarias | Catálogo inmutable y completo, ViewModels que notifican solo ante cambios reales, validación del entorno. | `flutter test` |
| De widgets | Recorridos de navegación, selecciones y detalles con la aplicación real. | `flutter test` |
| De recursos | Las ilustraciones usadas existen en el paquete y no se empaquetan recursos no usados. | `flutter test` |
| De adaptación | Sin desbordes en 320×568, 390×844 con texto al 180 % y 844×390. | `flutter test` |
| Revisión visual | Capturas reales de los widgets para revisión humana. | `GENERATE_PREVIEWS=true` |
| Funcionales manuales | Recorrido en emulador o dispositivo contra las reglas del MVP. | Emulador Android, teléfono físico |
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
| Red | Con red y en modo avión para RF-08 |
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
