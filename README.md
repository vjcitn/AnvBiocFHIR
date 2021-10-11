# AnvBiocFHIR
FHIR interfaces via Bioconductor in AnVIL

New container with SMART infrastructure.

The R package at [github.com/vjcitn/AnvBiocFHIR](https://github.com/vjcitn/AnvBiocFHIR) uses basilisk
to pin down all details of python infrastructure used to interface to the FHIR services in AnVIL.

## Using the SMART FHIR client infrastructure with R

We use the docker container `vjcitn/anvbiocfhir:0.0.2`.

To generate `"1000g-high-coverage-2019"`, we can use

```
library(AnvBiocFHIR)
library(reticulate)
x = abfhir_demo()
fc = import("fhirclient") # this should be part of abfhir_setup
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
