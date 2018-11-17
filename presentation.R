csv1 = "F:\\myProjects\\cmps121\\Interim Presentations - Tuesday (Responses) - Form Responses 1.csv"

csvList = read.csv( csv1, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )


#fix( csvList )

parseColumnNames = function( rawList ) {
  
  names = names( rawList )
  n2 = trimws( sub( "Rate the content of the \"", "", names, ignore.case = TRUE ) )
  n3 = trimws( sub( "\" application based on quality of the application and originality and complexity of the project.", " App", n2, ignore.case = FALSE ) )
  n4 = trimws( sub("Rate the delivery of the \"", "", n3, ignore.case = TRUE) )
  n5 = trimws( sub("\" presentation based on professional presentation, engaging audience, clear voice with good pace.", " Presentation", n4, ignore.case = TRUE) )
  
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


i = 3

cols = names( data )
colLen = length( cols )

while ( i < colLen ) {
  
  print( paste(  "processing:", cols[i], ", ", cols[i+1] ) )
  
  projectSet = getProjectMarks( cols[i], cols[i+1] )
  uniqueMarks = removeDuplicates( projectSet )
  
  print( paste( "App mean:", mean( uniqueMarks[[ cols[i] ]]),  
                "Presentation mean:", mean( uniqueMarks[[ cols[i+1] ]]) 
                ) )
  
  i = i + 2
  
}
