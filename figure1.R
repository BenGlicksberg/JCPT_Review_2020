# BS Glicksberg, 2020
library(data.table)
library(RCurl)


######################################
#### LOADING AND PRE-PROCESSING DATA
######################################

##### Read in clinical trials search output
### We performed a qurey of https://clinicaltrials.gov/ on Feb 18, 2020 searching for the following:
### "machine learning" OR "artificial intelligence" OR "deep learning"
### This returned 502 studies. Breakdown below (note overlaps). 
###    "machine learning": 286
###    "artificial intelligence": 220
###    "deep learning": 87
dat<- fread("clinicaltrialsgov_results_filtered.txt")


### This file has been manually annotated to specify cardiovascular-related trials (Clinical Domain column)
nrow(dat[`Clinical Domain`=="Cardiovascular"])
### 58 trials

##### Extract year from Start Date field
dat$start_year <-as.numeric(str_sub(dat$`Start Date`,start = -4))

##### QC of trials based on start year
### Removing trials before 2006 because they seem to be mislabeled.

dat<-dat[start_year>=2006]

###     3 removed from 2002 (NCT00241046, NCT00039585, NCT00049556) 
###     1 removed from 1990 (NCT03948620)
###     1 removed because no recorded start date (NCT00435097; last updated in 2007)

##### Get country from Locations field
get_country <- function(x){ trimws(tail(unlist(str_split(x, pattern=",")), n=1)) }
dat$country <-sapply(dat$Locations, get_country)

### QC countries to match with ISO3 code labels
dat[country == "Republic of"]$country <- "Korea, Republic of"
dat[country == "Bolivia"]$country <- "Bolivia (Plurinational State of)"
dat[country == "Taiwan"]$country <- "Taiwan, Province of China"
dat[country == "United States"]$country <- "United States of America"
dat[country == "United Kingdom"]$country <- "United Kingdom of Great Britain and Northern Ireland"

##### Map country label to ISO3 code
### source: https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv
iso_url <- getURL("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")
country_codes <- read.csv(text = iso_url,sep=",")
country_codes <- data.table(country_codes) # convert to data.table
country_codes$alpha.3<- as.character(country_codes$alpha.3) # convert from factor to character

### save this output as a back-up
fwrite(country_codes, "country_codes.csv",sep=",")

##### Add ISO3 codes to dat, merged by country label
dat_codes <- merge(dat, country_codes[,c("name", "alpha.3")], by.x = "country", by.y = "name", all.x = TRUE)

##### Find unmapped countries
unique(dat_codes[is.na(alpha.3) & country != "" ]$country)

### Original output included: Bolivia, Taiwan, United Kingdom, United States 
### This was fixed in above QC step

######################################
#### GEOGRAPHICAL PLOT (panel B)
######################################


##### Create frequency table by country for cardiovascular-related trials
dat_counts <- data.table(table(dat_codes[`Clinical Domain`=="Cardiovascular"]$alpha.3))
colnames(dat_counts)[1]<-"country"

# background: https://stackoverflow.com/questions/11225343/how-to-create-a-world-map-in-r-with-specific-countries-filled-in
library(rworldmap)

colorPalette <- RColorBrewer::brewer.pal(8,"OrRd") # Specify the colourPalette argument

pdf("trials_world_plot.pdf")
sPDF <- joinCountryData2Map(dat_counts, joinCode = "ISO3",
                              nameJoinColumn = "country",
                             mapResolution="coarse")


freqMap <- mapCountryData(sPDF, nameColumnToPlot="N", catMethod = "pretty",addLegend = FALSE, colourPalette = colorPalette, missingCountryCol = gray(1))

do.call( addMapLegend, c( freqMap, legendLabels="all", legendWidth=0.5, legendIntervals="data", legendMar = 2 ) )

dev.off()


######################################
#### PLOT TRIALS OVER TIME (panel A)
######################################

##### Filter trial results:
###     by status (active, recruiting, or completed statuses)
trialTypes <- c("Recruiting","Completed","Not yet recruiting","Enrolling by invitation", "Active, not recruiting")

dat_filtered <- dat[Status %in% trialTypes]
###     34 removed

###     by year (up to 2019)
dat_filtered <- dat_filtered[start_year <=2019]
###     63 removed

dat_filtered[`Clinical Domain` == ""]$`Clinical Domain` <- "Others" # label non-cardiovascular as "Others"

##### Create frequency table by type and year
dat_counts_by_year <- data.table(table(dat_filtered$`Clinical Domain`, dat_filtered$start_year))
colnames(dat_counts_by_year)[1]<-"Domain" # rename column to domain
colnames(dat_counts_by_year)[2]<-"Year"   # rename column to year
dat_counts_by_year$Year<- as.numeric(dat_counts_by_year$Year) # set as numeric

##### Line plot by type and year
p_by_year_and_domain <- ggplot(data = dat_counts_by_year, aes(x = Year, y = N, color = Domain)) +       
    geom_point() + geom_line() + 
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  scale_x_continuous("Year", labels = as.character(dat_counts_by_year$Year), breaks = dat_counts_by_year$Year) + scale_color_manual(values = c("#E69F00", "#56B4E9"))

ggsave("trials_by_year_and_domain",plot = p_by_year_and_domain, device = "pdf", height = 4, width = 7)
