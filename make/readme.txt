genPDB v1.0

1. Without input arguments (Windows and Linux)
	1.1. Single PDB - Launch MATLAB, run genPDB.m
	1.2. Multiple PDBs - Launch MATLAB, run genPDB.m with optList = 1

2. With input four arguments (Windows and Linux)
	2.1 Only single PDB:
	error = genPDB('cndo\', 'PDB\', 'ex01', 'cmd')
	
	2.1. argument #1 - Working directory
	2.2. argument #2 - Output directory
	2.3. argument #3 - File name without cndo
	2.4. argument #4 - Output option: pdb, fig, cmd, all

For Linux,
matlab -nosplash -nodesktop -nodisplay -noawt -r "genPDB('cndo/', 'PDB/', 'ex2', 'pdb')" > genPDB.log 2>&1 &
tail -f genPDB.log


matlab -nosplash -nodesktop -nodisplay -noawt -r "C:\Users\hyung\Desktop\Coding\genPDB\make\genPDB('C:\Users\hyung\Desktop\Coding\test', 'C:\Users\hyung\Desktop\Coding\test\PDB', 'ex1', 'pdb')"