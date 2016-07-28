echo
curl -H "Content-Type: application/json"  -X POST -d '{ "filename": "foo.txt", "type": "text/plain" }' http://localhost:2300/v1/presigned
echo
echo
