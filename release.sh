#!/bin/sh

# script to build, sign, notarize a new version, and upload to Github

# remove previous folders
rm -rf archive
rm -rf app
rm -rf release

fastlane run increment_build_number

xcodebuild archive \
  -project Galileo.xcodeproj \
  -scheme "Nicea" \
  -configuration Release \
  -archivePath archive/result.xcarchive

# create .app executable
xcodebuild archive \
  -archivePath archive/result.xcarchive \
  -exportArchive \
  -exportOptionsPlist exportOptions.plist \
  -exportPath app

# remove these so they are not packaged with the dmg
rm -rf app/Packaging.log
rm -rf app/DistributionSummary.plist
rm -rf app/ExportOptions.plist

hdiutil create -format UDZO -srcfolder app Galileo.dmg

echo "Uploading to notary service. This may take a moment..."
requestInfo=$(xcrun altool --notarize-app \
            --file "Galileo.dmg" \
            --username "$1" \
            --password "@keychain:notarization-password" \
            --asc-provider "$2" \
            --primary-bundle-id "stephenbodnar.Nicea")

uuid=$(echo $requestInfo | awk '/RequestUUID/ { print $NF; }')

status="in progress"
while [[ "$status" == "in progress" ]]; do
    sleep 15
    status=$(xcrun altool --notarization-info "$uuid" \
            --verbose \
            --username "$1" \
            --password "@keychain:notarization-password" \
              | awk -F ': ' '/Status:/ { print $2; }')
    echo "waiting for Apple to finish notarization. Current status is: $status"
done

if [[ "$status" != "success" ]]; then
  echo "Error! The status was $status"
  exit 1
else
  xcrun stapler staple "Galileo.dmg"

  mkdir release
  mv Galileo.dmg release/Galileo.dmg

  git add Galileo/Info.plist
  git add APIClient/Info.plist
  git add Galileo.xcodeproj/project.pbxproj

  git commit -m "release v $3"
  git push

  zip -r galileo release

  hub release create -a galileo.zip -m "Release $3" $3

  echo "Success!"
fi
