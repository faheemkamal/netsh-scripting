@echo off
	set source=F:\Sharing
	set destin=E:\backup_share\
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4%%date:~4,2%%date:~7,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
SET dtStamp24=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)
set destin1=%destin%%dtStamp%
mkdir %destin1%
	robocopy "%source%" "%destin1%" /e /mir /z /MT:4 /maxage:7 /np /NJS /NJH /NFL
