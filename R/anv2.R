
#prepref = pp$where(reticulate::py_dict("_count", count_str))
#postp1 = prepref$perform(sm$server)
#links = lapply(postp1$link, function(x) x$as_json()$url)
#ulinks = unique(unlist(us))

anv2 = function(url=anvurl(), count_str="1000",
                pyrefs=abfhir_demo(), as.json=FALSE) {
  sm = connect_smart(fhirclient = pyrefs$anvil$fhir$client$FHIRClient,
                     fhirurl = url)
  stopifnot(sm$ready)
  rs = pyrefs$fhirclient$models$researchstudy$ResearchStudy
  pp = pyrefs$fhirclient$models$patient$Patient
  rsdat = rs$where(reticulate::py_dict("", ""))$perform_resources(sm$server)
  prepref = pp$where(reticulate::py_dict("_count", count_str))
  postp1 = prepref$perform(sm$server)
  links = lapply(postp1$link, function(x) x$as_json()$url)
  ulinks = unique(unlist(links))
  stopifnot(length(ulinks)>0)
  if (length(ulinks)==1)
    ans = pp$where(reticulate::py_dict("_count", count_str))$perform_resources(sm$server)
  else {
    tmp = lapply(ulinks,
                 function(x) {
                   dictargs = getparms(x)
                   print(dictargs)
                   pp$where(dictargs)$perform_resources(sm$server)
                 }
    )
    ans = unlist(tmp, recursive=FALSE)
  }
  if (as.json) ans = lapply(ans, function(x) x$as_json())
  list(title=rsdat[[1]]$title, pats=ans)
}

getparms = function(x) {
  tail = gsub("^.*fhir/Patient/\\?", "", x)
  parts = strsplit(tail, "&")
  parts = strsplit(parts[[1]], "=") # only one token, assumes one ampersand
  ff = sapply(parts, "[", 1)
  vv = lapply(parts, "[", 2)
  names(vv) = ff
  reticulate::r_to_py(vv, convert=TRUE)
}
