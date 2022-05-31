#' manage information on FHIR stores and contents
#' @export
setClass("AnVILFHIRSet",
         slots=list(FHIRURLList = "list",
                    studies = "list", json="list", avtables="list", nsamples="numeric"))
#' concise display for AnVILFHIRSet
#' @export
setMethod("show", "AnVILFHIRSet", function(object) {
  cat(sprintf("AnVILFHIRSet instance for %d stores\n", length(slot(object, "FHIRURLList"))))
  cat(sprintf("   There are %d samples from %d studies.\n", slot(object, "nsamples"), length(slot(object, "studies"))))
})

#' constructor 
#' @param urllist list of URLs for FHIR stores
#' @param verbose logical(1) messages printed by stages
#' @export
AnVILFHIRSet = function(urllist, verbose=TRUE) {
  stopifnot(is(urllist, "list"))
  interfaces = abfhir_demo()  # gets fhirclient and anvil references
  if (verbose) message("connect_smart...")
  sm = connect_smart( interfaces$anvil$fhir$client$DispatchingFHIRClient, fhirurls=urllist)
  Sys.sleep(1)
  stopifnot(sm$ready)
  if (verbose) message("perform resources ...")
  avail_resch = interfaces$fhirclient$models$researchstudy
  res = avail_resch$ResearchStudy$where(reticulate::py_dict("", ""))$perform_resources(sm$server)
  obj = new("AnVILFHIRSet", FHIRURLList=urllist, studies = res)
  alljs = lapply(res, function(x)x$as_json())
  slot(obj, "json") = alljs
  allids = thinids(obj)
  inds = grep("anvil-datastorage", allids[,1])
  wsn = allids[inds,2]
  if (verbose) message("get tables...")
  alltab = lapply(wsn, function(x) AnVIL::avtables("anvil-datastorage", x))
  slot(obj, "avtables") = alltab
  nsamp = sum(sapply(alltab, function(x) x|>filter(table=="sample")|>select(count)|>as.integer()))
  slot(obj, "nsamples") = nsamp
  obj
}

thinids = function(x) {
   stopifnot(is(x, "AnVILFHIRSet"))
   studs = slot(x, "studies")
   js = lapply(studs, function(x) x$as_json())
   allids = lapply(js, function(x) x$identifier) # list of lists of pairs system/value
   allsys = sapply(allids, function(x) sapply(x, function(z) z$system))
   allval = sapply(allids, function(x) sapply(x, function(z) z$value))
   data.frame(system=as.character(allsys), value=as.character(allval))
}

#' extract names of studies
#' @param x AnVILFHIRSet instance
#' @export
study_names = function(x) {
  stopifnot(is(x, "AnVILFHIRSet"))
  sapply(slot(x, "json"), function(x) x$identifier[[1]]$value) #presumptuous
}
  
