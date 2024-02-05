#!/bin/sh
cd /Applications/4D\ v20.2
echo " "
echo "----------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------- Build Component ------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------"
echo " "
./4D.app/Contents/MacOS/4D --project /Users/admin/Desktop/Build4D-dom-client-server/Build4D/Project/Build4D.4DProject --dataless --headless --user-param "build"
echo " "
echo "----------------------------------------------------------------------------------------------------------------"
echo "-------------------------------------------------- Unit Tests --------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------"
echo " "
./4D.app/Contents/MacOS/4D --project /Users/admin/Desktop/Build4D-dom-client-server/Build4D_UnitTests/Project/Build4D_UnitTests.4DProject --dataless --headless --user-param "test"
