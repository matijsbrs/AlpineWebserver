# DockerFiler
A make script used to build, tag and publish containers

# Disclosure
Years ago I ran into the Makefile this project is based on, I've tried to find the 
original author. But with no succes. If you are the original author please let me know. 

# Summary
Creating, building and maintaining docker containers is tideous and pretty much the
same every time. Automation is key here ;-)
I almost always use Alpine linux as a base. So that is what's included. 

## STEPS:
1. clone the repository
2. Add your program to the app directory
3. Add extra packages in the Dockerfile
4. Change the entrypoint.sh to start your app
5. run `make build` This will build your container
6. run `make run` This will start the container
7. run `make publish` if you want to publish it to a repository
8. run `make buildinc build` if you run local and want to auto increase the build count

## More
If you just run make, all commands will be shown. 

Check the files: 
- config.env
- deploy.env
- Dockerfile
- entrypoint.sh

## Git
You can change the url using: 
`git remote set-url origin new.git.url/here`



The are to some extent documented. 

Happy coding.
Matijs
