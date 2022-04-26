#' long URL string for server announced at https://the-anvil.slack.com/archives/C02HU4GT04B/p1634236625021500
#' @param tag character(1) name of store, defaults to "public"
#' @note need to ensure project_tag is appropriate over time
#' @export
anvurl = function (tag="public", project_tag = "fhir-test-16-342800") 
sprintf("https://healthcare.googleapis.com/v1beta1/projects/%s/locations/us-west2/datasets/anvil-test/fhirStores/%s/fhir", project_tag, tag)

#' long URL string for Asymetrik-based FHIR server
#' @export
asymurl = function() "https://healthcare.googleapis.com/v1/projects/gcp-testing-308520locations/us-east4/datasets/testset/fhirStores/fhirstore/fhir"

#' use pyAnVIL/SMART python infrastructure to connect to FHIR server, 
#' producing instance of `anvil.fhir.client.FHIRClient` (basilisk/reticulate python.builtin.object instance)
#' @param fhirclient from pyAnVIL and/or https://github.com/smart-on-fhir/client-py, assumed to be generated via `abfhir_demo()` in anvil
#' we use `$anvil$fhir$client$FHIRClient`, populating the `settings` field
#' @examples
#' dem = abfhir_demo()
#' sm = connect_smart(dem$anvil$fhir$client$DispatchingFHIRClient) # can handle list of stores
#' sm$ready
#' avail_resch = dem$fhirclient$models$researchstudy
#' res = avail_resch$ResearchStudy$where(reticulate::py_dict("", ""))$perform_resources(sm$server)
#' length(res)
#' unlist(lapply(res[1:5], function(x) x$id))
#' @export
connect_smart = function(fhirclient, fhirurls = list(anvurl()), app_id="my_app") {
#
# FIXME: Here is where a list of 'stores' can be used to prepare access to 
# many resources, and a shiny app would be useful.  Consider three levels
# of user contact: tech, which interacts with pyAnVIL, app developer,
# which connects app with investigational objectives, and "user/programmer"
# running interactive sessions in Rstudio
#
   settings = list(app_id = app_id, api_bases = fhirurls)
   sm = fhirclient(settings = settings)
   if (!isTRUE(sm$ready)) message("'ready' was not TRUE, may need to retry when server warms up")
   sm
}
