CREATE VIRTUAL TABLE pali_siam USING fts4(volume INT, page INT, items TEXT, content TEXT, tokenize=porter);
CREATE VIRTUAL TABLE thai_royal USING fts4(volume INT, page INT, items TEXT, content TEXT, tokenize=porter);
CREATE VIRTUAL TABLE thai_mcu USING fts4(volume INT, page INT, items TEXT, header TEXT, footer TEXT, display TEXT, content TEXT, tokenize=porter);
CREATE VIRTUAL TABLE thai_mbu USING fts4(volume INT, volume_orig INT, page INT, items TEXT, content TEXT, tokenize=porter);
