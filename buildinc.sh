
cp deploy.env deploy.tmp
awk -F '=' '/APP_BUILD/{$2=$2+1}1' OFS='=' deploy.tmp > deploy.env

rm deploy.tmp