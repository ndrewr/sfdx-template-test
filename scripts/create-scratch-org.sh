#!/bin/sh

# IMPORTANT! Replace with the actual project name!
PROJECT_NAME=TestProj
DEVHUB_NAME="${PROJECT_NAME}DevHub"
PERMSET_NAME="${PROJECT_NAME}UserPermissions"
SFDX_AUTH_URL=sfdx_auth_url.txt

# SAMPLE DATA: Define your sample data, uncomment below while updating comma-separated data file names
# DATA_IMPORT_FILES=data/SomeObjects1.json,data/MySettings.json,data/EtcEtc.json

echo ""
echo "Authorizing you with the ${PROJECT_NAME} Dev Hub org..."
echo ""
sfdx force:auth:sfdxurl:store -f ${SFDX_AUTH_URL} -d -a ${DEVHUB_NAME} --json
if [ "$?" = "1" ]
then
        echo ""
	echo "ERROR: Can't authorize you with the ${PROJECT_NAME} Dev Hub org!"
	exit
fi
echo ""
echo "SUCCESS: You've been authorized with the ${PROJECT_NAME} Dev Hub org!"

echo ""
echo "Building your scratch org, please wait..."
echo ""
sfdx force:org:create -v ${DEVHUB_NAME} -f config/project-scratch-def.json -s -a ${PROJECT_NAME} -d 21 --json
if [ "$?" = "1" ]
then
        echo ""
	echo "ERROR: Can't create your org!"
	exit
fi
echo ""
echo "SUCCESS: Scratch org created!"

echo ""
echo "Pushing source to the scratch org! This may take a while! So now might be a good time to stretch your legs and/or grab your productivity beverage of choice..."
echo ""
sfdx force:source:push --json
if [ "$?" = "1" ]
then
        echo ""
	echo "ERROR: Pushing source to the scratch org failed!"
	exit
fi
echo ""
echo "SUCCESS: Source pushed successfully to the scratch org!"

echo ""
echo "Assigning the project permission set to the default scratch org user..."
echo ""
echo "TODO: Define app permission sets then uncomment the below."
# sfdx force:user:permset:assign -n ${PERMSET_NAME} --json
if [ "$?" = "1" ]
then
        echo ""
	echo "ERROR: Assigning the project permission set to the default scratch org user failed!"
	exit
fi
echo ""
echo "SUCCESS: Project permission set was assigned successfully to the default scratch org user!"

echo ""
echo "Importing default data to the scratch org..."
echo ""
echo "TODO: Data import!!! Create your sample data and uncomment below!"
# sfdx force:data:tree:import -f ${DATA_IMPORT_FILES} --json
if [ "$?" = "1" ]
then
        echo ""
	echo "ERROR: Importing default data to the scratch org failed!"
	exit
fi
echo ""
echo "SUCCESS: Default data was successfully imported to the scratch org!"

echo ""
echo "Running anonymous Apex scripts against the scratch org for additional configuration..."
echo ""
echo "TODO: Setup any objects e.g. user roles, if needed! Needs external apex script!"
# sfdx force:apex:execute -f scripts/setup.apex --json
if [ "$?" = "1" ]
then
        echo ""
	echo "ERROR: Running anonymous Apex scripts against the scratch org failed!"
	exit
fi
echo ""
echo "SUCCESS: Successfully ran anonymous Apex scripts against the scratch org!"

echo ""
echo "Opening scratch org for development, may the Flow be with you!"
echo ""
sleep 3
sfdx force:org:open
