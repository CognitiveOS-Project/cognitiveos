rm -Rf /Users/jeanmachuca/.code-inference    
rm -Rf .opencode/node_modules 
rm .opencode/package.json
rm .opencode/package-lock.json
rm .git/opencode
curl -sS https://raw.githubusercontent.com/jeanmachuca/code-inference/main/install.sh | sh      
docker compose -f  /Users/jeanmachuca/.code-inference/docker-compose.yml --profile stack down