#import "/components/@unsareport/define/lib.typ": define, get-var, get-all-vars

#import "/components/@unsareport/autoindent/lib.typ": *

#let num-gutter = DEFAULT-NUM-GUTTER
#let indent-width = DEFAULT-INDENT-WIDTH

#let default-logo = image("img/unsa-escudo.png", height: 130pt)

#let ne-report(
  university: "UNIVERSIDAD NACIONAL DE SAN AGUSTIN DE AREQUIPA",
  faculty: "FACULTAD DE INGENIERIA DE PRODUCCION Y SERVICIOS",
  school: "ESCUELA PROFESIONAL DE INGENIERIA DE SISTEMAS",
  course: "NEGOCIOS ELECTRÓNICOS",
  docente: "Dr. Ing. César Baluarte Araya",
  title: "Informe de Entregable e Informe de Investigación Formativa",
  session: "Sesión: Negocios Electrónicos",
  topic: none,
  group: "A",
  subgroup: "01",
  session_number: "01",
  deliverable_number: "1",
  year: none,
  semester: none,
  delivery_type: "INF",
  stage: none,
  authors: (),
  authors_short: none,
  date: none,
  city: "Arequipa - Perú",
  logo: auto,
  custom_variables: (:),
  body,
) = {
  let gen-time = datetime.today()
  let resolved-year = if year != none { str(year) } else { str(gen-time.year()) }
  let resolved-semester = if semester != none { semester } else { if gen-time.month() < 8 { "A" } else { "B" } }
  let resolved-date = if date != none {
    date
  } else {
    let months = ("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "setiembre", "octubre", "noviembre", "diciembre")
    resolved-year + " " + months.at(gen-time.month() - 1)
  }

  let resolved-topic = if topic != none {
    topic
  } else if session.contains(" - ") {
    session.split(" - ").slice(1).join(" - ")
  } else {
    session
  }

  let resolved-authors-short = if authors_short != none {
    authors_short
  } else if authors.len() > 0 {
    authors.map(a => a.split(" ").at(0)).join("-")
  } else {
    "Grupo"
  }

  define("university", university)
  define("faculty", faculty)
  define("school", school)
  define("course", course)
  define("docente", docente)
  define("title", title)
  define("session", session)
  define("topic", resolved-topic)
  define("group", group)
  define("subgroup", subgroup)
  define("session_number", session_number)
  define("deliverable_number", deliverable_number)
  define("year", resolved-year)
  define("semester", resolved-semester)
  define("delivery_type", delivery_type)
  if stage != none { define("stage", stage) }
  define("authors", authors)
  define("authors_short", resolved-authors-short)
  define("date", resolved-date)
  define("city", city)

  for (name, val) in custom_variables {
    define(name, val)
  }

  set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  )
  set text(
    font: ("Times New Roman", "Liberation Serif"),
    size: 12pt,
    lang: "es",
  )
  set par(
    leading: 0.65em,
    justify: true,
  )
  set heading(numbering: (..nums) => {
    let vals = nums.pos()
    if vals.len() == 1 {
      numbering("1.", vals.last())
    } else {
      numbering("a.", vals.last())
    }
  })
  show heading: set text(size: 12pt)
  show figure.where(kind: table): set block(breakable: true)
  set table.cell(breakable: false)

  show heading: it => indent-heading(
    it,
    indent-width: indent-width,
    num-gutter: num-gutter,
    indent-level-offset: INDENT-LEVEL-OFFSET,
  )

  show: doc => autoindent(
    doc,
    indent-width: indent-width,
    num-gutter: num-gutter,
    indent-level-offset: INDENT-LEVEL-OFFSET,
    force-level: FORCE-INDENT-DEFAULT-LEVEL,
    include-heading: false,
  )

  set table(
    inset: (x: 8pt, y: 6pt),
    fill: (x, y) => if y == 0 { rgb("#edf2f7") } else { none },
  )
  show table.cell.where(y: 0): set text(weight: "bold")

  block(
    width: 100%,
    height: 100%,
  )[
    #align(center)[
      #set par(leading: 1.5em)
      #text(
        size: 16pt,
        weight: "bold",
      )[#university] \
      #text(
        size: 14pt,
        weight: "bold",
      )[#faculty] \
      #text(
        size: 14pt,
        weight: "bold",
      )[#school]
    ]

    #v(16pt)
    #let resolved-logo = if logo == auto {
      default-logo
    } else {
      logo
    }
    #if resolved-logo != none {
      align(center)[#resolved-logo]
      v(24pt)
    }

    #text(size: 16pt)[
      #grid(
        columns: (105pt, 1fr),
        row-gutter: 30pt,
        [Curso:], [#course],
        [Docente:], [#docente],
      )
    ]

    #v(16pt)
    #align(center)[
      #set par(leading: 1.2em)
      #text(
        size: 15pt,
        weight: "bold",
      )[#title] \
      #text(
        size: 15pt,
        weight: "bold",
      )[#session]
    ]

    #v(24pt)
    #text(size: 14pt)[
      #grid(
        columns: (130pt, 1fr),
        row-gutter: 8pt,
        ..authors.enumerate().map(e => (
          if e.at(0) == 0 { [Elaborado por:] } else { [] },
          [#e.at(1)],
        )).flatten(),
      )
    ]

    #v(18pt)
    #text(size: 14pt)[
      #grid(
        columns: (1fr, auto),
        gutter: 25pt,
        [
          #set par(spacing: 0.75em)
          Observaciones.- #box(width: 1fr)[#repeat[-]]
          #repeat[-]
          #repeat[-]
          #repeat[-]
        ],
        align(top + right)[
          Nota: #box(width: 75pt, baseline: -1pt)[#line(length: 100%, stroke: 0.8pt)]
        ],
      )
    ]

    #v(1fr)
    #align(center)[
      #text(size: 14pt)[
        #resolved-date \
        #v(3pt)
        #city
      ]
    ]
  ]

  pagebreak()

  [Índice General]

  outline(
    title: none,
    indent: auto,
  )

  pagebreak()

  body
}
