# JCPT_review_2020
 Repo for data and scripts used to generate clinical trial-related figures for *Master Class Review Article* for the Journal of Cardiovascular Pharmacology and Therapeutics.

### Manuscript Information

Russak, Adam J., et al. "Machine Learning in Cardiology—Ensuring Clinical Impact Lives Up to the Hype." Journal of Cardiovascular Pharmacology and Therapeutics (2020): 1074248420928651.

---

## Process and Dataset

This document will detail the process for obtaining the data and generating [Figure 1](https://github.com/BenGlicksberg/JCPT_Review_2020/blob/master/Figure1.pdf) (panels a and b) in the main text. 

### Code to generate figure

The code to generate Figure 1 (panels A and B) can be found in [figure1.R](https://github.com/BenGlicksberg/JCPT_Review_2020/blob/master/figure1.R).

### Clinical trials dataset source

The data regarding the number of machine learning (ML)-related clinical trials was originally obtained through querying https://clinicaltrials.gov/ on February 18th, 2020. Specifically, under the “Find a study” section, we selected Status of “All studies” and searched for the following: “machine learning” OR “artificial intelligence” OR “deep learning” in the “Other terms” section. We did not restrict results by country. The output of this query produced 502 studies, with 286 associated with “machine learning”, 220 associated with “artificial intelligence”, and 87 associated with “deep learning” (note that one study can fall into more than one of these categories). For “artificial intelligence”, this search automatically expanded to “Machine Intelligence” (2 studies) and “Computational Intelligence” (1 study). We downloaded the result for all available columns for plotting. 

### Clinical trials dataset annotation

In the data output from the query, there are no clear delineations of clinical domain, particularly for all cardiovascular-related trials. The Conditions and Outcome Measures fields are relevant, but do not neatly segregate clinical domain, as they have non-standardized characterizations (i.e., “Coronary Artery Disease” or “Cardiovascular diseases” for Conditions. Two study authors (BSG and KWJ) utilized the information in these columns and others to manually label all cardiovascular-related trials. Any discrepant labels were settled by a third study author (AR). This annotation process resulted in 58 trials out of 502 (11.6%) labeled as cardiovascular-related. These annotations for cardiovascular-related trials can be found in the Clinical Domain field. The full annotated dataset used can be found within [clinicaltrialsgov_results_filtered.txt](https://github.com/BenGlicksberg/JCPT_Review_2020/blob/master/clinicaltrialsgov_results_filtered.txt). 


### Clinical trials dataset pre-processing

With the annotations complete, we performed a series of pre-processing steps to ensure quality control of the dataset. First, we filtered trials based on their Start Date. Specifically, we removed trials that started before 2006 as these seemed to be mis-annotated in the original query output. Here, we filtered 1 trial from 1990 (NCT03948620), 3 from 2002 (NCT00241046, NCT00039585, and NCT00049556), and one with no recorded start date (NCT00435097). We then extracted the country where each trial was run from the Locations field. In order to map these country labels to ISO 3 to be used in the geographical plot, we obtained a mapping between country and ISO 3 code from [lukes/ISO-3166-Countries-with-Regional-Codes](https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv). We have saved the output from this as a back-up in [country_codes.csv](https://github.com/BenGlicksberg/JCPT_Review_2020/blob/master/country_codes.csv). Some of extracted country labels had to be slightly modified to fit the country label as listed in this mapper file. All processing was performed in R version 3.4.1 and made use of the data.table (version 1.12.0) and Rcurl (version 1.95.4.8) packages.


### Generating the clinical trials geographical map figure

The clinical trials breakdown by country plot was created using the rworldmap (version 1.3.6) package. Here, only the 58 cardiovascular-related trials were plotted. RcolorBrewer (version 1.1.2) was used for the color scheme. 


### Generating the clinical trial count by time figure

For this figure, we restricted the dataset to only active, recruiting, or completed statuses. Specifically, we filtered for “Recruiting”, “Completed”, “Not yet recruiting”, “Enrolling by invitation”, or “Active, not recruiting” in the Status field, removing 34 trials. We also restricted to trial start years on or before 2019, which resulted in 63 trials being removed. This plot was generated using ggplot2 (version 3.1.0).

---

## License and Attribution

MIT License

Copyright (c) 2020 BenGlicksberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

### Country codes file attribution
As mentioned, the [country_codes.csv](https://github.com/BenGlicksberg/JCPT_Review_2020/blob/master/country_codes.csv) file was obtained from the GitHub of [**lukes**](https://github.com/lukes) within the [*ISO-3166-Countries-with-Regional-Codes*](https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes) repo. That work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License. 
