now=$(date +'%Y-%m-%d %H:%M:%S')
notes=$(gh release view -R $REPOSITORY --json body -q .body)
plain_text_notes=$(echo $notes) 
echo ""
echo $plain_text_notes 
echo ""
data='{
  "app_name": "'$APP_NAME'",
  "version": "'$VERSION'",
  "date": "'$now'",
  "links": [
    { "url": "'$LINK'" }
  ],
  "notes": "'$plain_text_notes'"
}'
echo $data
postmark email template -f=noreply@avilatek.com -t=$RECEIVE_EMAIL -a=deploy-new -m="$data"