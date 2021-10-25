#' get token via gcloud call
#' @export
get_gcp_tokem = function() {
    system("gcloud auth application-default print-access-token", 
        intern = TRUE)
}
