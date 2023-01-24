# psga_web
Container file to create a full operational ubuntu with PSGA services using pm2 to manage all the instances.
docker container run --name psga_web -dp 3000:3000 -p 3001:3001 -p 1433:1433 dockerfile 
