# Docker_web
An image created with multiple process running on different doors and connecting to a external database, the base of image is a latest Ubuntu downloaded from the Docker repository, including in the image we have the process manager PM2 where we mapped all the instances to easily maintain and cover all the process.

Default commands:

  Build Image:
    docker build -t dockerfile .\
    
  Create a Container:
    docker container run --name instance_web -dp 3000:3000 -p 3001:3001 -p 3002:3002 -p 1433:1433 dockerfile
    
  Start Shell:
    docker container exec -it psga_web /bin/bash
