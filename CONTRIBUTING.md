# Colaboración en Bearstards Wiki

La política completa está en [Estrategia de versionamiento](docs/versioning-strategy.md).

## Revisión y publicación

Todos los pushes los realiza el responsable del proyecto, después de revisar el código. El agente prepara y verifica cambios y commits locales; no ejecuta push, no publica etiquetas ni modifica el remoto.

Esta regla se mantiene durante todo el trabajo. Finalizar una tarea o crear un commit no autoriza una publicación.

## Trabajo local

1. Revisar `git status` y respetar los cambios existentes.
2. Trabajar en una rama con un objetivo definido: `tipo/responsable/descripcion-breve`.
3. Mantener los cambios dentro del alcance de la wiki para Android e iOS.
4. Revisar las diferencias y verificar el comportamiento o contenido afectado.
5. Seleccionar los archivos del cambio y registrar un commit coherente.
6. Entregar el resumen, los hashes locales, las comprobaciones y las limitaciones al responsable.
7. Esperar la revisión del responsable, quien administra la publicación e integración.

Para la tarea actual se utiliza `feat/gmd/pulir-diseno-y-funcionalidad`.

## Mensajes de commit

Formato: `tipo(ambito): descripcion breve`.

Tipos: `feat`, `fix`, `refactor`, `test`, `docs` y `chore`.

Cada commit corresponde a una mejora, corrección o evidencia real. Se conservan los mensajes y commits históricos.

## Comprobaciones

- Código: análisis estático y pruebas pertinentes.
- Diseño: revisión visual y recorridos de las pantallas afectadas.
- Documentación: exactitud, enlaces y diferencias.
- Versión candidata: comprobación de compilación y pruebas móviles disponibles, indicando lo pendiente.

Se preservan los commits originales al integrar las ramas. Las decisiones sobre integración, versiones y publicación pertenecen al responsable del proyecto.
