% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tests.R
\name{anv_fhir_test_resources}
\alias{anv_fhir_test_resources}
\title{test extraction of studies for a given store}
\usage{
anv_fhir_test_resources(
  url = anvurl(),
  count_str = "1000",
  pyrefs = abfhir_demo()
)
}
\arguments{
\item{url}{character(1) URL for a FHIR store}

\item{count_str}{character(1) `_count` value for `where` in ResearchStudy}

\item{pyrefs}{list of Module references (anvil, fhirclient)}
}
\description{
test extraction of studies for a given store
}
\examples{
t1 = anv_fhir_test_resources()
length(t1)
}
