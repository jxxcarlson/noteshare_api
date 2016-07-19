echo
curl -H "Content-Type: application/json"  -X POST -d '{"username": "joe", "password": "foobar1234", "password_confirmation": "foobar1234", "email": "joe@foo.io"}'  http://localhost:2300/v1/users/create
echo
echo
