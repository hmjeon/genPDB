genPDB v1.0

1. Without input arguments (Windows and Linux)
	1.1. Single PDB - Launch MATLAB, run genPDB.m
	1.2. Multiple PDBs - Launch MATLAB, run genPDB.m with optList = 1

2. With input four arguments (Windows and Linux)
	2.1 Only single PDB:
	error = genPDB('cndo\','PDB\', 'ex01', 'cmd')

For Linux,
matlab -nosplash -nodesktop -nodisplay -noawt -r "genPDB('cndo\', 'results\', 'ex02', 'all')" > genPDB.log 2>&1 &
tail -f genPDB.log