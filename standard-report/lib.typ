#import "/components/@unsareport/standard-report-theming/lib.typ": *
#import "/components/@unsareport/define/lib.typ": define, get-var, get-all-vars

#let INDENT-OPEN-MARK = "__indent-open"
#let INDENT-CLOSE-MARK = "__indent-close"
#let NO-INDENT-OPEN-MARK = "__no-indent-open"
#let NO-INDENT-CLOSE-MARK = "__no-indent-close"
#let FORCE-INDENT-OPEN-MARK = "__force-indent-open"
#let FORCE-INDENT-CLOSE-MARK = "__force-indent-close"
#let FORCE-INDENT-DEFAULT-LEVEL = 1
#let INDENT-LEVEL-OFFSET = 1
#let INITIAL-HEADING-NUM-WIDTH = 0pt

#let STATE-KEY-HEADING-NUM-WIDTH = "heading-num-width"
#let STATE-KEY-IN-TABLE = "in-table"

#let VAR-TITLE = "title"
#let VAR-COURSE = "course"
#let VAR-COURSE-ABBR = "course_abbr"
#let VAR-TEACHER = "teacher"
#let VAR-DOCENTE = "docente"
#let VAR-GROUP = "group"
#let VAR-ACTIVITY-TYPE = "activity_type"
#let VAR-ACTIVITY-NUMBER = "activity_number"
#let VAR-AUTHORS = "authors"
#let VAR-AUTHORS-SHORT = "authors_short"
#let VAR-YEAR = "year"
#let VAR-UNIVERSITY = "university"
#let VAR-FACULTY = "faculty"
#let VAR-SCHOOL = "school"
#let VAR-CITY-COUNTRY = "city_country"

#let DEFAULT-AUTHORS-SHORT-FALLBACK = "Informe"
#let DEFAULT-LOGO-PATH = "img/logo.png"
#let COVER-LABEL-COURSE = "ASIGNATURA"
#let COVER-LABEL-TEACHER = "DOCENTE"
#let COVER-LABEL-AUTHORS = "INTEGRANTES"
#let FIGURE-SPACE-BELOW = 1.5em
#let TABLE-HEADER-ROW-INDEX = 0

#let heading-num-width = state(STATE-KEY-HEADING-NUM-WIDTH, INITIAL-HEADING-NUM-WIDTH)
#let in-table = state(STATE-KEY-IN-TABLE, false)

#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) == content {
    let f = it.fields()
    if "text" in f {
      f.text
    } else if "children" in f {
      f.children.map(to-string).join("")
    } else if "body" in f {
      to-string(f.body)
    } else if it.func() == [ ].func() {
      " "
    } else {
      ""
    }
  } else {
    ""
  }
}


#let no-indent-block(body) = [
  #metadata(NO-INDENT-OPEN-MARK)
  #body
  #metadata(NO-INDENT-CLOSE-MARK)
]

#let force-indent-block(body) = [
  #metadata(FORCE-INDENT-OPEN-MARK)
  #body
  #metadata(FORCE-INDENT-CLOSE-MARK)
]

#let auto-indent(it) = context {
  let marks = query(selector(metadata).before(here(), inclusive: false))
  let nest-depth = marks.filter(m => m.value == INDENT-OPEN-MARK).len() - marks.filter(m => m.value == INDENT-CLOSE-MARK).len()
  let plain-depth = marks.filter(m => m.value == NO-INDENT-OPEN-MARK).len() - marks.filter(m => m.value == NO-INDENT-CLOSE-MARK).len()
  let force-depth = marks.filter(m => m.value == FORCE-INDENT-OPEN-MARK).len() - marks.filter(m => m.value == FORCE-INDENT-CLOSE-MARK).len()
  let h = query(selector(heading).before(here())).at(-1, default: none)

  if force-depth > 0 {
    if h == none {
      block(inset: (left: indent-width * FORCE-INDENT-DEFAULT-LEVEL))[#it]
    } else {
      let current-num-width = heading-num-width.get()
      block(inset: (left: indent-width * (h.level - INDENT-LEVEL-OFFSET) + current-num-width))[#it]
    }
  } else if plain-depth > 0 {
    it
  } else if in-table.get() {
    it
  } else if nest-depth > 0 {
    it
  } else if h == none {
    it
  } else {
    let current-num-width = heading-num-width.get()
    block(inset: (left: indent-width * (h.level - INDENT-LEVEL-OFFSET) + current-num-width))[#it]
  }
}

#let apply-typography-rules(doc) = {
  set text(
    font: font-family,
    size: font-size,
    hyphenate: font-hyphenate,
    lang: font-lang,
  )
  set par(
    justify: par-justify,
    first-line-indent: par-first-line-indent,
    spacing: par-spacing,
    leading: par-leading,
  )
  doc
}

#let apply-heading-rules(doc) = {
  set heading(numbering: (..nums) => {
    let vals = nums.pos()
    let pattern = range(vals.len()).map(_ => "1").join(".") + "."
    numbering(pattern, ..vals)
  })
  show heading: set text(size: heading-font-size, weight: heading-weight)
  show heading: set block(above: heading-space-above, below: heading-space-below)
  show heading: it => {
    let num-content = if it.numbering != none {
      counter(heading).display(it.numbering)
    } else {
      none
    }
    let current-num-width = if num-content != none {
      measure(num-content).width + num-gutter
    } else {
      INITIAL-HEADING-NUM-WIDTH
    }
    heading-num-width.update(current-num-width)
    block(inset: (left: indent-width * (it.level - INDENT-LEVEL-OFFSET)))[
      #grid(
        columns: (current-num-width, 1fr),
        num-content,
        it.body,
      )
    ]
  }
  doc
}

#let apply-indentation-rules(doc) = {
  show list.item: it => {
    let kids = it.body.at("children", default: none)
    if kids != none and kids.len() > 0 and kids.at(0).func() == metadata and kids.at(0).at("value", default: "") == INDENT-OPEN-MARK {
      it
    } else {
      list.item[#metadata(INDENT-OPEN-MARK)#it.body#metadata(INDENT-CLOSE-MARK)]
    }
  }
  show enum.item: it => {
    let kids = it.body.at("children", default: none)
    if kids != none and kids.len() > 0 and kids.at(0).func() == metadata and kids.at(0).at("value", default: "") == INDENT-OPEN-MARK {
      it
    } else {
      enum.item[#metadata(INDENT-OPEN-MARK)#it.body#metadata(INDENT-CLOSE-MARK)]
    }
  }

  show par: auto-indent
  show enum: auto-indent
  show list: auto-indent
  show bibliography: auto-indent
  show figure: auto-indent
  show raw.where(block: true): auto-indent

  doc
}

#let apply-table-figure-rules(doc) = {
  show figure: it => block(below: FIGURE-SPACE-BELOW)[#it]
  show figure.caption: emph
  show figure.where(kind: table): set block(breakable: true)
  set table.cell(breakable: false)
  show figure.where(kind: table): set text(size: table-text-size)
  show figure.caption.where(kind: table): set text(size: font-size)
  show table.cell.where(y: TABLE-HEADER-ROW-INDEX): set text(weight: table-header-weight)
  set table(
    fill: (col, row) => if row == TABLE-HEADER-ROW-INDEX { table-header-fill } else { none },
    stroke: (x, y) => table-cell-stroke,
  )
  show table: it => {
    in-table.update(true)
    it
    in-table.update(false)
  }
  doc
}


#let register-document-metadata(
  title: "",
  course: "",
  course-abbr: "",
  teacher: "",
  group: "",
  activity-type: "",
  activity-number: "",
  authors: (),
  authors-short: "",
  year: "",
  university: "",
  faculty: "",
  school: "",
  city-country: "",
  custom-variables: (:),
) = {
  define(VAR-TITLE, title)
  define(VAR-COURSE, course)
  define(VAR-COURSE-ABBR, course-abbr)
  define(VAR-TEACHER, teacher)
  define(VAR-DOCENTE, teacher)
  define(VAR-GROUP, group)
  define(VAR-ACTIVITY-TYPE, activity-type)
  define(VAR-ACTIVITY-NUMBER, activity-number)
  define(VAR-AUTHORS, authors)
  define(VAR-AUTHORS-SHORT, authors-short)
  define(VAR-YEAR, year)
  define(VAR-UNIVERSITY, university)
  define(VAR-FACULTY, faculty)
  define(VAR-SCHOOL, school)
  define(VAR-CITY-COUNTRY, city-country)

  for (name, val) in custom-variables {
    define(name, val)
  }
}

#let render-cover-page(
  university: "",
  faculty: "",
  school: "",
  logo: none,
  activity_type: "",
  title: "",
  course: "",
  group: "",
  teacher: "",
  authors: (),
  city_country: "",
  year: "",
) = {
  align(center)[
    #set par(leading: cover-par-leading)
    #strong[#university]\
    #strong[#faculty]\
    #strong[#school]\ \

    #if logo != none {
      logo
      [\ ]
    } else {
      none
    }

    #strong[#activity_type]\
    #title\ \

    #strong[#COVER-LABEL-COURSE]\
    #course\
    #if group != "" [
      #group\
    ]\

    #strong[#COVER-LABEL-TEACHER]\
    #teacher\ \

    #strong[#COVER-LABEL-AUTHORS]\
    #if type(authors) == array {
      authors.join("\n")
    } else {
      authors
    }\
    \

    #strong[#city_country]\
    #strong[#year]
  ]
}

#let render-body-title(title) = {
  align(center)[
    #set text(size: title-text-size, weight: title-weight)
    #block(below: title-space-below)[#title]
  ]
}

#let standard-report(
  title: "",
  authors: (),
  course: "",
  teacher: none,
  docente: none,
  group: "",
  activity_type: default-activity-type,
  activity_number: none,
  course_abbr: none,
  authors_short: none,
  year: none,
  university: default-university,
  faculty: default-faculty,
  school: default-school,
  city_country: default-city-country,
  logo: auto,
  custom_variables: (:),
  doc,
) = {
  let gen-time = datetime.today()
  let resolved-year = if year != none {
    str(year)
  } else {
    str(gen-time.year())
  }

  let resolved-teacher = if teacher != none {
    teacher
  } else if docente != none {
    docente
  } else {
    ""
  }

  let resolved-course-abbr = if course_abbr != none {
    course_abbr
  } else {
    ""
  }

  let resolved-authors-short = if authors_short != none {
    authors_short
  } else if group != "" {
    group
  } else if authors.len() > 0 {
    authors.map(a => a.split(" ").at(0)).join("-")
  } else {
    DEFAULT-AUTHORS-SHORT-FALLBACK
  }

  let resolved-title-str = to-string(title)
  let resolved-logo = if logo == auto {
    image(DEFAULT-LOGO-PATH, width: cover-logo-width)
  } else {
    logo
  }

  register-document-metadata(
    title: resolved-title-str,
    course: course,
    course-abbr: resolved-course-abbr,
    teacher: resolved-teacher,
    group: group,
    activity-type: activity_type,
    activity-number: activity_number,
    authors: authors,
    authors-short: resolved-authors-short,
    year: resolved-year,
    university: university,
    faculty: faculty,
    school: school,
    city-country: city_country,
    custom-variables: custom_variables,
  )

  show: apply-typography-rules
  show: apply-heading-rules
  show: apply-indentation-rules
  show: apply-table-figure-rules

  set page(margin: cover-margin)

  render-cover-page(
    university: university,
    faculty: faculty,
    school: school,
    logo: resolved-logo,
    activity_type: activity_type,
    title: title,
    course: course,
    group: group,
    teacher: resolved-teacher,
    authors: authors,
    city_country: city_country,
    year: resolved-year,
  )

  pagebreak()

  set page(
    paper: page-paper,
    numbering: page-numbering,
    number-align: page-number-align,
    margin: body-margin,
  )
  counter(page).update(1)

  set par(
    justify: par-justify,
    leading: par-leading,
    spacing: par-spacing,
    first-line-indent: par-first-line-indent,
  )

  render-body-title(title)

  doc
}

#let project = standard-report
