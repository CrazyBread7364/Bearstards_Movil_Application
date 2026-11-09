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

Flujo: pantalla → ViewModel → contrato WikiRepository ← LocalWikiRepository.
Las pantallas estáticas reciben el repositorio directamente porque no necesitan estado de presentación.

## Decisiones

El repositorio se inyecta por constructor. No hay variables globales mutables, búsquedas de servicios ni paquetes de estado adicionales. Los dos ViewModels se crean y liberan con el ciclo de vida de sus pantallas.

Los modelos de dominio no conocen rutas, widgets, Color, IconData ni paths de imágenes. Las rutas usan constantes y los detalles reciben EntryId; ya no se resuelven entradas por posición en una lista ni por el texto del título.

La navegación mantiene la portada como raíz. Cambiar de capítulo reemplaza el capítulo actual. Pulsar de nuevo el capítulo activo conserva su estado. Los artículos se apilan sobre el capítulo y Volver regresa a él.

El estilo vive en AppTheme, Palette, StitchedCard y ArtworkStage. Las puntadas y los planos de color se dibujan con Flutter, por lo que no requieren generar una imagen distinta para cada tamaño. Las ilustraciones originales y los nuevos recortes permanecen independientes de los textos y botones.

## Añadir contenido

1. Añadir el identificador y el contenido al dominio/repositorio.
2. Declarar la ilustración en WikiAssets y su correspondencia en WikiPresentation.
3. Añadir al pubspec únicamente los archivos que consume la aplicación.
4. Probar la ruta y los cambios de estado si la funcionalidad es interactiva.

Si en el futuro se necesita otra fuente de datos, se implementa WikiRepository y se inyecta en BearstardsWikiApp. El alcance actual no requiere red ni persistencia.

## Verificación

`flutter analyze` y `flutter test`.

Las pruebas cubren la ruta independiente de Personajes, navegación entre capítulos, artículos y regreso, selecciones de Sigilo/Fases, inmutabilidad del catálogo y distribución de pantallas a 320×568, 390×844 con texto al 180 % y 844×390.

`flutter test test/visual_preview_test.dart --dart-define=GENERATE_PREVIEWS=true` regenera capturas de los widgets reales en designs/previews con tipografías y assets locales. Se revisan visualmente; no son mockups de ImageGen.
