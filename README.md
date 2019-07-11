# Data Processing on Hive Cluster

Processing data on Hive cluster with data layers and partitioning

## Task

1. Download data from [kaggle](https://www.kaggle.com/rush4ratio/video-game-sales-with-ratings/data)
2. Put data to hdfs
3. Make external table for data in RAW datebase
4. Make table ORC for data in ODS database. Data types must match to data types in RAW table, implement partitioning by year
5. Make query to transfer data from RAW to ODS
6. Register metadata table about Platform in MD layer. Table should have 2 columns: string column for Platform and int column for numeric Platform identifyer
7. Aggregate information about EU sales in ADS layer: game name, platform identifyer from metadata, total sales
8. Make query to find game with most sales for every year from ADS layer, display platform with the use of registered metadata table

## Solution

### Initial Preparation

Add to your .bashrc

#### For Hadoop

```
# Set Java Home
export JAVA_HOME=/usr/java/default
export PATH=${JAVA_HOME}/bin:${PATH}

# Set Hadoop Home
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar
export HADOOP_HOME=~/hadoop-3.1.2
export PATH="$HADOOP_HOME/bin/:$HADOOP_HOME/sbin:$PATH"

# Set Hive Home
export HIVE_HOME=~/apache-hive-3.1.1-bin
export PATH="$HIVE_HOME/bin/:$PATH"
```

USE JAVA 8, NOT HIGHER!

Exec code to evaluate if preparations are correct
```
$ source .bashrc
$ java -version
$ javac -version
$ hadoop version
$ hadoop --version
```

Download Hive

`$ wget http://apache.volia.net/hive/hive-3.1.1/apache-hive-3.1.1-bin.tar.gz`

Further how-to for hive installation and preparation:
[Euderica](https://www.edureka.co/blog/apache-hive-installation-on-ubuntu)

!!!
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
!!!

### Before start `hive`:
`$ hdfs dfsadmin -safemode leave`

### After hive started:
`hive> set hive.exec.dynamic.partition=true;`
`hive> set hive.exec.dynamic.partition.mode=nonstrict;`

### Download Dataset

`$ wget https://github.com/otacke/udacity-machine-learning-engineer/raw/master/submissions/capstone_project/data/Video_Games_Sales_as_at_22_Dec_2016.csv`

Clean up first label row:
`$ tail -n +2 Video_Games_Sales_as_at_22_Dec_2016.csv > VideoGamesSalesNoHeader.csv`

Put file to server:
`$ scp VideoGamesSalesNoHeader.csv user@ip-address:~/`

### Clean up data with mapreduce
```
$ scp *.py user@ip-address:~/
$ hadoop fs -mkdir /user/hadoop/raw-input-games
$ hadoop fs -put VideoGamesSalesNoHeader.csv /user/hadoop/raw-input-games
$ mapred streaming -input /user/hadoop/raw-input-games -output /user/hadoop/raw-output-games -mapper 'python mapper_cleaner.py' -reducer 'python reducer_cleaner.py' -file mapper_cleaner.py -file reducer_cleaner.py -numReduceTasks 4
```

### Load cleaned data to external table

`$ hive -f raw_videogames.sql`

Create cleaned up table with datatypes

`$ hive -f raw_videogames_cleaned.sql`

### Create ODS data table with ORC and partitioning by year_of_release

`$ hive -f ods_videogames.sql`

Fix dynamic partitioning issue:
`$ hive -e 'set hive.exec.dynamic.partition=true;'`
`$ hive -e 'set hive.exec.dynamic.partition.mode=nonstrict;'`

`$ hive -f ods_videogames_partitioning.sql`


### Generate metadata table

`$ hive -f md_videogames.sql`

### Generate ADS layer

`$ hive -f ads_videogames.sql`

### Make query to find game with most sales for every year from ADS layer, display platform with the use of registered metadata table

`$ hive -f top_games_by_year.sql`

## Result
|Name| Sales |Year|Platform|
| --- | --- | --- | --- |
|Alter Ego      |0.03    |1985|    PC|
|SimCity      |0.02    |1988|    PC|
|Doom      |0.0     |1992|    PC|
|Battle Arena Toshinden      |0.26    |1994|    PS|
|Tomb Raider      |1.97    |1996|    PS|
|Gran Turismo      |3.87    |1997|    PS|
|Tekken 3      |2.22    |1998|    PS|
|Gran Turismo 2      |3.42    |1999|    PS|
|Driver 2      |2.1     |2000|    PS|
|Gran Turismo 3: A-Spec      |5.09    |2001|    PS2|
|Grand Theft Auto: Vice City      |5.49    |2002|    PS2|
|Need for Speed Underground      |2.83    |2003|    PS2|
|World of Warcraft      |6.21    |2004|    PC|
|Brain Age: Train Your Brain in Minutes a Day      |9.2     |2005|    DS|
|Wii Sports       |28.96   |2006|    Wii|
|Wii Fit       |8.03    |2007|    Wii|
|Mario Kart Wii       |12.76   |2008|    Wii|
|Wii Sports Resort       |10.93   |2009|    Wii|
|Kinect Adventures!       |4.89    |2010|    X360|
|Call of Duty: Modern Warfare 3       |5.73    |2011|    PS3|
|Call of Duty: Black Ops II       |5.73    |2012|    PS3|
|Grand Theft Auto V       |9.09    |2013|    PS3|
|Grand Theft Auto V       |6.31    |2014|    PS4|
|FIFA 16       |6.12    |2015|    PS4|
|FIFA 17       |5.75    |2016|    PS4|


## Known Problems

**PROBLEM**
Cannot create directory /tmp/hive/$USER/23a7e077-353c-4af2-9bfe-10159a6331a5. Name node is in safe mode.
**SOLUTION**
`$ hadoop dfsadmin -safemode leave`
**OR**
`$ hdfs dfsadmin -safemode leave`

**PROBLEM**
Hive installation issues: Hive metastore database is not initialized
**SOLUTION**
[stackoverflow](https://stackoverflow.com/questions/35655306/hive-installation-issues-hive-metastore-database-is-not-initialized)

Before you run hive for the first time, run
`$ schematool -initSchema -dbType derby`

If you already ran hive and then tried to initSchema and it's failing:
`$ mv metastore_db metastore_db.tmp`

Re run
`$ schematool -initSchema -dbType derby`

Run hive again
`$ hive`

**PROBLEM**
Where is my NULLs??????
[How to use blank as null in hive](https://abhijitsureshshingate.wordpress.com/2013/11/16/how-to-use-blank-as-null-in-hive/)
**SOLUTOIN**
`TBLPROPERTIES('serialization.null.format'='')`


**PROBLEM**
Hive does recognize commma inside quotes as delimeter.
**SOLUTION**
[Comma between data](https://community.hortonworks.com/questions/173840/comma-in-between-data-of-csv-mapped-to-external-ta.html)
[CSV Serde](https://cwiki.apache.org/confluence/display/Hive/CSV+Serde)
```
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",
    "quoteChar"     = "\"")
```
**DRAWBACKS**
All fields inside table become strings
