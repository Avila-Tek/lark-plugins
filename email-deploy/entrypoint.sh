now=$(date +'%Y-%m-%d %H:%M:%S')
notes=$(gh release view -R $REPOSITORY --json body -q .body)
plain_text_notes=$(echo $notes) 
# Convertir Markdown a HTML
# Aquí usamos pandoc para la conversión, asegúrate de tener pandoc instalado
html_notes=$(echo "$notes" | pandoc -f markdown -t html)
# data='{
#   "app_name": "'$APP_NAME'",
#   "version": "'$VERSION'",
#   "date": "'$now'",
#   "links": [
#     { "url": "'$LINK'" }
#   ],
#   "notes": "'$plain_text_notes'"
# }'
# echo $data
# postmark email template -f=noreply@avilatek.com -t=$RECEIVE_EMAIL -a=deploy-new -m="$data"

# Preparar el contenido HTML del correo
html_content='
<div>
    <h1>Versión '$VERSION' de '$APP_NAME' disponible</h1>
    <p>Hay un nuevo deploy de '$APP_NAME' que se ejecutó el '$now'</p>
    <p>Aquí esta la información del deploy:</p>

    <p>App Name: '$APP_NAME'</p>
    <p>Version: '$VERSION'</p>
    <p>Date: '$now'</p>
    '$html_notes'
    <br>
    <p>Gracias, el equipo de DevOps</p>
</div>'

# Enviar el correo usando Postmark sin template
postmark email raw -f=noreply@avilatek.com -t=$RECEIVE_EMAIL --subject="Despliegue de $APP_NAME - $now" --html="$html_content" 