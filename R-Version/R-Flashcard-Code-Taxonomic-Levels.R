#this code makes Anki flashcards from a csv input. IF YOU ARE A BEGINNER, START WITH THE OTHER R CODE FILE
#The documentation in this version is incomplete, so it is not as beginner-friendly as R-Flashcard-Code-Main.R ,
#This code is specialized for use with non-plant organisms, or situations
#where you want to learn higher taxonomic levels, like kingdom, phylum, and order. 

#install.packages(dplyr) #do this if you have not installed dplyr 
library(dplyr)

####---- edit this section-----------------------------------------------
csvPath <- "../Plant Pathogens.csv"
#remember to format this with forward slashes
LinesToSkip <- 0
#the number of lines to skip at the start of the spreadsheet. skip any blank rows. Do NOT skip headers. 
KingdomCol <- "Kingdom"
PhylumCol <- "Phylum"
OrderCol <- "Order"
#the name of your column with family, order, phylum, etc. names
#You can edit to add other levels, like Family or Class. 

CommonNameCol <- "Common.Name"
LatinNameCol <- "Latin.Name"
#the names of your columns with the latin names and common names
LectureCol <- "Lecture"
#this is the name of the column with the lab/lecture numbers, if applicable. Something is wrong 
#with the way this text is interpreted, so if you run into issues, please try renaming your 
#lecture number column to "Lecture".
#this will allow you to tag your cards with the lab or lecture number it came from
#you can add the course name below
#If you don't want to use this feature, leave this field blank. 

CourseNameTag <- "PLSC380::Pathogens::Lecture_"
#this will be followed by the numbering included in LabNumber, for example, BIOL101::Lab_1
#Remember that Anki tags use :: notation to do subtags 
#If you do not want a course tag, please leave this field blank 

TaxonomicTag <- "Plant_Pathogens::"
#This is an optional field to add a tag to sort your flashcards by clade
#remember that Anki tagging systems use the :: characters to denote subfolders
#This applies as a character vector to all cards, and will be followed by the decreasing taxonomic levels for that card
#e.g. Kingdom::Phylum::Class.

txtFileName <- "FlashcardOutput_Oct_2026"
#Choose a name for your output .txt file
####--------------------------------------------------------------------------

csv <- read.csv(file = csvPath, header = TRUE, skip = LinesToSkip)

OrderCol <- gsub(x = OrderCol, pattern = " ", replacement = ".")
KingdomCol <- gsub(x = KingdomCol, pattern = " ", replacement = ".")
PhylumCol <- gsub(x = PhylumCol, pattern = " ", replacement = ".")
LectureCol <- gsub(x = LectureCol, pattern = " ", replacement = ".")
CommonNameCol <- gsub(x = CommonNameCol, pattern = " ", replacement = ".")
LatinNameCol <- gsub(x = LatinNameCol, pattern = " ", replacement = ".")

#Replaces spaces with periods in your inputted column names, since R also does this
#to the column names of csv that are read in. 
#If the rest of the code doesn't work for you, run the following:
#colnames(csv)
#then, look at how R has processed your column names, and update the original OrderCol, 
#CommonNameCol, etc. variables accordingly

TimeForSomeFlashcardMagic <- function(input = csv, output = txtFileName, 
                                      Latin = LatinNameCol, Common = CommonNameCol,
                                      Lecture = LectureCol, Course = CourseNameTag,
                                      Order = OrderCol, Kingdom = KingdomCol,
                                      Phylum = PhylumCol,
                                      TaxoTag = TaxonomicTag){
  card_count <- 0
  outputfile = paste0(output, ".txt")
  cat("", file = outputfile, append = FALSE)
  cat("#separator:Comma\n#html:true\n#columns:Front,Back,Tags\n#notetype:Basic (type in the answer)\n#tags column:3\n", 
      file = outputfile, fill = FALSE, append = TRUE, sep = "")
  #rename(csv, "Order" = Order, "Latin" = Latin, "Common" = Common, "Lecture" = Lecture, "Phylum" = Phylum, 
      #  "Kingdom" = Kingdom)
      #I put this in the original code, I'm not sure why and as far as I can tell, it is redundant. If anyone figures out 
      #why this may or may not be necessary, I'd love to hear it. 
  
  for (row in 1:nrow(csv)){
    rowKingdom <- csv[row, Kingdom]
    rowPhylum <- csv[row, Phylum]
    rowOrder <- csv[row, Order]
    rowLatin <- csv[row, Latin]
    rowCommon <- csv[row, Common]
    rowLecture <- csv[row, Lecture] #this is new and improved since the original verison of R-Flashcard-Code-Main.R
    
    is_Kingdom_blank <- !nzchar(rowKingdom)
    is_Phylum_blank <- !nzchar(rowPhylum)
    is_Order_blank <- !nzchar(rowOrder)
    
    if(is_Phylum_blank == FALSE & is_Order_blank == FALSE){
      rowTaxon <- paste0(rowKingdom, "::", rowPhylum, "::", rowOrder)
    }else if(is_Phylum_blank == TRUE & is_Order_blank == FALSE){
      rowTaxon <- paste0(rowKingdom, "::", rowOrder)
    }else if(is_Phylum_blank == FALSE & is_Order_blank == TRUE){
      rowTaxon <- paste0(rowKingdom, "::", rowPhylum)
    }else if(is_Phylum_blank == TRUE & is_Order_blank == TRUE){
      rowTaxon <- rowKingdom}
    
     #KINGDOM
    #message(is_Kingdom_blank) #use this line if you are running into issues
    
    #if you want the funcitonality for parenthetical common names it could theoretically
    #be added back in here
    #but it was removed to allow options for more taxonomic levels (and I didn't 
    #need to add parenthetical common names for those
    
    if (is_Kingdom_blank == TRUE){
      message(rowLatin)
    }else{
      message(rowLatin)
      cat("What <b>Kingdom</b> is <i>", rowLatin, "</i>?<br>(LatinName),", 
          rowKingdom, ",", TaxoTag, 
          rowTaxon, " ", Course, rowLecture, "\n",
          file = outputfile, fill = FALSE, append = TRUE, sep = "")
      card_count <- card_count + 1 #Card counter is a neat idea, but broken at the moment. Apparently reads two higher than the actual number of cards
    }
    
    #PHYLUM
   #message(is_Phylum_blank)
    
    if (is_Kingdom_blank == TRUE){
      message(rowLatin)
    }else{
      message(rowLatin)
      cat("What <b>phylum</b> is <i>", rowLatin, "</i>?<br>(LatinName),", 
          rowPhylum, ",", TaxoTag, 
          rowTaxon, " ", Course, rowLecture, "\n",
          file = outputfile, fill = FALSE, append = TRUE, sep = "")
      card_count <- card_count + 1
    }
    
    #ORDER
    #message(is_Order_blank)
   
    if (is_Order_blank == TRUE){
      message(rowLatin)
    }else{
    message(rowLatin)
    cat("What <b>order</b> is <i>", rowLatin, "</i>?<br>(LatinName),", 
        rowOrder, ",", TaxoTag, rowTaxon, " ", Course, rowLecture, "\n",
        file = outputfile, fill = FALSE, append = TRUE, sep = "")
    card_count <- card_count + 1
    
    }

    #The next section is the most important section, dealing with common species names
    #and latin species names.
    #IF YOU DO NOT WANT TO LEARN SPECIES COMMON NAMES (or you are dealing with
    #organisms like mosses, where common names are not often used), delete
    #all code between lines 152 and 160. 
    has_Common_Name <- nzchar(rowCommon)
    
    if(has_Common_Name == TRUE){
    cat("What is the <b>common name</b> of <i>", rowLatin, "</i>?,", rowCommon, ",", 
        TaxoTag, rowTaxon, " ", Course, rowLecture, "\n",
        file = outputfile, fill = FALSE, append = TRUE, sep = "")
    card_count <- card_count + 1
    cat("What is the <b>Latin name</b> of ", rowCommon, "?,</i>", rowLatin, "</i>,", 
        TaxoTag, rowTaxon, " ", Course, rowLecture, "\n",
        file = outputfile, fill = FALSE, append = TRUE, sep = "")}
    card_count <- card_count + 1
  }
  message(paste0("Card count: ", card_count))
  return(outputfile)
}

outputfile <- paste0(txtFileName, ".txt")
if(file.exists(outputfile)){
  stop("There is already a file with that name. Please select a different name or continue if you wish to overwrite the old file.")
}

TimeForSomeFlashcardMagic()
