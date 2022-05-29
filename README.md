# AnvBiocFHIR

This README is updated 29 May 2022.

A thorough introduction to FHIR in the NIH Cloud Interoperability project is provided in 
a [jupyter notebook](https://github.com/NIH-NCPI/fhir-101/blob/master/FHIR%20101%20-%20Practical%20Guide.ipynb) last edited in July 2020.

The R package at [github.com/vjcitn/AnvBiocFHIR](https://github.com/vjcitn/AnvBiocFHIR) uses basilisk
to pin down all details of python infrastructure used to interface to the FHIR services in AnVIL.

## Installation steps

Ensure that the .Renviron file in the home folder has a line `PIP_USER=false`.

Verify that the setting of `PIP_USER` is `"false"` using `Sys.getenv("PIP_USER")`.

Install the package:

```
BiocManager::install("vjcitn/AnvBiocFHIR")
```

Instantiate the python infrastructure with
```
x = try(AnvBiocFHIR::abfhir_demo()) 
```
This will take some time to construct a conda environment.  

Evaluate `x` to see a list of two `Module` objects produced by reticulate.

## Demonstration

```
library(AnvBiocFHIR)
example(connect_smart)
```

On 29 May 2022 the result is
```
> unlist(lapply(res[1:5], function(x) x$id))
[1] "AnVIL-CMG-Broad-Muscle-Myoseq-WES"       
[2] "AnVIL-CMG-Broad-Orphan-Estonia-Ounap-WGS"
[3] "AnVIL-CMG-Broad-Brain-Gleeson-WES"       
[4] "AnVIL-CMG-Broad-Muscle-Topf-WES"         
[5] "AnVIL-CCDG-Broad-CVD-AFib-Duke-WGS"     
```
