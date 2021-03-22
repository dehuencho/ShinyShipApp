library(shiny)
library(shiny.semantic)
library(data.table)
library(tidyverse)
library(leaflet)
library(lubridate)
library(shinyjs)
library(sf)
library(bslib)
library(plotly)

source("R/dropdown_mod.R")
source("R/description_mod.R")
source("R/mapLongDistance_mod.R")
source("R/utils.R")

information <- paste0("<b>This dashboard displays graphical information about the longest",
                      " distance sailed for different vessels in a dataset.  It shows the beginning",
                      " and the end of the longest movement and some statistics for all the",
                      " distances through time. To use the application, select the type and",
                      " the name of the vessel you want to display.</b>")
