# INT_DB

docker run -d -p 27017:27017 --name mongodb mongo:test
or
docker run -d -p 27017:27017 --name mongodb mongo

#Verify database connection
docker inspect mongodb
