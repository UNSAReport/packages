#import "/components/@unsareport/standard-report/lib.typ": standard-report, no-indent-block, force-indent-block

#show: standard-report.with(
  pretitle: "ACTIVIDAD PRÁCTICA",
  title: [TÍTULO DEL INFORME O ACTIVIDAD PRÁCTICA],
  course: "GESTIÓN DE PROYECTOS DE SOFTWARE",
  group: "TURNO A - GRUPO 1",
  teacher: "MG. DOCENTE DEL CURSO",
  activity_code: "T1",
  authors: (
    "Integrante 1",
    "Integrante 2",
  ),
)

#include "sections/1-introduccion.typ"
#include "sections/2-desarrollo.typ"
#include "sections/3-conclusiones.typ"
