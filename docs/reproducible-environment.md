# Entorno y dependencias reproducibles

## 1. Objetivo

Conservar la misma resolución de paquetes Dart y utilizar una versión identificada del SDK de Flutter al preparar otro equipo o ejecutar las comprobaciones del proyecto.

La referencia de Flutter/Dart se guarda en [toolchain.json](../toolchain.json). La resolución de paquetes, incluidas sus versiones y hashes de contenido, se conserva en [pubspec.lock](../pubspec.lock). El archivo lock se genera con pub y se versiona junto con la aplicación.

Esta configuración no instala herramientas en el equipo ni cambia su configuración global. La validación del SDK y la instalación de dependencias son pasos explícitos.

## 2. Base identificada

| Componente | Referencia | Fuente |
| --- | --- | --- |
| Flutter | 3.47.6, canal stable | toolchain.json y metadatos del SDK utilizado |
| Revisión de Flutter | 5fc346839b5d0eef006ed8404392afb4dfae428d | toolchain.json |
| Dart incluido con Flutter | 3.13.5 | toolchain.json |
| Gradle | 9.3.1 | android/gradle/wrapper/gradle-wrapper.properties |
| Android Gradle Plugin | 9.1.0 | android/settings.gradle.kts |
| Kotlin Android | 2.4.0 | android/settings.gradle.kts |
| Android compileSdk / targetSdk | 36 / 36 | Valores de FlutterExtension del SDK de referencia |
| Android minSdk | 24 | Valor de FlutterExtension del SDK de referencia |
| Android NDK | 28.2.13676358 | Valor de FlutterExtension del SDK de referencia |
| JDK usado por Flutter en el equipo verificado | OpenJDK 25.0.3, incluido con Android Studio | flutter doctor --verbose |
| Nivel de compilación Java y destino JVM Kotlin | 17 | android/app/build.gradle.kts |
| iOS deployment target | 15.0 | ios/Runner.xcodeproj/project.pbxproj |

El JDK que ejecuta Gradle y el nivel de compilación de la aplicación son parámetros diferentes. Flutter utiliza en este equipo el JDK de Android Studio; el Java instalado en PATH puede ser otro. Para identificar el utilizado se consulta `flutter doctor --verbose`.

Android toma compileSdk, targetSdk, minSdk y NDK del SDK de Flutter fijado. Que doctor muestre otra plataforma Android instalada, por ejemplo una más reciente, no cambia esos valores del proyecto.

El comprobador automatizado valida Flutter y Dart. Las herramientas nativas se revisan mediante doctor y la configuración anterior; no se afirma que el script valide JDK, Android SDK o Xcode.

## 3. Preparar un equipo

1. Instalar Flutter 3.47.6 del canal stable y agregar su directorio bin al PATH.
2. Utilizar el Dart incluido en ese mismo SDK. No se necesita instalar Dart por separado.
3. Para Android, instalar el SDK, las herramientas y el NDK indicados, y aceptar las licencias.
4. Para iOS, preparar macOS con Xcode y las herramientas de desarrollo necesarias.
5. Obtener la rama que se quiere revisar y ejecutar los siguientes pasos desde la raíz del repositorio.

Comprobación del SDK:

```sh
dart tool/verify_environment.dart
flutter doctor --verbose
```

El script comprueba versión, canal y revisión de Flutter, y la versión del ejecutable Dart utilizado. Localiza los metadatos del SDK al que pertenece ese Dart para evitar comprobar accidentalmente otro Flutter del PATH. Si encuentra diferencias o una configuración incompleta termina con código distinto de cero.

Preparación estricta de paquetes:

```sh
flutter pub get --enforce-lockfile
```

Esta orden exige que pubspec.lock contenga una resolución válida de pubspec.yaml y comprueba los hashes de los paquetes alojados. Si el lockfile queda desactualizado, la preparación debe fallar y revisarse la causa.

La primera preparación necesita acceso a los repositorios de paquetes y a las herramientas nativas que todavía no estén disponibles en el equipo.

Si los paquetes ya están en la caché local, también puede comprobarse la resolución sin red:

```sh
flutter pub get --offline --enforce-lockfile
```

El modo offline depende de esa caché previa; no demuestra que una computadora vacía pueda preparar el proyecto sin descargas.

## 4. Verificar y ejecutar

Después de preparar las dependencias:

```sh
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze --no-pub
flutter test --no-pub
flutter run --no-pub
```

Para comprobar la compilación Android:

```sh
flutter build apk --debug --no-pub
```

Para comprobar la compilación iOS en macOS:

```sh
flutter build ios --no-codesign --no-pub
```

La opción `--no-pub` mantiene estas comprobaciones separadas del paso explícito de resolución de dependencias.

El APK debug no constituye una distribución firmada para producción. La firma y publicación quedan bajo control del responsable del proyecto.

## 5. Actualizaciones controladas

Para cambiar una dependencia:

1. Preparar una rama para esa actualización.
2. Modificar la restricción correspondiente en pubspec.yaml cuando sea necesario.
3. Ejecutar `flutter pub get` para generar la nueva resolución de forma intencional.
4. Revisar las diferencias de pubspec.yaml y pubspec.lock y sus dependencias transitivas.
5. Ejecutar el análisis, las pruebas y las comprobaciones de compilación pertinentes.
6. Registrar juntos el manifiesto y la resolución que correspondan al cambio.

Para cambiar Flutter se revisan también toolchain.json, la compatibilidad del SDK Dart y la configuración de las plataformas. Después se vuelve a resolver y validar el lockfile. No se ejecuta una actualización general del SDK o de paquetes como parte de la preparación ordinaria.

No se edita pubspec.lock manualmente ni se elimina para evitar un fallo de resolución estricta. Los mensajes de paquetes más recientes disponibles no requieren actualizar la base validada.

Los mínimos de SDK que aparecen al final de pubspec.lock describen restricciones de la resolución; la referencia exacta de Flutter/Dart del equipo se comprueba por separado con toolchain.json.

## 6. Archivos locales y límites de validación

Se mantienen fuera de Git las cachés, build/, rutas locales como android/local.properties y credenciales de firma. Cada equipo configura sus rutas de SDK localmente.

El lockfile Dart no congela por sí solo todas las herramientas o dependencias nativas. Gradle y los plugins Android tienen versiones declaradas en sus archivos. La primera compilación puede descargar sus artefactos; disponer de la caché de pub no sustituye a la caché de Gradle.

La compilación iOS y una versión de Xcode aceptada para este proyecto quedan pendientes de verificación en macOS. Cuando se resuelvan dependencias nativas en ese entorno deberán conservarse los archivos de resolución que correspondan al gestor efectivamente utilizado, por ejemplo Package.resolved con Swift Package Manager o Podfile.lock si se adopta CocoaPods. No se generan evidencias de iOS desde Windows.

## 7. Base de esta rama

`chore/gmd/dependencias-reproducibles` parte del commit local `5c4ca3e`, que contiene la implementación de pulido y la estrategia de versionamiento. En el momento de crear esta rama, development remoto aún estaba en `0593577`; por ello este trabajo depende de la entrega anterior pendiente de integrar.

Esta rama no cambia las versiones resueltas de los paquetes de la app. Hace que su resolución quede registrada en Git y que el SDK de referencia pueda comprobarse. La publicación e integración siguen siendo responsabilidad exclusiva del usuario.
