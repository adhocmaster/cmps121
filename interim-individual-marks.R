library( "data.table")
csvPathProjectMarks = "F:\\myProjects\\cmps121\\interim-project-marks-90-percent.csv"
csvPathStudentProjects = "F:\\myProjects\\cmps121\\CMPS121 - Roster - Project - Fixed.csv"
csvPathTuesdayAttendance = "F:\\myProjects\\cmps121\\interim-tuesday-attendance.csv"
csvPathThursdayAttendance = "F:\\myProjects\\cmps121\\interim-thursday-attendance.csv"

outputPath = "F:\\myProjects\\cmps121\\interim-aggregated.csv"


csvProjectMarks = read.csv( csvPathProjectMarks, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvStudentProjects = read.csv( csvPathStudentProjects, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvTuesdayAttendance = read.csv( csvPathTuesdayAttendance, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvThursdayAttendance = read.csv( csvPathThursdayAttendance, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )

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
DTstudentProjects = subset( DTstudentProjectsRaw, !is.na( DTstudentProjectsRaw$`Email Address`) & DTstudentProjectsRaw$`Email Address` != "" , select = c( "Email Address", "project" ))

setkey( DTstudentProjects, "Email Address" )
projectMarks = data.table( csvProjectMarks, key = "name" )
tuesdayEmails = data.table( csvTuesdayAttendance, key = "Email Address" )
thursdayEmails = data.table( csvThursdayAttendance, key = "Email Address" )

#setup blank cols
nStudents = nrow( DTstudentProjects )
DTstudentProjects$iterimProjectMark = numeric( nStudents )
DTstudentProjects$iterimIsTuesday = numeric( nStudents )
DTstudentProjects$iterimIsThursday = numeric( nStudents )
DTstudentProjects$iterimAttendanceMark = numeric( nStudents )
DTstudentProjects$iterimMarks = numeric( nStudents )

#for each student

for ( i in 1:nStudents ) {
  
  row = DTstudentProjects[i, ]
  email = row$`Email Address`
  projectName = row$`project`
  row$iterimProjectMark = projectMarks[ .( projectName ) ]$mark90percent
  
  row$iterimIsTuesday = ifelse( is.na( tuesdayEmails[ .( email ) ]$sl ), 0, 1 )
  row$iterimIsThursday = ifelse( is.na( thursdayEmails[ .( email ) ]$sl ), 0, 1 )
  row$iterimAttendanceMark = ( row$iterimIsTuesday + row$iterimIsThursday ) / 20 #10%
  
  row$iterimMarks = row$iterimProjectMark + row$iterimAttendanceMark
  DTstudentProjects[i, ] = row
  
}


write.csv( DTstudentProjects, outputPath )
