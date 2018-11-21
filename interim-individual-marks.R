library( "data.table")
csvPathProjectMarks = "F:\\myProjects\\cmps121\\interim-project-marks-90-percent.csv"
csvPathStudentProjects = "F:\\myProjects\\cmps121\\CMPS121 - Roster - Project - Fixed.csv"
csvPathTuesdayAttendance = "F:\\myProjects\\cmps121\\interim-tuesday-attendance.csv"
csvPathThursdayAttendance = "F:\\myProjects\\cmps121\\interim-thursday-attendance.csv"
csvPathRoster = "F:\\myProjects\\cmps121\\CMPS121 - Roster - Roster.csv"

outputPath = "F:\\myProjects\\cmps121\\interim-aggregated.csv"
outputPathEmail = "F:\\myProjects\\cmps121\\interim-aggregated-order-email.csv"


csvProjectMarks = read.csv( csvPathProjectMarks, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvStudentProjects = read.csv( csvPathStudentProjects, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvTuesdayAttendance = read.csv( csvPathTuesdayAttendance, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvThursdayAttendance = read.csv( csvPathThursdayAttendance, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvRoster = read.csv( csvPathRoster, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )

names( csvTuesdayAttendance )
names( csvThursdayAttendance )
names( csvTuesdayAttendance ) = c( "sl", "Email Address" )
names( csvThursdayAttendance ) = c( "sl", "Email Address" )
names( csvTuesdayAttendance )
names( csvThursdayAttendance )

#clean up csvStudentProjects
head( csvStudentProjects )

csvStudentProjects[, 1] = NULL
csvStudentProjects$`Email Address` = trimws( csvStudentProjects$`Email Address` )
DTstudentProjectsRaw = data.table( csvStudentProjects )
DTstudentProjects = subset( DTstudentProjectsRaw, 
                            !is.na( DTstudentProjectsRaw$`Email Address`) & DTstudentProjectsRaw$`Email Address` != "" )

setkey( DTstudentProjects, "Email Address" )
projectMarks = data.table( csvProjectMarks, key = "name" )
tuesdayEmails = data.table( csvTuesdayAttendance, key = "Email Address" )
thursdayEmails = data.table( csvThursdayAttendance, key = "Email Address" )
roster = data.table( csvRoster,  key = "Email Address" )

#setup blank cols
nStudents = nrow( DTstudentProjects )
DTstudentProjects$iterimProjectMark = numeric( nStudents )
DTstudentProjects$iterimIsTuesday = numeric( nStudents )
DTstudentProjects$iterimIsThursday = numeric( nStudents )
DTstudentProjects$iterimAttendanceMark = numeric( nStudents )
DTstudentProjects$`interim presentation (20%)` = numeric( nStudents )

#for each student in the project roster

for ( i in 1:nStudents ) {
  
  row = DTstudentProjects[i, ]
  email = row$`Email Address`
  projectName = row$`project`
  row$iterimProjectMark = projectMarks[ .( projectName ) ]$mark90percent 
  
  row$iterimIsTuesday = ifelse( is.na( tuesdayEmails[ .( email ) ]$sl ), 0, 1 )
  row$iterimIsThursday = ifelse( is.na( thursdayEmails[ .( email ) ]$sl ), 0, 1 )
  row$iterimAttendanceMark = ( row$iterimIsTuesday + row$iterimIsThursday ) / 2 
  
  row$`interim presentation (20%)` = round( 2 * ( row$iterimProjectMark + row$iterimAttendanceMark ), digits = 2 )
  DTstudentProjects[i, ] = row
  
}

orderedOutput = DTstudentProjects[ order( DTstudentProjects$project ), ]
orderedOutputEmail = DTstudentProjects[ order( DTstudentProjects$`Email Address` ), ]

write.csv( orderedOutput, outputPath )
write.csv( orderedOutputEmail, outputPathEmail )
