csv1 = "F:\\myProjects\\cmps121\\Interim Presentations - Tuesday (Responses) - Form Responses 1.csv"

csvList = read.csv( csv1, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )


#fix( csvList )

parseColumnNames = function( rawList ) {
  
  names = names( rawList )
  n2 = trimws( sub( "Rate the content of the \"", "", names, fixed = TRUE ) )
  n3 = trimws( sub( "\" application based on quality of the application and originality and complexity of the project.", " App", n2, fixed = TRUE ) )
  n4 = trimws( sub("Rate the delivery of the \"", "", n3, fixed = TRUE ) )
  n5 = trimws( sub("\" presentation based on professional presentation, engaging audience, clear voice with good pace.", " Presentation", n4, fixed = TRUE ) )
  
  #n6 = sub( " ", "_", n5 )
  return( n5 )
}

cols = parseColumnNames( csvList )

names( csvList ) = cols
data = data.frame( csvList ) # this is used as global var

#find unique emails
emails = data$Email.Address
uniqueEmails = unique( emails )

#get each project, email and process

getProjectMarks = function( colApp, colPresentation ) {
  
  projectSet = subset( data, select = c( "Email.Address", colApp, colPresentation ) ) 
  
  return( na.omit( projectSet ) ) 
  
}

removeDuplicates = function( projectSet ) {
  
  return( projectSet[ !duplicated( projectSet$Email.Address), ] )
}



cols = names( data )
colLen = length( cols )
outputDF = data.frame()

i = 3
while ( i < colLen ) {
  
  print( paste(  "processing:", cols[i], ", ", cols[i+1] ) )
  
  projectSet = getProjectMarks( cols[i], cols[i+1] )
  uniqueMarks = removeDuplicates( projectSet )
  
  meanApp = mean( uniqueMarks[[ cols[i] ]])
  meanPresentation =mean( uniqueMarks[[ cols[i+1] ]]) 
  print( paste( "App mean:", meanApp,  
                "Presentation mean:", meanPresentation
                ) )
  
  projectName =  sub( ".App", "", cols[i], fixed = TRUE )
  projectName =  gsub( ".", " ", projectName, fixed = TRUE )
  outputDF = rbind( outputDF, 
                    data.frame( name = projectName, 
                                app = meanApp, 
                                presentation = meanPresentation  
                                )
                    )
  i = i + 2
  
}
