#!/bin/zsh

t=/usr/bin/time

#for p in apache berkeleydb busybox cherokee emacs gimp gnuplot libxml2 mpsolve openvpn parrot postgresql sendmail subversion vim xfig xterm freebsd linux; do
for p in linux; do
  echo "* Running project: $p"

  echo "Timing Data:" 
  $t -f "user:%U system:%S total:%e cpu:%P" python -m codeface.cli -l info setup -p conf/benchmark/$p.conf

  echo "Database Statistics:"
  mysql -u root -phamster162 codeface -e "select 'releases', count(*) from release_timeline rt where rt.type = 'release' union select 'variables', count(*) from spl_variable union select 'file_instances', count(*) from spl_file_instance union select 'file', count(*) from spl_file;" >> res/$p.txt

  mysql -u root -phamster162 codeface -e "SELECT table_schema "dbname", sum( data_length + index_length ) / 1024 / 1024 "size"  FROM information_schema.TABLES where table_schema = 'codeface' GROUP BY table_schema;"

done

