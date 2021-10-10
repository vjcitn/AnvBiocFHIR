# necessary for python module control
abfhirenv <- basilisk::BasiliskEnvironment(envname="abfhirenv",
    pkgname="AnvBiocFHIR", packages="pandas==1.0.3",
    pip=c("pyAnVIL==0.0.9rc2", "git+https://github.com/smart-on-fhir/client-py#egg=fhirclient==4.0.0"))


#' demonstrate object mediation
#' @export
abfhir_demo = function() {
 proc = basilisk::basiliskStart(abfhirenv)
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function() {
   anv = reticulate::import("anvil")
   anv
   })
}

