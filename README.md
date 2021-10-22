# AnvBiocFHIR

FHIR interfaces via Bioconductor in AnVIL -- Terra workspace "biocfhir-new2" was introduced by stvjc@channing.harvard.edu October 2021.

A thorough introduction to FHIR in the NIH Cloud Interoperability project is provided in 
a [jupyter notebook](https://github.com/NIH-NCPI/fhir-101/blob/master/FHIR%20101%20-%20Practical%20Guide.ipynb) last edited in July 2020.

This workspace is intended to be used with a custom cloud environment to which pyAnVIL and SMART infrastructure have been added.
Dockerfiles are [available](https://github.com/vjcitn/AnvBiocFHIR/tree/main/Dockerfiles).

The R package at [github.com/vjcitn/AnvBiocFHIR](https://github.com/vjcitn/AnvBiocFHIR) uses basilisk
to pin down all details of python infrastructure used to interface to the FHIR services in AnVIL.

## Quick view of [open] patient data

![](https://storage.googleapis.com/bioc-anvil-images/jsoned.png)

produced with this workspace via

```
> library(AnvBiocFHIR)
> library(reticulate)
> x = abfhir_demo()
> fc = import("fhirclient")
> pp = fc$models$patient$Patient
> pats = pp$where(py_dict("", ""))$perform_resources(smartBase$server)
> jpats = lapply(pats, function(x) x$as_json())
> listviewer::jsonedit(jpats) # may need to install listviewer package 
```

## Using the SMART FHIR client infrastructure with R

### Impromptu creation and use of SMART FHIRClient -- note FIXME

We use the docker container `vjcitn/anvbiocfhir:0.0.2`.

To generate `"1000g-high-coverage-2019"`, we can use

```
library(AnvBiocFHIR)
library(reticulate)
x = abfhir_demo()
fc = import("fhirclient") # FIXME: this should be part of abfhir_setup
# py_help(x$fhir$client)
ll = list(app_id = "my_web_app", 
  api_base=paste("https://healthcare.googleapis.com/v1/projects/gcp-testing-308520/",
      "locations/us-east4/datasets/testset/fhirStores/fhirstore/fhir", sep=""))
FHIRclient = x$fhir$client$FHIRClient
smartBase = FHIRclient(settings=ll)
smartBase$ready
rs = fc$models$researchstudy
rs$ResearchStudy$where(py_dict("", ""))$perform_resources(smartBase$server)[[1]]$title
```

FIXME: the abfhir_demo is a quick-and-dirty demonstration of basilisk.  The interface
should arrange import of `fhirclient` as well, but more design work is needed, Oct 11 2021.

Of greater interest is the intermediate information in
```
res = rs$ResearchStudy$where(py_dict("", ""))$perform_resources(smartBase$server)
```
```
> names(res[[1]])
 [1] "arm"                   "as_json"               "category"              "condition"             "contact"              
 [6] "contained"             "create"                "delete"                "description"           "didResolveReference"  
[11] "elementProperties"     "enrollment"            "extension"             "focus"                 "id"                   
[16] "identifier"            "implicitRules"         "keyword"               "language"              "location"             
[21] "meta"                  "modifierExtension"     "note"                  "objective"             "origin_server"        
[26] "owningBundle"          "owningResource"        "partOf"                "period"                "phase"                
[31] "primaryPurposeType"    "principalInvestigator" "protocol"              "read"                  "read_from"            
[36] "reasonStopped"         "relatedArtifact"       "relativeBase"          "relativePath"          "resolvedReference"    
[41] "resource_type"         "search"                "site"                  "sponsor"               "status"               
[46] "text"                  "title"                 "update"                "update_with_json"      "where"                
[51] "with_json"             "with_json_and_owner"  
```

Very little of this schema has been populated:
```
> names(res[[1]]$as_json())
[1] "id"                    "meta"                  "extension"             "identifier"            "principalInvestigator"
[6] "sponsor"               "status"                "title"                 "resourceType"         
```
### Probing the service

The `prepare` and `authorize_url` methods are discussed at the [SMART client README](https://github.com/smart-on-fhir/client-py).

```
> smartBase = FHIRclient(settings=ll)
> names(smartBase)
 [1] "app_id"          "app_secret"      "authorize_url"   "desired_scope"  
 [5] "from_state"      "handle_callback" "human_name"      "launch_context" 
 [9] "launch_token"    "patient"         "patient_id"      "prepare"        
[13] "ready"           "reauthorize"     "redirect"        "reset_patient"  
[17] "save_state"      "scope"           "server"          "state"          
[21] "wants_patient" 
```

## Historical material

We use the docker container `vjcitn/anvbiocfhir:0.0.1`.

### Verifying python infrastructure

Starting out, we want to be able to run
```
from fhirclient import client
from anvil.fhir.smart_auth import GoogleFHIRAuth
from anvil.fhir.client import FHIRClient
settings = {
            'app_id': 'my_web_app',
            'api_base': 'https://healthcare.googleapis.com/v1/projects/gcp-testing-308520/locations/us-east4/datasets/testset/fhirStores/fhirstore/fhir'
}
smart = FHIRClient(settings=settings)
assert smart.ready, "server should be ready"
        # search for all ResearchStudy
import fhirclient.models.researchstudy as rs

[s.title for s in rs.ResearchStudy.where(struct={}).perform_resources(smart.server)]
```
without lengthy installation delays.

It works:
```
>>> [s.title for s in rs.ResearchStudy.where(struct={}).perform_resources(smart.server)]
['1000g-high-coverage-2019', 'my NCPI research study example']
>>> 
```

### Bridging to R

The R package at [github.com/vjcitn/AnvBiocFHIR](https://github.com/vjcitn/AnvBiocFHIR) uses basilisk
to pin down all details of python infrastructure used to interface to the FHIR services in AnVIL.  When
we use R CMD INSTALL with this package, and then `abfhir_demo()`, the basilisk utilities install the
pyAnVIL and SMART python software in `$HOME/.local`.  We need to copy them into the basilisk cache
area:

```
cp -r ~/.local/lib/python3.7/site-packages/* /home/rstudio/.cache/R/basilisk/1.5.0/AnvBiocFHIR/0.0.1/abfhirenv/lib/python3.7/site-packages
```

Once this has been done, we have

```
library(AnvBiocFHIR)
dem = abfhir_demo()
reticulate::py_help(dem$fhir$client)
```

to produce

```
NAME
    anvil.fhir.client

CLASSES
    fhirclient.client.FHIRClient(builtins.object)
        FHIRClient
    
    class FHIRClient(fhirclient.client.FHIRClient)
     |  FHIRClient(*args, **kwargs)
     |  
     |  Instances of this class handle authorizing and talking to Google Healthcare API FHIR Service.
     |  
     |  Parameters:
     |      See https://github.com/smart-on-fhir/client-py/blob/master/fhirclient/client.py#L19
     |  
     |  Returns:
     |      Instance of client, with injected authorization method
```
