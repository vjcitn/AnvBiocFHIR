#' long URL string for server announced at https://the-anvil.slack.com/archives/C02HU4GT04B/p1634236625021500
#' @param tag character(1) name of store, defaults to "public"
#' @export
anvurl = function (tag="public") 
sprintf("https://healthcare.googleapis.com/v1beta1/projects/fhir-test-9-328816/locations/us-west2/datasets/anvil-test/fhirStores/%s/fhir", tag)

#' long URL string for Asymetrik-based FHIR server
#' @export
asymurl = function() "https://healthcare.googleapis.com/v1/projects/gcp-testing-308520locations/us-east4/datasets/testset/fhirStores/fhirstore/fhir"

#' use pyAnVIL/SMART python infrastructure to connect to FHIR server, 
#' producing instance of `anvil.fhir.client.FHIRClient` (basilisk/reticulate python.builtin.object instance)
#' @param fhirclient from pyAnVIL and/or https://github.com/smart-on-fhir/client-py, assumed to be generated via `abfhir_demo()` in anvil
#' we use `$anvil$fhir$client$FHIRClient`, populating the `settings` field
#' @examples
#' dem = abfhir_demo()
#' sm = connect_smart(dem$anvil$fhir$client$FHIRClient) # clumsy!
#' sm$ready
#' @export
connect_smart = function(fhirclient, fhirurl = asymurl(), app_id="my_app") {
   settings = list(app_id = app_id, api_base = fhirurl)
   sm = fhirclient(settings = settings)
   if (!isTRUE(sm$ready)) message("'ready' was not TRUE, may need to retry when server warms up")
   sm
}
