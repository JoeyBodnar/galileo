#!/bin/sh

check_notarization_status () {
  response=$(xcrun altool --notarization-info "$requestUUID" \
                              --username "${{ secrets.APPLE_ID_EMAIL }}" \
                              --password "${{ secrets.NOTARIZATION_PASSWORD }}")
  
  statusString=$(echo $response | awk -F: '{print $9}')
  echo $statusString | awk -FStatus '{print $1}'
}

status="in progress"
while [[ "$status" == "in progress" ]]; do
    sleep 10
    status=$(check_notarization_status)
    echo "the resulting status is $status"
done

if [[ $status != "success" ]]; then
    exit 1
fi