#' produce vector of names of stores in FHIR server
#' @note uses `anv_fhir_get_stores`
#' @examples
#' allst = list_stores()
#' length(allst)
#' head(allst)
#' @export
list_stores = function() {
   st = anv_fhir_get_stores()
   sapply(st[[1]], function(x) basename(x$name))
}

#' provide information on all resources in a store
#' @param store character(1) a store name, defaults to `"public"`
#' @param as.json logical(1) apply the `as_json()` method before returning, useful for parallelization
#' @param \dots passed to `anv_fire_test_resources`
#' @note You can't hand back python objects from worker nodes, so set `as.json = TRUE` in such settings.
#' @export
store_resources = function(store="public", as.json=FALSE, ...) {
   ans = anv_fhir_test_resources(anvurl(store), ...)
   if (as.json) return(lapply(ans, function(x) x$as_json()))
   ans
}

#' very rudimentary helper for rendering condition information
#' @param x a list assumed to have element `coding` with standard substructure components `display`, `code`
#' @export
simplify_condition = function(x) 
  sapply(x, function(x) paste(x$coding[[1]]$display, x$coding[[1]]$code, sep=", "))

#' acquire information on conditions in a resource
#' @param res either a resource reference or a list
#' @param simplify logical(1) if TRUE, condition data are simplified
#' @export
resource_conditions = function(res, simplify=TRUE) {
    if (inherits(res, "python.builtin.object")) j = res$as_json()
    f = force
    if (simplify) f = simplify_condition
    ifelse(is.null(j$condition), "no condition given", f(j$condition))
    }

#' acquire title for a resource
#' @param res either a resource reference or a list
#' @export
resource_title = function(res) res$as_json()$title
