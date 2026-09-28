# @unsareport/ne-lab-2026

Plantilla oficial para Informes de Entregable e Informes de Investigación Formativa del curso de Negocios Electrónicos (UNSA - EPIS). Incluye portada institucional, sangría jerárquica automática, índice general y renombrado post-compilación.

## Uso

```typst
#import "/components/@unsareport/ne-lab-2026/lib.typ": ne-report, no-indent-block, force-indent-block

#show: ne-report.with(
  group: "A",
  subgroup: "01",
  session_number: "01",
  deliverable_number: "1",
  session: "Sesión: Negocios Electrónicos - Tiendas Virtuales",
  topic: "Tiendas Virtuales",
  authors: (
    "Integrante 1",
    "Integrante 2",
    "Integrante 3",
    "Integrante 4",
  ),
  authors_short: "Integrante1-Integrante2-Integrante3-Integrante4",
  date: "2026 setiembre",
)

= 1. Planificar
Contenido del informe...
```

## Parámetros de `ne-report`

- `group`: Letra del grupo de laboratorio (ej. `"A"`).
- `subgroup`: Número del subgrupo (ej. `"01"`).
- `session_number`: Número de sesión (ej. `"01"`).
- `deliverable_number`: Número del entregable (ej. `"1"`).
- `session`: Nombre de la sesión académica.
- `topic`: Tema específico (opcional; si se omite, se extrae del campo `session`).
- `authors`: Lista con los nombres de los integrantes.
- `authors_short`: Nombres cortos de autores para el archivo (opcional; si se omite, se deduce del primer apellido de cada autor).
- `course`: Nombre de la asignatura (por defecto: `"NEGOCIOS ELECTRÓNICOS"`).
- `docente`: Nombre del docente (por defecto: `"Dr. Ing. César Baluarte Araya"`).
- `title`: Título principal del informe (por defecto: `"Informe de Entregable e Informe de Investigación Formativa"`).
- `year`: Año lectivo (por defecto: año actual).
- `semester`: Semestre académico (por defecto: `"A"` o `"B"` según la fecha).
- `delivery_type`: Tipo de entrega (por defecto: `"INF"`).
- `stage`: Etapa del entregable (opcional, ej. `"Final"` o `"Previo"`).
- `date`: Fecha de la portada (por defecto: mes y año actual).
- `city`: Ciudad e institución (por defecto: `"Arequipa - Perú"`).
- `logo`: Imagen del escudo en la portada (por defecto: escudo oficial UNSA).
- `custom_variables`: Diccionario con variables adicionales para el renombrado del archivo.

## Funciones adicionales

- `no-indent-block(body)`: Desactiva la sangría automática en el bloque indicado.
- `force-indent-block(body)`: Fuerza la sangría automática en el bloque indicado.
- `define`, `get-var`, `get-all-vars`: Funciones para registrar y consultar metadatos (re-exportadas de `@unsareport/define`).

## Configuración de renombrado

El paquete renombra automáticamente el PDF compilado según el formato configurado en `unsareport.toml`:

```toml
[config-schema.filename_format]
default = "NE Grupo {group} Subgrupo {subgroup} - Sesión {session_number} {deliverable_number} - Inv For {year} {semester} INF - Informe Entregable e Informe Investigación Formativa - {topic} - {authors_short}.pdf"
```

Variables disponibles: `{group}`, `{subgroup}`, `{session_number}`, `{deliverable_number}`, `{year}`, `{semester}`, `{delivery_type}`, `{topic}`, `{stage}`, `{authors_short}`, `{course}`.
