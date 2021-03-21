library(shiny)
library(shiny.semantic)
library(shiny.semantic)
library(data.table)
library(tidyverse)
library(leaflet)
library(lubridate)
library(shinyjs)

source("R/dropdown_mod.R")
source("R/plotHist_mod.R")
source("R/utils.R")

myGridTemplate <- grid_template(
    default = list(
        areas = rbind(
            c("title"),
            c("info", "map"),
            c("user", "map")
        ),
        cols_width = c("400px", "1fr"),
        rows_height = c("50px", "auto", "150px")
    ),
    mobile = list(
        areas = rbind(
            "title",
            "info",
            "map",
            "user"
        ),
        rows_height = c("50px", "100px", "auto", "200px"),
        cols_width = c("100%")
    )
)
