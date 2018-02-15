docker exec -it cmsapi rails runner -e production "s=Site.create_site!('$1','$2');Form.contactus!(s);Structure.create(site: Site.first, name: 'tour')"
