sensor_dir <- 'wasb:///contosohealth/data/sensor/vitals_stats'

# sampledate INT, vital_sensor_id string, sensor_type string, sensor_value INT, countvalue INT
sensor_colInfo <- list( 
				list(index=1, newName="sampledate", type="integer"),
				list(index=2, newName="vital_sensor_id", type="character"), 
				list(index=3, newName="sensor_type", type="character"),
				list(index=4, newName="sensor_value", type="integer"),
				list(index=5, newName="countvalue", type="integer")
			)

sensor_hdfs <- RxTextData(file=sensor_dir,
	colInfo=sensor_colInfo,
	fileSystem=RxHdfsFileSystem())

head(sensor_hdfs)
#   sampledate vital_sensor_id sensor_type sensor_value countvalue
# 1   20160101     VSS008-1658          po            1       7072
# 2   20160101     VSS008-1658          po            2       1736
# 3   20160101     VSS008-1658          po            3       7776
# 4   20160101     VSS008-1658          po            4       2284
# 5   20160101     VSS008-1658          po            5       3756
# 6   20160101     VSS008-1658          po            6        384

sensor_df <- rxDataStep(sensor_hdfs, maxRowsByCols=10000000)
write.csv(sensor_df, "sensor_df.csv", row.names=FALSE)

library(dplyr)
library(tidyr)

sensor_posture_counts <- sensor_df %>% spread(sensor_value, countvalue)
posture_names <- c("sleeping", "resting", "sitting", "eating", "standing", "walking", "running")
names(sensor_posture_counts)[4:10] <- posture_names[as.integer(names(sensor_posture_counts)[4:10])]
sensor_posture_counts$sensor_type <- NULL

# sensor_df %>% group_by(sampledate, vital_sensor_id) %>% summarize(total=sum(countvalue))
sensor_posture_counts <- transform(sensor_posture_counts, daily_minutes_walking=walking/16)

dim(sensor_posture_counts)
# 101763     10

with(sensor_posture_counts, plot(running ~ resting, pch='.'))
with(sensor_posture_counts, plot(running ~ sleeping, pch='.'))
with(sensor_posture_counts, plot(log(standing + walking + running) ~ log(sleeping + resting), pch='.'))
with(sensor_posture_counts, hist(log(standing + walking + running)/log(resting), breaks=30))
with(sensor_posture_counts, hist(log(standing + 2*walking + 3*running)/log(resting), breaks=30))

sensor_posture_counts <- transform(sensor_posture_counts, AQ=log(standing + 2*walking + 3*running)/log(resting))
hist(sensor_posture_counts$AQ, breaks=30)

head(sensor_posture_counts)

write.csv(sensor_posture_counts, "sensor_posture_counts2.csv", row.names=FALSE)
rxHadoopCopyFromLocal("sensor_posture_counts2.csv", 'wasb:///contosohealth/data/sensor/posture_counts/posture_counts')

