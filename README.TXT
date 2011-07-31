==================================
D-Tipitaka
==================================

D-Tipitaka (Database of Tipitaka) is a parallel development to support E-tipitaka, a program to read and search Pali - Thai Tipitaka and other purposes for utilizing Pa-Th Tipitaka database. This will suit for advance user or developer to study, maintain, and distribute Tipitaka worldwide. Some additional database and extensions for handling of enhanced binary data and extra features may be updated in the future.  

In the faith and spirit on Buddhism's way, the author disclaims copyright to this database. It may be used as a basis for other programs, web applications, public domain, open source, or non-commercial distribution. So, it will never been made an encryption or locked password. 

Question and comment:
kit119 at gmail dot com

==================================
Features
==================================
* Merge Tipitaka Database 
        - Tipitaka Pali Siamratch (Pali in Thai words) 
        - Tipitaka Thai Royal Edition (Thai translation)
        - Tipitaka Thai Maha Chulalongkorn Raja Vidyalaya Edition (Thai translation)
        - Tipitaka Thai Mahamakut Buddhist University Edition (Thai translation)
* Enhanced indexing and searching process (SQL MATCH clause)
        - Extend build-in Full-Text Search version 4 (FTS4)
        - Tokenization by  International Components for Unicode (ICU) for Thailand unicode
+ (Un)zip to reduce size (soon: zlib is fast and interested)
+ Integrate Pali-Thai dictionary (soon)
- Classify Dhamma (need help from expert)
- Autocompletion / Autosuggestion ???
- What's else

==================================
History
==================================

Version 1.0 released 20/07/2554 B.E.
Version 1.2 released 12/08/2554 B.E. (Mother Day)

==================================
Version 1.0
==================================

The first motivation and original collection came from E-tipitaka-2.1.0 CD after the completion of the breathing mindfulness course during 15-18 July 2554 at YBAT#2. Database is stored in SQLite [www.sqlite.org], UTF-8 format that will be maintained as it is but changing the structure and combining all existing Tipitaka database. 

pali_siam: Tipitaka Pali Siamratch (Pali in Thai words) 
thai_royal: Tipitaka Thai Royal Edition (Thai translation)
thai_mcu: Tipitaka Thai Maha Chulalongkorn Raja Vidyalaya Edition (Thai translation)
thai_mbu: Tipitaka Thai Mahamakut Buddhist University Edition (Thai translation)

Original SQL Database
        $ pali_siam.sql.bz2      
        $ thai_mbu.sql.bz2       
        $ thai_mcu.sql.bz2       
        $ thai_royal.sql.bz2     
        
Make Each SQLite Database:
        $ bunzip2 pali_siam.sql.bz2
        $ sqlite3 pali_siam.db < pali_siam.sql

In 1 liner:
        $ bunzip2 pali_siam.sql.bz2 | sqlite3 pali_siam.db

Table structure:
        $ cat *.sql.bz2 | bunzip2 | grep CREATE
        CREATE TABLE pali_siam (volume INT, page INT, items TEXT, content TEXT);
        CREATE TABLE thai_royal (volume INT, page INT, items TEXT, content TEXT);
        CREATE TABLE thai_mbu (volume INT, volume_orig INT, page INT, items TEXT);
        CREATE TABLE thai_mcu ((volume INT, page INT, items TEXT, header TEXT, footer TEXT, display TEXT);

Make All SQLite Database:
        $ cat *.sql.bz2 | bunzip2  | sqlite3 dtipitaka.db
        $ dtipitaka.db   
                                                                  
Basic SQLite Commandline:
        $ sqlite3 dtipitaka.db
        SQLite version 3.7.7.1 2011-06-28 17:39:05
        Enter ".help" for instructions
        Enter SQL statements terminated with a ";"
        sqlite> .tables                 /* show all tables:
        pali_siam   thai_mbu    thai_mcu    thai_royal
	sqlite> SELECT * FROM thai_royal WHERE volume=24 AND page BETWEEN 110 AND 115;      /* read  thai_royal, volume 24, page 110-115:
	...
        sqlite> SELECT content FROM thai_mcu WHERE content LIKE '%keywords%';       	/* search for content(s) like ...keywords...
        ...
        sqlite> .output thai_mbu_vol15.txt                                /* export thai_mbu, volume 15:
        sqlite> .separator ''
        sqlite> SELECT content FROM thai_mbu WHERE volume=15;

==================================
Version 1.1
==================================

SQL files, "dtipitaka10.sql" and "dtipitaka11-fts4.sql", are added in order to modify and check SQLite structure easier.

For version 1.0:
        $ cat dtipitaka10.sql
        CREATE TABLE pali_siam (volume INT, page INT, items TEXT, content TEXT);
        CREATE TABLE thai_royal (volume INT, page INT, items TEXT, content TEXT);
        CREATE TABLE thai_mcu (volume INT, page INT, items TEXT, header TEXT, footer TEXT, display TEXT, content TEXT);
        CREATE TABLE thai_mbu (volume INT, volume_orig INT, page INT, items TEXT);      
        $ sqlite3 dtipitaka.db < dtipitaka10.sql
        $ cat *.bz2 | bunzip2 | grep -v CREATE | sqlite3 dtipitaka.db       

For version 1.1:        
        $ cat dtipitaka11-fts4.sql
        CREATE VIRTUAL TABLE pali_siam USING fts4(volume INT, page INT, items TEXT, content TEXT, tokenize=porter);
        CREATE VIRTUAL TABLE thai_royal USING fts4(volume INT, page INT, items TEXT, content TEXT, tokenize=porter);
        CREATE VIRTUAL TABLE thai_mcu USING fts4(volume INT, page INT, items TEXT, header TEXT, footer TEXT, display TEXT, content TEXT, tokenize=porter);
        CREATE VIRTUAL TABLE thai_mbu USING fts4(volume INT, volume_orig INT, page INT, items TEXT, tokenize=porter);
        $ sqlite3 dtipitaka.db < dtipitaka11-fts4.sql
        $ cat *.bz2 | bunzip2 | grep -v CREATE | sqlite3 dtipitaka.db       

Full-Text Search (FTS) is introduced with the anticipation to improve indexing and searching ability.  SQLite FTS3 / FTS4 modules create special virtual tables integrating into database of full-text index, which is very fast searching query to MATCH user's KEYWORDS from database row known as tokenization (or tokens). Database size are about to enlarge due to additional virtual tables. In case of your SQLite is not supported by FTS, it need to recompile.

        $ tar xvfz sqlite-src-3070701.tar.gz
        $ export "CPPFLAGS= -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4"
        $ ./configure
        $ make
        $ make test
        $ make install
      
At the end, this version will not be released bacause it is a kind of a technical failure caused by incompatible tokens to Thai language. My friend has earlier warned me but I am a kind of insist and want to test. Build-in tokenization process (simple or stemming porter) are unable to index Pa-Th Tipitaka database correctly as a result of query with poor result. 

==================================
Version 1.2
==================================

Great!!! Build-in full-text search is now working. The key is about unicode algorithms to solve indexing Thai language. I found that ICU library is the best one (totally I'm not hurted in any library or hospital :D). International Components for Unicode:ICU [http://site.icu-project.org/] is really the solution of this kind including the ability to convert, collate, format, etc. Because ICU is not included in SQLite package, it is needed to download and compile. 

        $ tar xvfz icu4c-4_8_1-src.tar.bz
        $ ./configure
        $ make
        $ make test
        $ make install

For your convenience, there are binaries for independent machines available. Next, SQLite also needed to recompile and share ICU library. It is now ready to compile SQLite with ICU extension

        $ export "CPPFLAGS= -DSQLITE_ENABLE_ICU"
        $ ./configure
        $ make clean
        $ make
        $ make install

If everything is fine, SQLite3 binary will be compiled. It is now about to create the new database and test for the result.

        $ cat dtipitaka12-fts4-icu48.sql
        CREATE VIRTUAL TABLE pali_siam USING fts4(volume INT, page INT, items TEXT, content TEXT, tokenize=icu th_TH);
        CREATE VIRTUAL TABLE thai_royal USING fts4(volume INT, page INT, items TEXT, content TEXT, tokenize=icu th_TH);
        CREATE VIRTUAL TABLE thai_mcu USING fts4(volume INT, page INT, items TEXT, header TEXT, footer TEXT, display TEXT, content TEXTt, tokenize=icu th_TH);
        CREATE VIRTUAL TABLE thai_mbu USING fts4(volume INT, volume_orig INT, page INT, items TEXT, content TEX, tokenize=icu th_TH);

        $ sqlite3 dtipitaka.db < dtipitaka12-fts4-icu48.sql
        $ cat *.bz2 | bunzip2 | grep -v CREATE | sqlite3 dtipitaka.db       

Of course, the final size is larger than the earlier one since it is included virtual tables for indexing and searching. Let begin to perform and test some exercise.

SQL %LIKE% VS 'MATCH' Clause:
        sqlite> SELECT * FROM thai_royal WHERE content LIKE '%keywords%';     /* slow search, 100% found by liner scan (standard)
        sqlite> SELECT * FROM thai_royal WHERE content MATCH 'keywords';     /* rapid search, index search found
        
Useful function.
        sqlite> SELECT * from thai_royal WHERE content MATCH 'keywords' order by  matchinfo(thai_royal) DESC;   /* sort found results
        sqlite > SELECT snippet(thai_royal, '[', ']', ' ... ') from thai_royal WHERE content MATCH 'keywords';     /* format fragment text

If the found is so important for study and we do not care much about time.
        sqlite> LIKE '%keywords%' INTERSECT MATCH 'keywords';              /* 80-90% found by INTERSECT
        sqlite> LIKE '%keywords%' UNION MATCH 'keywords';                        /* 100% or higher found UNION, 




