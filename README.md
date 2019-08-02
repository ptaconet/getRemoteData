
<!-- README.md is generated from README.Rmd. Please edit that file -->

# getRemoteData

<!-- badges: start -->

<!-- badges: end -->

`getRemoteData` is a set of R functions that offer a common grammar to
query and import remote data from heterogeneous sources. Overall, this
package attempts to **facilitate** and **speed-up** the painfull and
time-consuming **data import / download** process for some well-known
and widely used environmental / climatic data (e.g.
[MODIS](https://modis.gsfc.nasa.gov/),
[GPM](https://www.nasa.gov/mission_pages/GPM/main/index.html), etc.) as
well as other sources (e.g. [VIIRS
DNB](https://ngdc.noaa.gov/eog/viirs/download_dnb_composites.html),
etc.). You will take the best of `getRemoteData` if you work at **local
to regional** spatial scales, i.e. typically from few decimals to a
decade squared degrees. For larger areas, other packages might be more
relevant (e.g. [`getSpatialData`](http://jxsw.de/getSpatialData/)).

**Why such a package ?**

Modeling an ecological phenomenon (e.g. species distribution) using
environmental data (e.g. temperature, rainfall) is quite a common task
in ecology. The data analysis workflow generally consists in :

  - importing, tidying and summarizing various environmental data at
    geographical locations and dates of interest ;
  - creating explicative / predictive models of the phenomenon using the
    environmental data.

Data of interest for a specific study are usually heterogeneous (various
sources, formats, etc.). Downloading long time series of several
environmental data “manually” (e.g. through user-friendly web portals)
is time consuming and is not reproducible. In addition, when downloaded
manually, spatial datasets might cover quite large areas, or include
many dimensions (e.g. the multiple bands for a MODIS product). If your
aera of interest is smaller or if you do not need all the dimensions,
why donwloading the whole dataset ? Whenever possible (i.e. made
possible by the data provider - check section [Behind the scene… how it
works](#%20Behind%20the%20scene...%20how%20it%20works)), `getRemoteData`
enables to download the data strictly for your region and dimensions of
interest.

**When should you use `getRemoteData` ?**

You might have a deeper look at `getRemoteData` if you recognize
yourself in one or more of the following points :

  - work at a local to regional spatial scale ;
  - need to import data from various sources (e.g. MODIS, GPM, etc.) ;
  - are interested in importing long climatic / environmental
    time-series ;
  - have a slow internet connection ;
  - care about the digital environmental impact of your work.

`getRemoteData` is developed in the frame of Phd project, and the
sources of data implemented in the package are hence those that I use in
my work. Sources of data are mostly environmental / climatic data, but
not exclusively. Have a look at the function ‘getAvailableDataSources’
to check which sources are already implemented \!

Other relavant packages : -
[`getSpatialData`](http://jxsw.de/getSpatialData/) - \[`MODIS`\] and
\[`MODISTools`\] and \[`MODISTsp`\] - GPM ?

## Installation

You can install the development version of getRemoteData from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ptaconet/getRemoteData")
```

## Get the data sources implemented in `getRemoteData`

You can get the data sources/collections downloadable with
`getRemoteData` and details about each of them with :

``` r
getRemoteData::getAvailableDataSources()
```

    #> Warning: replacing previous import 'dplyr::intersect' by
    #> 'lubridate::intersect' when loading 'getRemoteData'
    #> Warning: replacing previous import 'dplyr::union' by 'lubridate::union'
    #> when loading 'getRemoteData'
    #> Warning: replacing previous import 'dplyr::setdiff' by 'lubridate::setdiff'
    #> when loading 'getRemoteData'
    #> Warning: replacing previous import 'dplyr::select' by 'raster::select' when
    #> loading 'getRemoteData'
    #> Warning: replacing previous import 'lubridate::origin' by 'raster::origin'
    #> when loading 'getRemoteData'

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

## Example

Say you want to download over a 3500km<sup>2</sup> region of interest:

  - a 40 days time series of MODIS Terrra Land Surface Temperature (LST)
    (daily time resolution);
  - the same 40 days times series of Global Precipitation Measurement
    (GPM) (daily time resolution) :

<!-- end list -->

``` r
library(getRemoteData)
# Read the region of interest as a sf object 
roi<-sf::st_read(system.file("extdata/ROI_example.kml", package = "getData"),quiet=T)
# Set-up your time frame of interest
time_frame<-c("2017-05-01","2017-06-10")
# Set-up your credentials to EarthData
username_EarthData<-"my.earthdata.username"
password_EarthData<-"my.earthdata.username"
# Download the MODIS LST TERRA daily products in the current working directory
# Setting the argument 'download' to FALSE will return the URLs of the products, without downloading them 
dl_modis<-getRemoteData::getData_modis(timeRange = time_frame,
                                     roi = roi,
                                     collection="MOD11A1.006",
                                     dimensions=c("LST_Day_1km","LST_Night_1km"),
                                     download = T,
                                     destFolder=getwd(),
                                     username=username_EarthData,
                                     password=password_EarthData,
                                     parallelDL=T #setting to F will download the data linearly
                                     )
head(dl_res)
dl_gpm<-getRemoteData::getData_gpm(timeRange = time_frame,
                                     roi = roi,
                                     collection="GPM_3IMERGDF.06",
                                     dimensions=c("precipitationCal"),
                                     download = T,
                                     destFolder=getwd(),
                                     username=username_EarthData,
                                     password=password_EarthData,
                                     parallelDL=T #setting to F will download the data linearly
                                     )
head(dl_gpm)
# Get the data downloaded as a list of rasters
rasts_modis<-getRemoteData::prepareData_modis()
rasts_gpm<-getRemoteData::prepareData_gpm()
```

The functions of `getRemoteData` all work the same way :

  - *timeRange* is your date / time frame of interest (eventually
    including hours for the data with less that daily resolution) ;
  - *roi* is your area of interest (as an `sf` object, either point or
    polygon) ;
  - *destfolder* is the data destination folder ;
  - by default, the function does not download the dataset. It returns a
    data.frame with the URL(s) to download the dataset(s) of interest
    given the input arguments. To download the data, set the *download*
    argument to TRUE ;
  - other arguments are specific to each data product (e.g.
    *collection*, *dimensions*,*username*,*password*)

Absence of the *timeRange* (resp. *roi*) arguments in a function means
that the data of interest do not have any time (resp. spatial)
dimension.

Have a look at the vignette [Efficient extraction of spatial-temporal
series over small-scale
areas](https://www.nasa.gov/mission_pages/GPM/main/index.html) to check
what else you can do using getRemoteData \!

## Current limitations

The package is at a very early stage of development. Here are some of
the current limitations and ideas of future developments :

  - MODIS data cannot be donwloaded if your area of interest covers
    multiple MODIS tiles (for an overview of MODIS tiles go
    [here](https://modis.ornl.gov/files/modis_sin.kmz));

## Behind the scene… how it works

As much as possible, when implemented by the data providers,
`getRemoteData` uses web services or APIsto download the data. Web
services are in few words standard web protocols that enable to filter
the data directly at the downloading phase. Filters can be spatial,
temporal, dimensional, etc. Example of widely-used web services / data
transfer protocols for geospatial timeseries are [OGC
WFS](https://en.wikipedia.org/wiki/Web_Feature_Service) or
[OPeNDAP](https://en.wikipedia.org/wiki/OPeNDAP). If long time series
are queried, `getRemoteData` speeds-up the downloading time by
parralelizing it.
