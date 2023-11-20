#!/bin/sh
cd /Applications/4D\ v19\ R7
echo " "
echo "----------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------- Build Component ------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------"
echo " "
./4D.app/Contents/MacOS/4D --project /Users/Shared/4D/GitHub/Build4D/Build4D/Project/Build4D.4DProject --dataless --headless --user-param "build"
echo " "
echo "----------------------------------------------------------------------------------------------------------------"
echo "-------------------------------------------------- Unit Tests --------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------"
echo " "
./4D.app/Contents/MacOS/4D --project /Users/Shared/4D/GitHub/Build4D/Build4D_UnitTests/Build4D_UnitTests/Project/Build4D_UnitTests.4DProject --dataless --headless --user-param "test"
