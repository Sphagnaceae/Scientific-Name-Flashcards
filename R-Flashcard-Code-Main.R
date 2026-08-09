#this code makes Anki flashcards from a csv input. This is the version that 
#requires some understanding of R to use
#the Python version asks you if you have a header row, this version does not.
  #please just include a header row, it makes everything work so much better

#install.packages(dplyr) #do this if you have not installed dplyr 
library(dplyr)

####---- edit this section---- 
csvPath <- "C:/Users/kikir/OneDrive/Documents/R Studio Files and Projects/PlantID_List.csv"
csvPath <- "C:/PathGoesHere/PlantID_List.csv"
  #remember to format this with forward slashes
  #In your csv, Family names must be formatted as Latinname (Common) or Latinname, 
  #for example, Amaranthaceae (Amaranth) or just Amaranthaceae.
LinesToSkip <- 3
  #this is the number of lines that should be skipped at the start of your spreadsheet
  #skip any blank rows. Do NOT skip headers. 
FamilyCol <- "Family"
  #this is the name of the column in which the family names are found

LabCol <- "Lab"
  #this is the name of the column with the lab/lecture numbers, if applicable
  #this will allow you to tag your cards with the lab or lecture number it came from
  #you can add the course name in a field below
  #If you don't want to use this feature, leave this field blank. 
CommonNameCol <- "Common Name"
LatinNameCol <- "Latin name"
  #like the two others, these are the names of your columns with the latin names and common names

CourseNameTag <- "BIO101::Lab_"
  #this will be followed by the numbering included in LabNumber, for example, BIOL101::Lab_1
  #Remember that Anki tags use :: notation to do subtags 
  #If you do not want a course tag, please leave this field blank 

TaxonomicTag <- "Plants::Vascular_Plants::Dicots::"
  #This is an optional field to add a tag to sort your flashcards by clade
  #remember that Anki tagging systems use the :: characters to denote subfolders
  #This applies as a character vector to all cards


txtFileName <- "AnkiCardsTest1"
  #Choose a name for your output .txt file
####---- 

csv <- read.csv(file = csvPath, header = TRUE, skip = LinesToSkip)


FamilyCol <- gsub(x = FamilyCol, pattern = " ", replacement = ".")
LabCol <- gsub(x = LabCol, pattern = " ", replacement = ".")
CommonNameCol <- gsub(x = CommonNameCol, pattern = " ", replacement = ".")
LatinNameCol <- gsub(x = LatinNameCol, pattern = " ", replacement = ".")
  #Replaces spaces with periods in your inputted column names, since R also does this
  #to the column names of csv that are read in. 
  #If the rest of the code doesn't work for you, run the following:
    #colnames(csv)
  #then, look at how R has processed your column names, and update the FamilyCol, 
  #CommonNameCol, etc. variables accordingly in the first section

TimeForSomeFlashcardMagic <- function(input = csv, output = txtFileName, 
                                      Latin = LatinNameCol, Common = CommonNameCol,
                                      Lab = LabCol, Course = CourseNameTag,
                                      Family = FamilyCol, TaxoTag = TaxonomicTag){
  outputfile = paste0(output, ".txt")
  rename(csv, "Family" = Family, "Latin" = Latin, "Common" = Common, "Lab" = Lab)
  for (row in 1:nrow(csv)){
    rowFamily <- csv$Family[row]
    rowLatin <- csv$Latin[row]
    rowCommon <- csv$Common[row]
    
    is_family_common <- grepl(x = rowFamily, pattern = " ")
    
    
    #The following if/then statement deals with family names. These can be input as 
    #latin name and family name, in the format "Amaranthaceae (Amaranth)", where
    #the parentheses are required, or as latin name only, e.g. "Amaranthaceae".
    #If you wanted this to work with common names only:
      #modify the cat() function in the else statement, replacing "</i>?<br>(LatinName),"
      #with "</i>?<br>(CommonName),". Then, it will work with common names (although)
      #your variable names inside the function will not reflect this)
    if (is_family_common == TRUE){
      message(rowLatin)
      commonIndex <- regexpr(rowFamily, pattern = "\\(")
      family_latin <- substring(text = rowFamily, first = 1, last = (commonIndex-2))
      family_common <- substring(text = rowFamily, first = (commonIndex+1), 
                                 last = nchar(rowFamily)-1)
      
      cat("What <b>family</b> is <i>", rowLatin, "</i>?<br>(LatinName Common),", 
          family_latin, " ", family_common, ",", TaxoTag, 
          family_latin, " ", Course, Lab, "\n",
          file = outputfile, fill = FALSE, append = TRUE, sep = "")
      
    }else{family_latin <- rowFamily
      cat("What <b>family</b> is <i>", rowLatin, "</i>?<br>(LatinName),", 
        family_latin, ",", TaxoTag, 
        family_latin, " ", Course, Lab, "\n",
        file = outputfile, fill = FALSE, append = TRUE, sep = "")
      #This section allows you to make flashcards for species without parenthetical 
        #common names for families (e.g. just as Amaranthaceae instead of 
        #Amaranthaceae (Amaranth))
      }
    
    #The next section is the most important section, dealing with common species names
    #and latin species names. 
      #IMPORTANT: If you do not want to learn family names, you can safely delete
        #all code between lines 79 and 95. 
      #IF YOU DO NOT WANT TO LEARN SPECIES COMMON NAMES (or you are dealing with
          #organisms like mosses, where common names are not readily used), delete
          #all code between lines 109 and 114. 
    
    cat("What is the <b>common name</b> of <i>", rowLatin, "</i>?,", rowCommon, ",", 
        TaxoTag, family_latin, " ", Course, Lab, "\n",
        file = outputfile, fill = FALSE, append = TRUE, sep = "")
    cat("What is the <b>Latin name</b> of ", rowCommon, "?,</i>", rowLatin, "</i>,", 
        TaxoTag, family_latin, " ", Course, Lab, "\n",
        file = outputfile, fill = FALSE, append = TRUE, sep = "")
  }
  return(outputfile)
}


#outputfile <- paste0(txtFileName, ".txt")


outputfile <- paste0(txtFileName, ".txt")
if(file.exists(outputfile)){
  stop("There is already a file with that name. Please select a different name or continue if you wish to overwrite the old file.")
}


TimeForSomeFlashcardMagic()
