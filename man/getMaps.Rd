% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mapping.R
\name{getMaps}
\alias{getMaps}
\title{Obtain Read 2, CTV3, ICD-10 and OPCS4 maps for SNOMED CT concepts}
\usage{
getMaps(
  x,
  mappingtable = NULL,
  to = c("read2", "ctv3", "icd10", "opcs4", "ctv3simple"),
  SNOMED = getSNOMED(),
  single_row_per_concept = TRUE
)
}
\arguments{
\item{x}{SNOMEDcodelist or SNOMEDconcept object. If it is a
SNOMEDconcept object it is first converted to a SNOMEDcodelist.
If it is a SNOMEDcodelist it is first converted to 'simple' format.
Columns named 'read2_code' or 'read2_term' (if adding Read 2 maps) or
'ctv3_concept' or ctv3_termid' (if adding CTV3 maps) will be
overwritten.}

\item{mappingtable}{data.table containing mapping in the format
described in 'Details'. The MAPS dataset in this package provides
a sample.
It must contain a unique field 'conceptId', and fields named
'read2_code' and 'read2_term' (for mapping to Read 2)
or 'ctv3_concept' and 'ctv3_termid' (for mapping to CTV3).}

\item{to}{character vector stating which terminologies to map to.
Options are 'icd10', 'opcs4', 'ctv3simple' (use tables included
within the SNOMED dictionary), or 'read2' or 'ctv3' (require a
separate mapping table such as READMAPS).
Beware that including multiple destination terminologies may
result in a significant expansion
of the number of rows if single_row_per_concept is FALSE.}

\item{SNOMED}{an environment containing the SNOMED CT dictionary.
If not supplied, it will be obtained using getSNOMED().}

\item{single_row_per_concept}{(logical) if TRUE (default), the function
returns a single row per concept with Read 2 and CTV3 maps returned
as lists (i.e. multiple entries within a single cell). This means
the output is a valid SNOMEDcodelist object. If FALSE, returns
multiple rows per concept (one for each map).}
}
\value{
a data.table containing the columns conceptId and either
  'read2_code' and 'read2_term' (for mapping to Read 2),
  'ctv3_concept' and 'ctv3_termid' (for mapping to CTV3 using the
  mapping table), 'ctv3_simple' (mapping to CTV3 using SIMPLEMAP
  within the SNOMED dictionary), 'icd10_code' or 'opcs4_code'
  (mapped using EXTENDEDMAP within the SNOMED dictionary).
  If single_row_per_concept is TRUE, the mapped rows are of type
  'list' and the output is also a SNOMEDcodelist in 'simple' format,
  otherwise the output may have multiple rows per
  conceptId. Note that each Read 2, CTV3, ICD-10 or OPCS4 term may
  be mapped to multiple SNOMED CT concepts.
}
\description{
Returns concepts mapped to SNOMED CT from either the
SIMPLEMAP table in the SNOMED dictionay (Clinical Terms Version 3,
CTV3 maps, one per concept),
the EXTENDEDMAP table (ICD-10 and OPCS4 maps) or a separate mapping
table with Read Clinical Terms Version 2 (Read 2) and 
CTV3 maps. A sample mapping table (READMAPS) is provided.
}
\details{
The mapping table can be created from the NHS Digital 'Data
Migration' pack files which contain 'forward' maps of Read 2 and
CTV3 to SNOMED CT.
These are intended for converting individual
entries in electronic health records to SNOMED CT. The 
'forward' map files contain a SNOMED CT map for every Read 2 or
CTV3 code, but not all the SNOMED CT concepts are mapped.
Future SNOMED CT concepts will also not be mapped.

These maps can be used for converting SNOMED CT codelists into
Read 2 or CTV3 format for running queries, such as to characterise
patient phenotypes or identify patient populations for research.
They cannot be used in the reverse direction (to map a Read 2/CTV3
codelist to SNOMED CT) because some of the SNOMED CT terms will
be missed out, and the list will be incomplete.

The mapping table must be a data.table object with columns:
conceptId (integer64, unique),
read2_code (character list of 7-character Read 2 codes),
read2_term (character list of Read 2 terms),
ctv3_concept (character list of CTV3 concept codes),
ctv3_termid (character list of CTV3 term description codes)
}
\examples{
# Load sample SNOMED CT dictionary into the global environment
# so it is available to the functions in this example
SNOMED <- sampleSNOMED()
# Use the sample READMAPS table in this package
data(READMAPS)

# Example: Mapping a single concept
getMaps(SNOMEDconcept('Heart failure'), mappingtable = READMAPS,
  to = 'read2')
# Example: Mapping a concept and its descendants
getMaps(descendants(SNOMEDconcept('Heart failure')),
  mappingtable = READMAPS, to = 'read2')
# Example: Mapping a codelist
getMaps(SNOMEDcodelist(SNOMEDconcept('Heart failure')),
  mappingtable = READMAPS, to = c('ctv3', 'ctv3simple', 'icd10'))
}
\seealso{
READMAPS, loadREADMAPS
}
