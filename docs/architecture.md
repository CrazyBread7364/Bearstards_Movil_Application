# Arquitectura móvil de Bearstards Wiki

La aplicación es una wiki local de consulta para Android e iOS. La organización combina funcionalidades (feature-first) con MVVM en las vistas que tienen estado.

## Límites y dependencias

- `lib/main.dart`: arranque de Flutter.
- `lib/app/`: raíz de composición, tema y navegación. Aquí se crea e inyecta el repositorio.
- `lib/core/`: paleta, tipografía, registro de assets y componentes visuales reutilizables. No importa ninguna funcionalidad.
- `lib/features/wiki/domain/`: entidades inmutables, identificadores tipados y contrato del repositorio. No importa Flutter.
- `lib/features/wiki/data/`: implementación local del catálogo de referencia.
- `lib/features/wiki/presentation/screens/`: una pantalla por archivo.
- `lib/features/wiki/presentation/view_models/`: estado y acciones de selección; las vistas se reconstruyen con ListenableBuilder.
- `lib/features/wiki/presentation/widgets/`: componentes de la wiki, sin duplicar estilos comunes.
- `wiki_presentation.dart`: mapea identificadores a ilustraciones y colores mediante switches exhaustivos.
- `lib/app/app_config.dart`: ajustes de compilación; `API_BASE_URL` apunta a la API web y se cambia con `--dart-define`.
- `lib/features/results/`: la pantalla de Resultados globales, con la misma separación (`domain/`, `data/`, `presentation/`). `PlayerScore` y el contrato `ResultsRepository` no importan Flutter; `HttpResultsRepository` usa el paquete `http`.

Flujo de la wiki: pantalla → ViewModel → contrato WikiRepository ← LocalWikiRepository.
Flujo de los resultados: ScoresScreen → ScoresViewModel → contrato ResultsRepository ← HttpResultsRepository.
Las pantallas estáticas reciben el repositorio directamente porque no necesitan estado de presentación.

## Decisiones

El repositorio se inyecta por constructor. No hay variables globales mutables, búsquedas de servicios ni paquetes de estado adicionales. Los dos ViewModels se crean y liberan con el ciclo de vida de sus pantallas.

Los modelos de dominio no conocen rutas, widgets, Color, IconData ni paths de imágenes. Las rutas usan constantes y los detalles reciben EntryId; ya no se resuelven entradas por posición en una lista ni por el texto del título.

La navegación mantiene la portada como raíz. Cambiar de capítulo reemplaza el capítulo actual. Pulsar de nuevo el capítulo activo conserva su estado. Los artículos se apilan sobre el capítulo y Volver regresa a él.

El estilo vive en AppTheme, Palette, StitchedCard y ArtworkStage. Las puntadas y los planos de color se dibujan con Flutter, por lo que no requieren generar una imagen distinta para cada tamaño. Las ilustraciones originales y los nuevos recortes permanecen independientes de los textos y botones.

## Resultados globales

La wiki funciona sin red; Resultados globales es la excepción y lee el ranking público de la API web (`GET /api/ranking/`, sin credenciales).

- **ViewModel por sesión.** A diferencia de los ViewModels de la wiki, `ScoresViewModel` se crea una sola vez en `BearstardsWikiApp` y se libera con la app. Así el último ranking que cargó bien sigue disponible al volver a la pantalla y cuando una recarga falla: se muestra con un aviso en lugar de un error. La caché es solo de sesión (en memoria); no se guarda en disco.
- **Errores tipados.** El repositorio lanza `ResultsUnavailable` (sin conexión, tiempo agotado o error del servidor) o `ResultsFormatError` (la respuesta no cumple el contrato). Cualquier otra excepción se convierte en `ResultsUnavailable` para que la pantalla nunca se quede cargando.
- **Contrato estricto.** `PlayerScore.fromJson` rechaza campos ausentes o de otro tipo y nombra el campo, para que un cambio del backend falle de forma visible. La efectividad es nula cuando no hay partidas.
- **Pruebas sin red.** Las pruebas inyectan `FakeResultsRepository` o un cliente `http/testing`. Nunca llegan a la red real.
- **Acoplamiento conocido.** La pantalla reutiliza `GuideScaffold` y `WikiSection` de la funcionalidad wiki. Si se añaden más funcionalidades conviene moverlos a `lib/core/`.

## Añadir contenido

1. Añadir el identificador y el contenido al dominio/repositorio.
2. Declarar la ilustración en WikiAssets y su correspondencia en WikiPresentation.
3. Añadir al pubspec únicamente los archivos que consume la aplicación.
4. Probar la ruta y los cambios de estado si la funcionalidad es interactiva.

Si en el futuro se necesita otra fuente de datos para la wiki, se implementa WikiRepository y se inyecta en BearstardsWikiApp. El catálogo no requiere red ni persistencia; solo Resultados globales usa la red.

## Verificación

`flutter analyze` y `flutter test`.

Las pruebas cubren la ruta independiente de Personajes, navegación entre capítulos, artículos y regreso, selecciones de Sigilo/Fases, inmutabilidad del catálogo y distribución de pantallas a 320×568, 390×844 con texto al 180 % y 844×390. Para Resultados globales cubren el modelo, el cliente HTTP con respuestas simuladas, el ViewModel (estados, reintento y datos antiguos) y la pantalla en cada estado.

Los casos de aceptación documentados (caso, prioridad, precondiciones, datos, pasos y resultado esperado) viven en `test/suite/cases.dart` y se ejecutan con `flutter test test/suite`. Cada caso pertenece a una historia de usuario (`test/suite/user_stories.dart`), que es su área funcional. Los casos que requieren un dispositivo o la red real están en `test/suite/manual_cases.dart`.

`tool/generate_suite_report.dart` ejecuta la suite, lee los resultados con `tool/suite_report.dart`, los junta con las historias y los casos manuales y genera el documento de entrega (`tool/suite_report_render.dart`) en `docs/entrega/`. `test/suite/` solo importa modelos de Dart puro (`test_case_model.dart`, `user_stories.dart`, `manual_cases.dart`), para que el generador pueda correr con `dart run` sin Flutter.

`flutter test test/visual_preview_test.dart --dart-define=GENERATE_PREVIEWS=true` regenera capturas de los widgets reales en designs/previews con tipografías y assets locales. Se revisan visualmente; no son mockups de ImageGen.
