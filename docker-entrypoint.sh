#!/bin/bash
HTML_TEMPLATE=${HTML_TEMPLATE:-'index.html'}

#replace environment variables
rm -rf ./env-config.js
touch ./env-config.js
envs=$(printenv)
echo "window._env_ = {" >> ./env-config.js
for line in $envs
do
    if [[ $line == *"WEB_"* ]]; then
        if printf '%s\n' "$line" | grep -q -e '='; then
            varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
            echo $varname
            varname=$(printf '%s\n' "$varname" | sed 's/WEB_//')
            echo $varname
            varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
            echo "  $varname: \"$varvalue\"," >> ./env-config.js
        fi
    fi
done
echo "}" >> ./env-config.js
config=$(cat ./env-config.js)
config=$(printf '%s\n' "$config" | sed -e 's/[]:"\/$*.~^[]/\\&/g');
config=$(printf '%s\n' "$config" | sed ':a;N;$!ba;s/\n/ /g');
sed -r -i -e 's|<script type="text/javascript" id="env-vars">(.*)</script>|<script type="text/javascript" id="env-vars">'"${config}"'</script>|g' $HTML_TEMPLATE
rm -rf ./env-config.js

exec "$@"