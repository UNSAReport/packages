# @unsareport/epis-lab

Plantilla para informes de laboratorio de la Escuela Profesional de Ingeniería de Sistemas (UNSA). Incluye membrete institucional, tabla de datos generales y bloques temáticos para secciones de laboratorio.

## Uso

```typst
#import "/components/@unsareport/epis-lab/lib.typ": unsa-report, lab-section, code-block

#show: unsa-report.with(
  course-name: "Calidad de Software",
  lab-title: "Práctica 01",
  lab-number: "01",
  instructor-name: "Docente del Curso",
  members: (
    "Nombre del Estudiante",
  ),
  custom-variables: (
    "course-abbr": "CAS",
    "shortnames-chain": "ESTUDIANTE",
  ),
)

#lab-section("I. Resultados")[
  Contenido de la sección...
]
```

## Parámetros de `unsa-report` / `project`

- `course-name`: Nombre de la asignatura.
- `lab-title`: Título de la práctica.
- `lab-number`: Número de la práctica.
- `instructor-name`: Nombre del docente.
- `members`: Lista con los nombres de los integrantes.
- `year`: Año lectivo (por defecto: año actual).
- `sem-code`: Código de semestre (`"A"` o `"B"`, por defecto calculado según la fecha).
- `presentation-date`: Fecha de presentación (por defecto: fecha actual).
- `presentation-hour`: Hora de presentación (por defecto: `"11:59:00"`).
- `logo-epis`: Imagen para el logo de la EPIS (opcional).
- `logo-abet`: Imagen para el logo de ABET (opcional).
- `custom-variables`: Diccionario con variables adicionales para el renombrado del archivo.

## Funciones adicionales

- `lab-section(title, ..bodies)`: Crea una sección delimitada con encabezado destacado.
- `page-header(...)`: Genera el membrete oficial en el encabezado de página.
- `basic-info-table(...)`: Genera la tabla de información básica del informe.
- `code-block(...)`: Bloque de código estilizado (re-exportado de `@unsareport/gdocs-code-block`).
- `project`: Alias estándar para `unsa-report`.

## Configuración de renombrado

El paquete renombra automáticamente el PDF compilado según el formato configurado en `unsareport.toml`:

```toml
[config-schema.filename_format]
default = "{course-abbr} - LAB{lab-number} - {shortnames-chain}.pdf"
```

Variables disponibles: `{course-name}`, `{course-abbr}`, `{lab-title}`, `{lab-number}`, `{shortnames-chain}`, `{year}`, `{sem-code}`, `{presentation-date}`, `{presentation-hour}`, `{instructor-name}`.
