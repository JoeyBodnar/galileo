#!/bin/sh

# script to build, sign, notarize a new version, and upload to Github

rm -rf archive
rm -rf release

fastlane run increment_build_number
fastlane install_plugins

xcodebuild clean -project Galileo.xcodeproj -scheme "Nicea" -configuration Release archive -archivePath archive/result.xcarchive

xcodebuild archive -archivePath archive/result.xcarchive -exportArchive -exportOptionsPlist exportOptions.plist -exportPath archive

fastlane create_dmg

echo "Uploading to notary service. This may take a moment..."
requestInfo=$(xcrun altool --notarize-app \
            --file "archive/Galileo.app.dmg" \
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
  xcrun stapler staple "archive/Galileo.app.dmg"

  mkdir release
  mv archive/Galileo.app.dmg release/Galileo.app.dmg

  git add Galileo/Info.plist
  git add APIClient/Info.plist
  git add Galileo.xcodeproj/project.pbxproj

  git commit -m "release v $3"
  git push

  #git tag release/$3
  #git push origin release/$3

  # releaseZipped will be name of zip file. release is name of folder to zip
  zip -r releaseZipped release

  hub release create -a releaseZipped.zip -m "Release $3" $3

  echo "Success!"
fi
