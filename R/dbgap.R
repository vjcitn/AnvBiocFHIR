
#' produce a table of disease/consent code strings in use at dbGAP
#' @importFrom tibble as_tibble
#' @param use_dedup logical(1) defaults to TRUE; otherwise get the table as posted to slack
#' @note Provided by Chris Wellington of NHGRI in AnVIL slack communication.  The
#' ad hoc deduplication code is given in inst/tsv/dodedup.R.
#' @export
consent_abbrev_map = function(use_dedup=TRUE) {
  file_to_use = "tsv/consent_abbrev_mapping.tsv"
  if (use_dedup) file_to_use = "tsv/dedup_disease_consent_codes.tsv"
  as_tibble( read.delim( system.file(file_to_use, package=
     "AnvBiocFHIR"), sep = "\t" ) )
}

#' produce a table of dbGap consent codes, from Table 1 of https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4721915/
#' @export
consent_codes = function() {
  file_to_use = "consent_codes.tsv"
  as_tibble( read.delim( system.file(file_to_use, package=
     "AnvBiocFHIR"), sep = "\t" ) )
}

#' use FHIR API to get information about a store (possibly resident in AnVIL), using ResearchStudy id
#' @param phstag character(1) defaults to "phs001227"
#' @examples
#' if (interactive()) 
#' j = phs2json()
#' j$entry$resource$description
#' @export
phs2json = function (phstag = "phs001227") jsonlite::fromJSON(sprintf("https://dbgap-api.ncbi.nlm.nih.gov/fhir/x1/ResearchStudy?_id=%s&_format=json", 
    phstag))

#' use FHIR API to get description from a resource (possibly resident in AnVIL), using ResearchStudy id
#' @param phstag character(1) defaults to "phs001227"
#' @export
phs_desc = function (x="phs001227") 
{
    phs2json(x)$entry$resource$description
}
