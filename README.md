# INT_DB

docker run -d -p 27017:27017 --name mongodb mongo:test
or
docker run -d -p 27017:27017 --name mongodb mongo

docker inspect mongodb
echo $?
