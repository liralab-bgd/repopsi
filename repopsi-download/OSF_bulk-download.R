# Description -------------------------------------------------------------

# This script can be adapted for bulk downloading components of an Open Science Framework (OSF) project.

# This script was originally developed for regular back-ups of REPOPSI (https://osf.io/5zb8p/) - the repository of open psychological instruments - which is organized as an OSF project with currently close to 200 components. Each of these components contains multiple files.

# At the moment, OSF allows users to download a component as a zip file containing all of the files and/or directories (folders) in it. Users familiar with the R programming language may also use the 'osf_download' function from the 'osfr' package (https://docs.ropensci.org/osfr/reference/osf_download.html) to download files or directories of files locally. However, neither of these options can be used for downloading multiple components at once.

# Script developed by Aleksandra Lazic (https://orcid.org/0000-0002-0433-0483)

# STEP 1: Upload OSF component links --------------------------------------

# The REPOPSI project already has an Inventory file (https://osf.io/mxrc2), with links to all of its OSF components in the "Link to instrument in the Repository." column. Each OSF component has a different Globally Unique ID (GUID). The GUID is the five-character string after the "osf.io/" in the link (e.g. in 'https://osf.io/5d3yb/', the GUID is '5d3yb').

# To use this script, you need a similar dataset or simply a list of the links (or only GUIDs) of the OSF components that you want to download.

## Using a dataset --------------------------------------------------------

# If you have many components or if you expect to add more components to the project in the future, I recommend curating a dataset, which you can update as needed. The following code demonstrates how to upload OSF component links from a dataset stored on the OSF.

# Upload the column from the REPOPSI inventory with component links

library(data.table) 

osf_links = fread("https://osf.io/download/mxrc2/", # or a path to a file stored elsewhere (e.g. on your computer)
                  select = c("Link to instrument in the Repository.")) # optional - uploads only the column of interest

# Remove cases with no links (some REPOPSI records are not available openly or on the OSF)

osf_links = osf_links[!(osf_links$`Link to instrument in the Repository.`==""), ]

# Remove duplicate values (some REPOPSI records are stored in the same component)

osf_links = osf_links[!duplicated(osf_links$`Link to instrument in the Repository.`)]

## Using a list -----------------------------------------------------------

# If you are downloading only a couple of components, you may want to provide them directly in this script. The following code shows one way to do this.  

library(tibble)

osf_links_list = tribble( 
  ~osf_links,
  'https://osf.io/5d3yb/',	# put entire OSF links or only GUIDs
  'https://osf.io/8p4qs/',	
  'https://osf.io/r3ysk/',  # add more links/GUIDs as needed
  )

# STEP 2: Create download links -------------------------------------------

# First, identify the download URL for one of the components. If the components are all part of the same project, the download URLs will follow the same pattern. 

# Open the component, go to the 'Files' tab, locate the 'Download this folder' button, and copy its link. On Chrome and Firefox, this is done by right clicking the button and selecting the 'Copy link address'/'Copy Link' option. For one of the components in REPOPSI, the download URL looks like this: 'https://files.de-1.osf.io/v1/resources/edm6v/providers/osfstorage/?zip='.

# Download a short video guide on how to identify and copy component download links from here: https://rawcdn.githack.com/liralab-bgd/repopsi/bad7b2824af2f03eda64d31c699ec22c4c54a1b8/repopsi-download/component-download-url_instructions.mp4

# One part of the download link is the component GUID (e.g., 'edm6v'). If you uploaded entire OSF links in STEP 1, the GUIDs need to be extracted from them. If you uploaded GUIDs, you can skip this part.

osf_links$guid = substr(osf_links$`Link to instrument in the Repository.`, start=16, stop=20)

# Save the first part of the download URL, before the GUID

osf_links$string1 = "https://files.de-1.osf.io/v1/resources/"

# Save the second part of the download URL, after the GUID

osf_links$string2 = "/providers/osfstorage/?zip="

# Finally, combine string1, GUID, and string2 to create unique download URLs for all of the components

osf_links$download = paste(osf_links$string1,osf_links$guid,osf_links$string2, sep='')

# STEP 3: Download the components -----------------------------------------

# Run this code to download all of the components at once, in your default browser. Components will be downloaded as separate zip files.

lapply(osf_links$download,function(x) browseURL(as.character(x)))