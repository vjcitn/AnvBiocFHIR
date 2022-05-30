# necessary for python module control
abfhirenv <- basilisk::BasiliskEnvironment(envname="abfhirenv",
    pkgname="AnvBiocFHIR", packages="pandas==1.0.3",
    pip=c("pyAnVIL==0.1.1rc2", "git+https://github.com/smart-on-fhir/client-py#egg=fhirclient==4.0.0"))


#' demonstrate object mediation
#' @param use_basilisk logical(1) defaults to FALSE, to speed up production of interface
#' @note Use basilisk when you want to pin python module versions explicitly
#' @export
abfhir_demo = function(use_basilisk=FALSE) {
 if (!use_basilisk) 
   return(list(anvil=reticulate::import("anvil"), fhirclient=reticulate::import("fhirclient")))
 proc = basilisk::basiliskStart(abfhirenv)
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function() {
   anv = list(anvil=reticulate::import("anvil"), fhirclient=reticulate::import("fhirclient"))
   anv
   })
}

