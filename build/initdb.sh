
docker exec -it mysql mysql -p -e 'create database cms;'
cat db/structure.sql | docker exec -i mysql mysql -p123456 -u root -D cms
