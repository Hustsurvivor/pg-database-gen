# pg-database-gen
steps to generate database(dataset) used for ML4DB

## IMDB
The original repository can be found at [Join Order Benchmark](https://github.com/gregrahn/join-order-benchmark).

```
# Download JOB files into imdb directory
cd imdb
wget -c https://event.cwi.nl/da/job/imdb.tgz && tar -xvzf imdb.tgz

# Create imdb database 
psql -U postgres -c 'CREATE DATABASE imdb;'

# Create all tables
psql -U postgres -d imdb -f scripts/schematext.sql

# Load JOB into imdb database
psql -U postgres -d imdb -f scripts/load_job_postgres.sql
psql -U postgres -d imdb -f scripts/fkindexes.sql 

# Analyze imdb 
psql -U postgres -d imdb -c "ANALYZE verbose;"
```

## STACK
This dataset was published in the [Bao paper](https://dl.acm.org/doi/abs/10.1145/3448016.3452838) and is available [here](https://rmarcus.info/stack.html).

```
# Download the PostgreSQL dump from Ryan Marcus  
# If using PostgreSQL 13 or later, choose `so_pg13`; otherwise, use `so_pg12`

cd stack
wget https://www.dropbox.com/s/98u5ec6yb365913/so_pg12
# For PostgreSQL 13+, use the following:
# wget https://www.dropbox.com/s/98u5ec6yb365913/so_pg13

# Create stack database  
psql -c "CREATE DATABASE stack;"
pg_restore -d stack -j 4 --clean --no-privileges --no-owner --verbose so_pg12

# Analyze 
psql -d stack -c "ANALYZE verbose;"
```

## STATS
The original **STATS** dataset is available at [this link](https://relational.fit.cvut.cz/dataset/Stats).  
For a simplified version, refer to [this repository](https://github.com/Nathaniel-Han/End-to-End-CardEst-Benchmark).  
Here, I use the simplified version and demonstrate how to generate the STATS dataset.
```
cd stats 

# Create stats database
psql -c "CREATE DATABASE stats;"

# Create all tables
psql -d stats -f scripts/schematext.sql

# Load data into stats database
psql -d stats -f scripts/stats_load.sql
psql -d stats -f scripts/stats_index.sql

# Analyze 
psql -d stats -c "ANALYZE verbose;"
```
## TPCH
Official **TPC-H** benchmark - http://www.tpc.org/tpch   
The tpch-kit repository can be found [here](https://github.com/gregrahn/tpch-kit).  
In this guide, I only demonstrate how to generate the TPC-H dataset in Ubuntu. The TPC-H workload may be included in future updates.

```
# Ensure required development tools are installed
sudo apt-get install git make gcc

# Clone the submodule and build the tools
git submodule update --init --recursive # If you haven't cloned yet
cd /<repo>/tpch/tpch-kit/dbgen

# Build the tools for PostgreSQL on Linux
make MACHINE=LINUX DATABASE=POSTGRESQL

# Generate 10GB of data
# -s 10 generates 10GB of data
# -f overwrites any previously generated files
./dbgen -s 10 -f

# Move the generated table files to the appropriate directory
mkdir -p /<repo>/tpch/table 
mv *.tbl /<repo>/tpch/table 

# Run the script to process the table files
cd /<repo>/tpch/scripts
bash process_tbl_file.sh

# Create the TPC-H database
psql -c 'CREATE DATABASE tpch'

# Load the schema and data 
psql -d tpch -f schematext.sql
psql -d tpch -f load_tpch_postgres.sql

# Optionally, add foreign key constraints
psql -d tpch -f reference.sql

# Analyze 
psql -d tpch -c 'ANALYZE verbose;'
```

## TPCDS
The official TPC-DS tools can be found at [tpc.org](http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp).  
The tpcds-kit repository can be found [here](https://github.com/gregrahn/tpcds-kit).  
```
# Ensure required development tools are installed
sudo apt-get install gcc make flex bison byacc git

# 编译
cd /<repo>/tpcds/tpcds-kit/tools
make 

# Generate 10GB of data (adjust the scale factor as needed)
./dsdgen -scale 10 -dir /<repo>/tpcds/table

# Process the generated table data
cd /<repo>/tpcds/scripts
bash process_table_file.sh

# Create TPC-DS database 
psql -c 'CREATE DATABASE tpcds'

# Load schema and data into the database
psql -d tpcds -f schematext.sql
bash load_tpcds_postgres.sh

# Optionally, add foreign key constraints
psql -d tpcds -f reference.sql

# Analyze 
psql -d tpcds -c 'ANALYZE verbose;'
```