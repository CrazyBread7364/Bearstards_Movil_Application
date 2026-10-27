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
