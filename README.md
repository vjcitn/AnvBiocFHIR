# AnvBiocFHIR

This README is updated 26 April 2022.

A thorough introduction to FHIR in the NIH Cloud Interoperability project is provided in 
a [jupyter notebook](https://github.com/NIH-NCPI/fhir-101/blob/master/FHIR%20101%20-%20Practical%20Guide.ipynb) last edited in July 2020.

In the RStudio console, in April 2022, use
```
pip install pyAnVIL==0.1.0rc6
pip install git+https://github.com/smart-on-fhir/client-py#egg=fhirclient==4.0.0
```
to obtain necessary infrastructure.

The R package at [github.com/vjcitn/AnvBiocFHIR](https://github.com/vjcitn/AnvBiocFHIR) uses basilisk
to pin down all details of python infrastructure used to interface to the FHIR services in AnVIL.

## Installation steps

Update the version of `AnvBiocFHIR` with

```
BiocManager::install("vjcitn/AnvBiocFHIR")
```

Instantiate the python infrastructure with
```
x = try(AnvBiocFHIR::abfhir_demo()) # will fail after some time!  (This is a one-time operation for a given cloud environment.)
```
This may take some time to construct a conda environment.  (As the infrastructure matures we will be able to skip this step, but not now.)

Use (after verifying values of version tags; these work with Bioc 3.14 and AnvBiocFHIR 0.0.9) the following in the Rstudio terminal:
```
cp -r ~/.local/lib/python3.7/site-packages/* /home/rstudio/.cache/R/basilisk/1.6.0/AnvBiocFHIR/0.0.9/abfhirenv/lib/python3.7/site-packages
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
example(connect_smart)
```

On 26 Apr 2022 the result is
```
> unlist(lapply(res[1:5], function(x) x$id))
[1] "AnVIL-CMG-Broad-Muscle-Myoseq-WES"       
[2] "AnVIL-CMG-Broad-Orphan-Estonia-Ounap-WGS"
[3] "AnVIL-CMG-Broad-Brain-Gleeson-WES"       
[4] "AnVIL-CMG-Broad-Muscle-Topf-WES"         
[5] "AnVIL-CCDG-Broad-CVD-AFib-Duke-WGS"     
```
