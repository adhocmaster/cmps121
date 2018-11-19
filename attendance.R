
#fix what's one the menu ordering
csvPath = "F:\\myProjects\\cmps121\\Interim Presentations - Thursday (Responses) - Form Responses 1.csv"
outputPath = "F:\\myProjects\\cmps121\\interim-thursday-attendance.csv"

csvPath = "F:\\myProjects\\cmps121\\Interim Presentations - Tuesday (Responses) - Form Responses 1.csv"
outputPath = "F:\\myProjects\\cmps121\\interim-tuesday-attendance.csv"

csvList = read.csv( csvPath, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )


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
write.csv( uniqueEmails, file = outputPath )
