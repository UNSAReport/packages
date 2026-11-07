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

#include "sections/1-resultados.typ"
#v(0.5em)
#include "sections/2-conclusiones.typ"
