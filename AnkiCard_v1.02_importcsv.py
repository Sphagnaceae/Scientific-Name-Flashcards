#various user interface things are in this section--------------

csv_path_input = input('Please paste the complete path of your .csv file:')
print('Family names must be formatted as Latinname (Common) or Latinname, for example, Amaranthaceae (Amaranth) or just Amaranthaceae.')
family_col = int(input('Column containing Family names:'))-1
lab_col = int(input('Column containing lab numbers:'))-1
import regex
header_input = input('Does your .csv file have a header row? (True/False):')
while not regex.fullmatch("true|false", header_input.lower()):
    print("Invalid input.")
    header_input = input('Does your .csv file have a header row? (True/False):')
if header_input.lower() == "true":
    is_header = True
if header_input.lower() == "false":
    is_header = False

#for inputtedstuff in header_input.lower(): #this is the first occurrence of
    # inputtedstuff defining it as the text returned by header_input (but lowercase)

#print(f"is_header = {str(is_header)}") #this is a test for the boolean input
txt_output = input('Please name your output .txt file:')
#end of UI section------------------------------------------------------------------------------------------------------

import csv

#nicely formatted csv path is C:\Users\kikir\OneDrive\Documents\WeedID.csv
#other, raw csv path is C:\Users\kikir\Downloads\Plant ID Study Checklist - Weeds.csv
with open(fr'{csv_path_input}', newline='') as csvfile, open(txt_output + '.txt', "w") as txt_output_file:
    #reader = csv.DictReader(csvfile, fieldnames=["Family","Latin name","Common Name","Main Testable","Plant","Lab"],dialect='excel', delimiter=',', quotechar='|')
    reader = csv.reader(csvfile)
    total_line_count = 0
    processed_line_count = 0
    txt_output_file.write("#separator:Comma\n#html:true\n#notetype:Basic (type in the answer)\n#tags column:3\n")
        #__________________________________
    #def scribe(inscribed_output_text):
        #txt_output_file.write(inscribed_output_text)
       # print(inscribed_output_text) #----------------------------------------
        #---------------------------Offending section has been delineated. I also indented the stuff below this.
    for row in reader:
        #print(f"is_header = {is_header}, total={total_line_count}, processed={processed_line_count}")
        if row[0] == '':
            #if processed_line_count == 0 and is_header == True:
                #total_line_count += 1
            #else:
            total_line_count += 1
        elif processed_line_count == 0 and is_header:
            total_line_count += 1
            is_header = False
        else:
            lab = row[lab_col]
            family = row[family_col]
            #lab = row[5]----> this is the version for testing, if I don't feel like pasting every singe time
            #family = row[0] ----> this is the version for testing
            family_end_index = family.find(' ')
            if family_end_index == -1:
                family_latin = family
                is_family_common = False
            else:
            #print(family_end_index)
                family_latin = family[:family_end_index]
                is_family_common = True

            if is_family_common == True:
                family_common = family[family_end_index+2:].strip(')')
                txt_output_file.writelines(f"What <b>family</b> is <i>{row[1]}</i>?<br>(LatinName Common),"
                                           f"{family_latin} {family_common},Plants::Vascular_Plants::Dicots::{family_latin} "
                                           f"PLSC352::Lab_{lab}\n")
            else:
                #this makes it so that plants with no common name given for family can still work
                txt_output_file.writelines(f"What <b>family</b> is <i>{row[1]}</i>?<br>(LatinName),"
                                           f"{family_latin},Plants::Vascular_Plants::Dicots::{family_latin} PLSC352Lab_{lab}\n")
            #def family_latin() : family[0:family_end_index]
            #print(family_latin())
            txt_output_file.writelines(f'What is the <b>Common name</b> of <i>{row[1]}</i>?,{row[2]},'
                                       f'Plants::Vascular_Plants::Dicots::{family_latin} PLSC352::Lab_{lab}\n')
            txt_output_file.writelines(f'What is the <b>Latin name</b> of {row[2]}?,<i>{row[1]}</i>,'
                                       f'Plants::Vascular_Plants::Dicots::{family_latin} PLSC352::Lab_{lab}\n')
            total_line_count += 1
            processed_line_count += 1

print(f"\nProcessed {processed_line_count} rows of data\nTo use your flashcards, import {txt_output}.txt into Anki")
#print(total_line_count)


#I'm basically defining fieldnames right here they do not need to be the same as the first ones in the file

#IT WORKS It's the stupid r that I need to put in front of the raw string, and now it can find it.
#class csv.DictReader(f, fieldnames=None, restkey=None, restval=None, dialect='excel', *args, **kwds)
    #Create an object that operates like a regular reader but maps the information in each row to a dict
    #whose keys are given by the optional fieldnames parameter.

    #The fieldnames parameter is a sequence. If fieldnames is omitted, the values in the
    #first row of file f will be used as the fieldnames and will be omitted from the results.
    #If fieldnames is provided, they will be used and the first row will be included in the results.
    #Regardless of how the fieldnames are determined, the dictionary preserves their original ordering.

    #If a row has more fields than fieldnames, the remaining data is put in a list and stored with the
    #fieldname specified by restkey (which defaults to None). If a non-blank row has fewer fields than
    #fieldnames, the missing values are filled-in with the value of restval (which defaults to None).

    #All other optional or keyword arguments are passed to the underlying reader instance.