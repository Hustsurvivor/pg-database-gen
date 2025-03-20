for i in `ls tpch/table/*.tbl`
do
 name="tpch/table/tbl/$i"
 echo $name
 `touch $name`
 `chmod 777 $name`
 sed 's/|$//' $i >> $name;
done