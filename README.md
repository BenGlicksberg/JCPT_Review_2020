# JCPT_review_2020
 Repo for data and scripts used to generate clinical trial-related figures for *Master Class Review Article* for the Journal of Cardiovascular Pharmacology and Therapeutics.

### Manuscript Information

TBD

---

## Process and Dataset

This document will detail the process for obtaining the data and generating Figure 1 (panels a and b) in the main text. 


### Clinical trials dataset source

The data regarding the number of machine learning (ML)-related clinical trials was originally obtained through querying https://clinicaltrials.gov/ on February 18th, 2020. Specifically, under the “Find a study” section, we selected Status of “All studies” and searched for the following: “machine learning” OR “artificial intelligence” OR “deep learning” in the “Other terms” section. We did not restrict results by country. The output of this query produced 502 studies, with 286 associated with “machine learning”, 220 associated with “artificial intelligence”, and 87 associated with “deep learning” (note that one study can fall into more than one of these categories). For “artificial intelligence”, this search automatically expanded to “Machine Intelligence” (2 studies) and “Computational Intelligence” (1 study). We downloaded the result for all available columns for plotting. 

### Clinical trials dataset annotation

In the data output from the query, there are no clear delineations of clinical domain, particularly for all cardiovascular-related trials. The Conditions and Outcome Measures fields are relevant, but do not neatly segregate clinical domain, as they have non-standardized characterizations (i.e., “Coronary Artery Disease” or “Cardiovascular diseases” for Conditions. Two study authors (BSG and KWJ) utilized the information in these columns and others to manually label all cardiovascular-related trials. Any discrepant labels were settled by a third study author (AR). This annotation process resulted in 58 trials out of 502 (11.6%) labeled as cardiovascular-related. These annotations for cardiovascular-related trials can be found in the Clinical Domain field. The full annotated dataset used can be found at: [github sublink]. 


### Clinical trials dataset pre-processing

With the annotations complete, we performed a series of pre-processing steps to ensure quality control of the dataset. First, we filtered trials based on their Start Date. Specifically, we removed trials that started before 2006 as these seemed to be mis-annotated in the original query output. Here, we filtered 1 trial from 1990 (NCT03948620), 3 from 2002 (NCT00241046, NCT00039585, and NCT00049556), and one with no recorded start date (NCT00435097). We then extracted the country where each trial was run from the Locations field. In order to map these country labels to ISO 3 to be used in the geographical plot, we obtained a mapping between country and ISO 3 code from https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv. We have saved the output from this as a back-up in [github sublink]. Some of extracted country labels had to be slightly modified to fit the country label as listed in this mapper file. All processing was performed in R version 3.4.1 and made use of the data.table (version 1.12.0) and Rcurl (version 1.95.4.8) packages.
