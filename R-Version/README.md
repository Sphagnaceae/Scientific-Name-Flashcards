# How to make flashcards (R Version)
[Here is an example of the input csv](SamplePlantSpreadsheet.csv)
[Here is an example of the output text file](SampleFlashcardOutput.txt) that is imported into Anki
## Formatting Input Data
First, you'll need the information that you want to turn into flashcards. This must be in <b>csv</b> format, and <b> must be formatted properly, or it will not work. </b>

I usually do this in Google Sheets, although you can use any spreadsheet software that allows you to export as a .csv file. I'll use [this table](SamplePlantSpreadsheet.csv) of carnivorous plants as an example:

| Family | Latin name | Common name | Lab |
| ------ | ---------- | ----------- | -----|
| Droseraceae (Sundew) | Drosera anglica | English sundew | 2 |
|Droseraceae (Sundew)|Drosera rotundifolia|Round-leaved sundew|2|
|Droseraceae (Sundew)|Drosera linearis|Slender-leaved sundew|2|
|Lentibulariaceae|Pinguicula vulgaris|Common butterwort|3|
|Lentibulariaceae|Pinguicula villosa|Hairy butterwort|3|
|Tofieldiaceae|Triantha occidentalis|Western false asphodel|3|

Make sure that you spell everything correctly, as this is how your terms will be spelt on the flashcards. Also, check your capitalization and avoid extra spaces, since this is also how it will be on your final flashcards.

Family names can be formatted as LatinName (CommonName), like in the first two rows, or as just Latinname, as in rows 3-6 of the example table. The parentheses are necessary, and the code is expecting that there is only one space present. If you want to include only the common family name (e.g. only "Sundew", and nothing else), this is also an option but you will need to change some of the code to do this. See the documentation in the code for more info on what you must change. 

### Table Headers
In the Python version of the code, a header row is not mandatory. <b> A header row is required in the R version</b>. But, your column names can be whatever you want, since you'll set this in the code (please note that this is <b> case sensitive</b>:

<b>FamilyCol</b> is the name of your family name column. Mine is called "Family", so I would set it like this:  
```FamilyCol <- "Family"```   

<b>CommonNameCol</b> is the name of your column containing common names. Set like this:  
```CommonNameCol <- "Common name"```   

<b>LatinNameCol</b> is the name of your column containing Latin names. Set like this:  
```LatinNameCol <- "Latin name"```  

<b>LabCol</b> is an optional column allowing you to add a lab or lecture number to the tags of your flashcard. This allows you to sort your cards in Anki by the number of the lab or lecture that it came from. This works with a course name field that I explain below.   
```LabCol <- "Lab"```  
If you don't want to use this field, set it like this:  
```LabCol <- ""```  

### Tags
Tags are used in Anki to organize your flashcards, and can make it very easy to find specific cards or topics. These tags use :: to denote subfolders.

<b>CourseNameTag</b> is an optional tag that will be followed by the Lab number, if applicable. This is the same for all of the flashcards you make from a single csv. You can set it like this:  
```CourseNameTag <- "BIO101::Lab_"```  
In this example, if you have a lab number, it will be added to the end to create cards tagged as BIO101::Lab_1, BIO101::Lab_2, BIO101::Lab_3, etc. 
Anki's subtag system means that each of the sequentially numbered Lab_1, Lab_2, and Lab_3 tags become their own subfolders of the BIO101 course tag.
If you do not want to use a course tag, set it to blank:  
```CourseNameTag <- ""```  

<b>TaxonomicTag</b> is another optional field that lets you sort your flashcards by clade. Whatever you enter in this field will be applied to all cards, but the family field (from the column) will be variable. Remember to add the two trailing ::   
```TaxonomicTag <- "Plants::Vascular_Plants::Dicots::"```    
If you do not want to use this, set it to blank:
```TaxonomicTag <- ""```   

### Files
<b>txtFileName</b> is the name of your output text file that you will import to Anki. If you have another file by the same name in your current working directory, you will recieve a warning that this would be overwritten, and you can choose to pause (and pick a different name) or continue, and overwrite the old file. <b> Do not</b> include the .txt file extension in your filename.  
```txtFileName <- "AnkiCardsTest1" ```  

<b>csvPath</b> is the file path to your properly-formatted csv input file, this tells the code where to find your data. Remember to format this with forward slashes, or it won't work.   
```csvPath <- "C:/PathGoesHere/PlantID_List.csv"```  
 
<b>LinesToSkip</b> is the number of rows that should be skipped at the start of your spreadsheet. Skip rows that are blank or contain other information. <b> Do not skip header rows</b>.  
```LinesToSkip<- 0```  

## Options
There are notes throughout the code on what to edit if you want to change how the code works. For example, it tells you which chunk to delete to run it without common species names. It also includes some information on how to identify and fix bugs that could arise from weird header names. 

Good luck!
