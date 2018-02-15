
docker exec -it mysql mysql -p -e 'create database cms;create database cms_test;'
docker exec -i cmsapi rails db:schema:load
#cat db/structure.sql | docker exec -i mysql mysql -p123456 -u root -D cms
