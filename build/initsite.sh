docker exec -it api rails runner -e production "s=Site.create_site!('$1','$2');Form.contactus!(s)"
