
docker exec -it db mysql -p -e 'create database cms;'
cat db/structure.sql | docker exec -i db mysql -p123456 -u root -D cms
