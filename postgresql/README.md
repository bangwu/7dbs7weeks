Installation
============

Postgres 9.3

Install package
---------------

	# emerge -q dev-db/postgresql-server

Configuration
-------------

Generate configuration files and data

	# emerge --config =dev-db/postgresql-server-9.3.2


Move configuration files to /etc/postgresql-9.3/ directory

	# mkdir /etc/postgresql-9.3
	# mv /var/lib/postgresql/9.3/data/*.conf /etc/postgresql-9.3/
	# chown postgres:postres -R /etc/postgresql-9.3/
	# chmod 0700 -R /etc/postgresql-9.3/


Start server
------------

	# /etc/init.d/postgresql-9.3 start

Connect server to set password for *postgres* user

	# psql -U postgres
	 
	psql (9.3.2)
	Type "help" for help.
	postgres=# \password
	Enter new password: 
	Enter it again: 
	postgres=# \q
	#

We configure to use password when connect to server by editting /etc/postgresql-9.3/pg_hba.conf

	# TYPE  DATABASE        USER            ADDRESS                 METHOD
	local   all             all                                     password
	host    all             all             127.0.0.1/32            password
	host    all             all             ::1/128                 password

Let's reload configuration

	# /etc/init.d/postgresql-9.3 reload

Before we connect with server by username and password, we have to install extensions: tablefunc, dict_xsyn, fuzzystrmatch, pg_trgm, cube. For example with tablefunc extension:

	# cd /usr/share/postgresql-9.3/extension
	# psql -U postgres -d sevendbs -f tablefunc--1.0.sql
	# psql -U postgres
	postgres=# \c sevendbs
	postgres=# CREATE EXTENSION tablefunc;




