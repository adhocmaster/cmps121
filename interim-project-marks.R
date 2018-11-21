library( "data.table")
csvPathInstructors = "F:\\myProjects\\cmps121\\interim-instructors.csv"
csvPathPeers = "F:\\myProjects\\cmps121\\interim-aggregated-peers.csv"
outputPath = "F:\\myProjects\\cmps121\\interim-project-marks-90-percent.csv"

csvInstructors = read.csv( csvPathInstructors, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )
csvPeers = read.csv( csvPathPeers, stringsAsFactors = FALSE, header = TRUE, check.names = FALSE )

namesPeer = names( csvPeers )

namesPeer[4] = "appPeer"
namesPeer[5] = "presentationPeer"

names( csvPeers ) = namesPeer

DTinstructors = data.table( csvInstructors, key = "name")
DTPeers = data.table( csvPeers, key = "name" )

DTJoined = merge( DTinstructors, DTPeers, all = TRUE )

#get the mismatched

DTJoined[ rowSums( is.na( DTJoined ) ) > 0 , ]



DTJoined$mark90percent = ( DTJoined$app * .35 + DTJoined$presentation * .2 + DTJoined$appPeer * .2 + DTJoined$presentationPeer * .15 ) * 2
fix( DTJoined )
DTJoined$mark100percent = DTJoined$mark90percent * 10 / 9

#cleanup
cleanData = subset( DTJoined, select = c( 'name', 'app', 'presentation', 'appPeer', 'presentationPeer', 'mark90percent', 'mark100percent' ) )

write.csv( cleanData, outputPath )
