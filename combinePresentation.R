#utility to combine files

combinedPath = "F:\\myProjects\\cmps121\\interim-aggregated.csv" 
outputPaths = c( "F:\\myProjects\\cmps121\\interim-tuesday-aggregated.csv",
                 "F:\\myProjects\\cmps121\\interim-thursday-aggregated.csv"
)

totalDF = data.frame()
for ( path in outputPaths ) {
  
  df = data.frame( read.csv( path, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE ) )
  
  totalDF = rbind( totalDF, df )
  
}


totalDF<- totalDF[ seq( dim(totalDF)[1],1 ), ] #reversed to keep latest

length( totalDF$name )
length( unique( totalDF$name ) )

print( "Duplicate items: " )
totalDF[ duplicated( totalDF$name ), ]

totalDF = totalDF[ !duplicated( totalDF$name ), ]

totalDF<- totalDF[ seq( dim(totalDF)[1],1 ), ] #reversed to get the original ordering

write.csv( totalDF, file = combinedPath )
