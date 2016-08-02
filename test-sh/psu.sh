echo
curl -H "Content-Type: application/json"  -X POST -d '{ "file": "foo.txt", "content_type": "text/plain" }' http://localhost:2300/v1/presigned
echo
echo
