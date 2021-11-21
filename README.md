# AnvBiocFHIR

FHIR interfaces via Bioconductor in AnVIL -- Terra workspace "biocfhir-new2" was introduced by stvjc@channing.harvard.edu October 2021.

A thorough introduction to FHIR in the NIH Cloud Interoperability project is provided in 
a [jupyter notebook](https://github.com/NIH-NCPI/fhir-101/blob/master/FHIR%20101%20-%20Practical%20Guide.ipynb) last edited in July 2020.

This workspace is intended to be used with a custom cloud environment to which pyAnVIL and SMART infrastructure have been added.
Dockerfiles are [available](https://github.com/vjcitn/AnvBiocFHIR/tree/main/Dockerfiles).

The R package at [github.com/vjcitn/AnvBiocFHIR](https://github.com/vjcitn/AnvBiocFHIR) uses basilisk
to pin down all details of python infrastructure used to interface to the FHIR services in AnVIL.

## Installation steps

We use the docker container `vjcitn/anvbiocfhir:0.0.4`.

Update the version of `AnvBiocFHIR` with

```
BiocManager::install("vjcitn/AnvBiocFHIR")
```

Instantiate the python infrastructure with
```
x = try(AnvBiocFHIR::abfhir_demo()) # will fail after some time!  (This is a one-time operation for a given cloud environment.)
```
This may take some time to construct a conda environment.  (As the infrastructure matures we will be able to skip this step, but not now.)

Use (after verifying values of version tags)  the following in the Rstudio terminal:
```
cp -r ~/.local/lib/python3.7/site-packages/* /home/rstudio/.cache/R/basilisk/1.6.0/AnvBiocFHIR/0.0.3/abfhirenv/lib/python3.7/site-packages
```

After this command is used in Rstudio terminal, return to console and use
```
x = try(AnvBiocFHIR::abfhir_demo())
```
Because the python infrastructure migrated to the basilisk cache, this should now succeed.  We will try to reduce the complexity
of these operations.


## Demonstration

```
library(AnvBiocFHIR)
dem = abfhir_demo()
aurl = anvurl() # .../anvil-test/fhirStores/public/fhir
sm = connect_smart(fhirclient=dem$anvil$fhir$client$DispatchingFHIRClient, fhirurl=aurl) # clumsy, will design object later
sm$ready # if FALSE, wait a bit and try again
rs = dem$fhirclient$models$researchstudy
#> names(rs)
# [1] "annotation"             "backboneelement"        "codeableconcept"        "contactdetail"         
# [5] "domainresource"         "fhirreference"          "identifier"             "period"                
# [9] "relatedartifact"        "ResearchStudy"          "ResearchStudyArm"       "ResearchStudyObjective"
#[13] "sys"                   
#rs$ResearchStudy$where(reticulate::py_dict("", ""))$perform_resources(sm$server)[[1]]
#<fhirclient.models.researchstudy.ResearchStudy>
res_100 = rs$ResearchStudy$where(reticulate::py_dict("", ""))$perform_resources(sm$server)
unlist(lapply(res_100[1:5], function(x) x$title))
```

On 23 Oct 2021 the result is
```
[1] "VIL-NIMH-Broad-ConvergentNeuro-McCarroll-Eggan-Finkel-SMA-DS-WGS"
[2] "AnVIL-NIMH-Broad-WGSPD1-McCarroll-Braff-DS-10XLRGenomes"         
[3] "AnVIL-NIMH-Broad-WGSPD1-McCarroll-Braff-DS-WGS"                  
[4] "AnVIL-NIMH-Broad-ConvergentNeuro-McCarroll-Eggan-CIRM-GRU-WGS"   
[5] "AnVIL-NIMH-Broad-WGSPD1-McCarroll-Pato-GRU-10XLRGenomes"
```
with a possible typo in the first element.
