
csvPath = "F:\\myProjects\\cmps121\\Interim Evaluation - Instructors - fixed.csv"
outputPath = "F:\\myProjects\\cmps121\\interim-instructors.csv"

#must remove the first line from CSV
csvList = read.csv( csvPath, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )

names( csvList ) = c( "Project", "b1", 
                      "h1", 'a1', 'p1',
                      "h2", 'a2', 'p2',
                      "h3", 'a3', 'p3', 
                      'b2')
data = subset( data.frame( csvList ), select = c( "Project", 
                                                  'a1', 'p1',
                                                  'a2', 'p2',
                                                  'a3', 'p3'
                                                  ) 
               )
head( data )

aggregated = data.frame(
  
  name = data$Project,
  app = ( data$a1 + data$a2 + data$a3 ) / 3,
  presentation = ( data$p1 + data$p2 + data$p3 ) / 3
  
)
head( aggregated )

write.csv( aggregated, file = outputPath )
