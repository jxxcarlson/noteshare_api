echo
curl  -H "Content-Type: application/json" -X POST -d '{"url": "http://yuukluck.foo.io/bar.jpg", "content_type": "image/jpeg", "title": "Mountain X"}' http://localhost:2300/v1/images
echo
echo