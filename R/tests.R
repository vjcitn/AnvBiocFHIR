#' test extraction of studies for a given store
#' @param url character(1) URL for a FHIR store
#' @param count_str character(1) `_count` value for `where` in ResearchStudy
#' @param pyrefs list of Module references (anvil, fhirclient)
#' @examples 
#' t1 = anv_fhir_test_resources()
#' length(t1)
#' @export
anv_fhir_test_resources = function(url = anvurl(), count_str = "1000", pyrefs = abfhir_demo()) {
  sm = connect_smart(
        fhirclient = pyrefs$anvil$fhir$client$FHIRClient, 
        fhirurl = url) 
  stopifnot(sm$ready)
  rs = pyrefs$fhirclient$models$researchstudy
  rs$ResearchStudy$where(reticulate::py_dict("_count", count_str))$perform_resources(sm$server)
}

#' test extraction of Patient from a given store
#' @param url character(1) URL for a FHIR store
#' @param count_str character(1) `_count` value for `where` in ResearchStudy
#' @param pyrefs list of Module references (anvil, fhirclient)
#' @examples 
#' t1 = anv_fhir_test_find_patient(url=anvurl("phs002282-DS-CVDRF")) # should be more universal
#' length(t1)
#' t1[[1]]$as_json()
#' @export
anv_fhir_test_find_patient = function(url = anvurl(), id = "H_WX-999-999", pyrefs = abfhir_demo()) {
  sm = connect_smart(
    fhirclient = pyrefs$anvil$fhir$client$FHIRClient, 
    fhirurl = url) 
  stopifnot(sm$ready)
  pp = pyrefs$fhirclient$models$patient$Patient
  pp$where(reticulate::py_dict("identifier", id))$perform_resources(sm$server)
}

#' URL for fhirStores FHIR structure
#' @export
test_stores_url = function() 'https://healthcare.googleapis.com/v1/projects/gcp-testing-308520/locations/us-east4/datasets/testset/fhirStores/fhirstore/fhir'

#' retrieve references to all stores
#' @param url character(1) URL for a FHIR store collection
#' @param count_str character(1) `_count` value for `where` in ResearchStudy
#' @param pyrefs list of Module references (anvil, fhirclient)
#' @examples 
#' allst = anv_fhir_get_stores()
#' length(allst)
#' head(sapply(allst, function(x) x$title))
#' @export
anv_fhir_get_stores = function(url=test_stores_url(), count_str = "1000", pyrefs = abfhir_demo()) {
  sm = connect_smart(
        fhirclient = pyrefs$anvil$fhir$client$FHIRClient, 
        fhirurl = url) 
  stopifnot(sm$ready)
  rs = pyrefs$fhirclient$models$researchstudy
  rs$ResearchStudy$where(py_dict("_count", count_str))$perform_resources(sm$server)
}

