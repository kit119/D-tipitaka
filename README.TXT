==================================
D-Tipitaka
==================================

D-Tipitaka (Database of Tipitaka) is a parallel development to support E-tipitaka, a program to read and search Pali - Thai Tipitaka (พระไตรปิฎก บาลี - ไทย) and other purposes for utilizing Pa-Th Tipitaka database. This will suit for advance user or developer to study, maintain, and distribute Tipitaka worldwide. Some additional database and extensions for handling of enhanced binary data and extra features may be updated in the future.  

In the faith and spirit on Buddhism's way, the author disclaims copyright to this database. It may be used as a basis for other programs, web applications, public domain, open source, or non-commercial distribution. So, it will never been made an encryption or locked password. 

Question and comment:
kit119 at gmail dot com

==================================
Features
==================================
* Merge Tipitaka database (done)
+ Integrate Pali-Thai dictionary (soon)
+ (Un)zip to reduce size (soon: libz is fast and interested)
- Index for fast & correct search (rapid search but severe problem on Thai tokenization, Pali is impossible)
- Classify Dhamma (need help from expert)
- Autocompletion / Autosuggestion ???
- What's else

==================================
History
==================================

Version 1.0 released 20/07/2554 B.E.

==================================
Version 1.0
==================================

The first motivation and original collection came from E-tipitaka-2.1.0 CD after the completion of the breathing mindfulness course during 15-18 July 2554 at YBAT#2. Database is stored in SQLite [www.sqlite.org], UTF-8 format that will be maintained as it is but changing the structure and combining all existing Tipitaka database. 

pali_siam: Tipitaka Pali Siamratch (Pali in Thai words) 
        พระไตรปิฎกฉบับสยามรัฐ (ภาษาบาลี เขียนอักษรไทย)
thai_royal: Tipitaka Thai Royal Edition (Thai translation)
        พระไตรปิฎกฉบับหลวง (แปลไทย)
thai_mcu: Tipitaka Thai Maha Chulalongkorn Raja Vidyalaya Edition (Thai translation)
        พระไตรปิฎกฉบับมหามกุฏราชวิทยาลัย (แปลไทย)
thai_mbu: Tipitaka Thai Mahamakut Buddhist University Edition (Thai translation)
        พระไตรปิฎกฉบับมหาจุฬาลงกรณราชวิทยาลัย (แปลไทย)

Original SQL Database
        $ pali_siam.sql.bz2     /* MD5:Checksum = 7B497ECBB419D25530137F46AE3843A8
        $ thai_mbu.sql.bz2      /* MD5:Checksum = D4A21BFEBBDB2E3BDA4935AD5F1C3765 
        $ thai_mcu.sql.bz2      /* MD5:Checksum = 44604DF05C97AE153BCBBACBA7698617
        $ thai_royal.sql.bz2    /* MD5:Checksum = 503F60EAD26270E5E5F13BF24B0839B8
        
Make Each SQLite Database:
        $ bunzip2 pali_siam.sql.bz2
        $ sqlite3 pali_siam.sqlite < pali_siam.sql

In 1 liner:
        $ bunzip2 pali_siam.sql.bz2 | sqlite3 pali_siam.sqlite

Table structure:
        $ cat *.sql.bz2 | bunzip2 | grep CREATE
        CREATE TABLE pali_siam (volume INT, page INT, items TEXT, content TEXT);
        CREATE TABLE thai_mbu (volume INT, volumn_orig INT, page INT, items TEXT, content TEXT);
        CREATE TABLE thai_mcu (volume INT, page INT, items TEXT, header TEXT, footer TEXT, display TEXT, content TEXT);
        CREATE TABLE thai_royal (volume INT, page INT, items TEXT, content TEXT);

Make All SQLite Database:
        $ cat *.sql.bz2 | bunzip2  | sqlite3 tipitaka.sqlite
        $ tipitaka.sqlite  /* MD5:Checksum = BC38D4E45F35616ED1B19B08D1264793  
                                                                  
Basic SQLite Commandline:
        $ sqlite3 tipitaka.sqlite
        SQLite version 3.7.7.1 2011-06-28 17:39:05
        Enter ".help" for instructions
        Enter SQL statements terminated with a ";"
        /* show all tables:
        sqlite> .tables      
        pali_siam   thai_mbu    thai_mcu    thai_royal
        /* read  thai_royal, volume 24, page 110:
	sqlite> SELECT * FROM thai_royal WHERE volume=24 AND page=110;    
	...
	/* search for content(s) like ...อานาปานสติ...
        sqlite> SELECT content FROM thai_mcu WHERE content LIKE '%อานาปานสติ%'  
        ...
        /* export thai_mbu, volume 15:
        sqlite> .output thai_mbu_vol15.txt
        sqlite> .separator ''
        sqlite> SELECT content FROM thai_mbu WHERE volume=15    

