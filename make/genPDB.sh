#! /bin/bash
matlab -nosplash -nodesktop -nodisplay -noawt -r "genPDB()" > genPDB.log 2>&1 &
tail -f genPDB.log