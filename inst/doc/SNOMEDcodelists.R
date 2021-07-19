## ------------------------------------------------------------------------
# The sampleSNOMED() function returns an environment containing
# the sample dictionaries
require(Rdiagnosislist)
TEST <- sampleSNOMED()

# TEST is now an environment containing the sample SNOMED CT dictionary.
# Objects within the environment can be retrieved using the $ operator
# or the 'get' function. We will export the sample dictionaries to a
# temporary folder to show how to reload them using loadSNOMED()

for (table in c('Concept', 'Description', 'Relationship',
  'StatedRelationship')){
  write.table(get(toupper(table), envir = TEST), paste0(tempdir(),
    '/sct_', table, '_test.txt'), row.names = FALSE, sep = '\t', quote = FALSE)
}

# loadSNOMED searches for files containing _Concept_, _Description_,
# _Relationship_ or _StatedRelationship_, as in the actual SNOMED CT
# release files.

# Import using the loadSNOMED function
SNOMED <- loadSNOMED(tempdir(), active_only = FALSE)

## ------------------------------------------------------------------------
# Make sure the SNOMED environment is available and contains the SNOMED dictionary
as.SNOMEDconcept('Heart failure', SNOMED = SNOMED)

# To use the sample SNOMED dictionary for testing
as.SNOMEDconcept('Heart failure', SNOMED = sampleSNOMED())

# If an object named SNOMED containing the SNOMED dictionary is available
# in the current environment, it does not need to be stated in the
# function call
SNOMED <- sampleSNOMED()
as.SNOMEDconcept('Heart failure')

# The argument 'exact' can be used to specify whether a regular expression
# search should be done, e.g.
as.SNOMEDconcept('Heart f', exact = FALSE)

# The 'description' function can be used to return the descriptions of
# the concepts found. It returns a data.table with the fully specified 
# name for each term.
description(as.SNOMEDconcept('Heart f', exact = FALSE))

# The 'semantic type' function returns the semantic type of the concept
# from the Fully Specified Name
semanticType(as.SNOMEDconcept('Heart failure'))

# Functions which expect a SNOMEDconcept object, such as semanticType,
# will automatically convert their argument to SNOMEDconcept using the
# function as.SNOMEDconcept
semanticType('Heart failure')

## ------------------------------------------------------------------------
# A list of concepts with a description containing the term 'heart'
# (not that all synonyms are searched, not just the Fully Specified Names)
heart <- as.SNOMEDconcept('Heart|heart', exact = FALSE, SNOMED = sampleSNOMED())

# A list of concepts containing the term 'fail'
fail <- as.SNOMEDconcept('Fail|fail', exact = FALSE, SNOMED = sampleSNOMED())

# Concepts with heart and fail
intersect(heart, fail)

# Concepts with heart and not fail
setdiff(heart, fail)

# Concepts with heart or fail
union(heart, fail)

## ------------------------------------------------------------------------
SNOMED <- sampleSNOMED()

# Parents (immediate ancestors)
parents('Acute heart failure')

# Ancestors
ancestors('Acute heart failure')

# Children (immediate descendants)
children('Acute heart failure')

# Descendants
descendants('Acute heart failure')

## ------------------------------------------------------------------------
require(Rdiagnosislist)
SNOMED <- sampleSNOMED()

# List all the attributes of a concept
print(attrConcept('Heart failure'))

# 'Finding site' of a particular disorder
relatedConcepts('Heart failure', 'Finding site')

# Disorders with a 'Finding site' of 'Heart'
relatedConcepts('Heart', 'Finding site', reverse = TRUE)

## ------------------------------------------------------------------------
SNOMED <- sampleSNOMED()

# Create a codelist containing all the descendants of
# the concept 'Heart failure'
my_heart_failure_codelist <- SNOMEDcodelist(
  as.SNOMEDconcept('Heart failure'), include_desc = TRUE)

# Original codelist
print(my_heart_failure_codelist)

# Expanded codelist
expanded <- expandSNOMED(my_heart_failure_codelist)
print(expanded)

# Contract codelist
contracted <- contractSNOMED(expanded)
print(contracted)

# Write out codelist to file
write.csv(my_heart_failure_codelist, file = paste0(tempdir(),
  '/hf_codes.csv'), row.names = FALSE)

# Reload codelist from file
reloaded_codelist <- as.SNOMEDcodelist(
  data.table::fread(paste0(tempdir(), '/hf_codes.csv')))
print(reloaded_codelist)

