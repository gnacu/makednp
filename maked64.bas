10 open15,8,15
20 open2,8,2,"#"
30 open3,10,3,"@:geolink.d64,w,s"
40 fort=1to17:fors=0to20
45 gosub500:nexts:nextt
50 fort=18to24:fors=0to18
55 gosub500:nexts:nextt
60 fort=25to30:fors=0to17
65 gosub500:nexts:nextt
70 fort=31to35:fors=0to16
75 gosub500:nexts:nextt
110 close2:close15:close3
499 rem ----transfer block----
500 print#15,"u1";2;0;t;s
505 print"reading:";t;":";s;" "
510 fori=0to255
520 get#2,a$:poke24576+i,asc(a$+chr$(0)):nexti
525 print"writing:";t;":";s;" "
530 fori=0to255
540 a=peek(24576+i):print#3,a;:nexti
550 return
