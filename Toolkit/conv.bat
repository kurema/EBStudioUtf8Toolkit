perl read.pl < main.utf8.html >main.html
call createGaiji.bat
mkdir table
perl table.pl
table2image.exe  table imgt