#' @name grd_import_data
#' @aliases grd_import_data
#' @title Import the data in R
#' @description Function to import a data / time series that was downloaded with the package \code{getremotedata}
#'
#' @param df_data_to_import data.frame. Contains the path to the data that were downloaded. Typically output \code{grd_get_url}
#' @param collection character string the name of a collection
#' @param variable character string the name of a variables
#' @param roi sf the ROI. Mandatory for SMAP collection, else, not necessary
#' @param output character string the output. "RasterBrick" .
#'
#' @importFrom raster raster brick crop merge
#' @importFrom magrittr %>%
#' @import purrr
#'
#' @export

grd_import_data <- function(df_data_to_import,
                             collection,
                             variable = NULL,
                             roi = NULL,
                             output = "RasterBrick"){

  rasts <- NULL

  if(is.null(variable) && output=="RasterBrick" && !(collection %in% c("SRTMGL1.003","MIRIADE"))){stop("for RasterBrick output you must provide one variables")}
  if(!is.null(variable) && length(variable)>1){stop("you must provide only one variable")}
  if(!("destfile" %in% colnames(df_data_to_import))){stop("df_data_to_import must contain a 'destfile' column")}

  if (collection=="SRTMGL1.003"){

    rasts <- .import_srtm(df_data_to_import,roi,output)

  } else if (collection=="TAMSAT"){

    rasts <- .import_tamsat(df_data_to_import,variable,roi,output)

  } else if (collection=="VIIRS_DNB_MONTH"){

    rasts <- .import_viirsdnb(df_data_to_import,variable,output)

  } else if (collection=="ERA5"){

    rasts <- .import_era5(df_data_to_import,variable,output)

  } else if (collection=="MIRIADE"){

    rasts <- .import_miriade(df_data_to_import)

  }

  return(rasts)

}
