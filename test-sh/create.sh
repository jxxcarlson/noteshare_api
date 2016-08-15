echo
curl  -H "Content-Type: application/json" -X POST -d '{"identifier":"foo_1","owner_id":55,"collection_id":66,"title":"Intro to quantum mechanics","viewed_at":"2016-07-15T15:42:17Z","visit_count":2,"text":"foo123","rendered_text":"foobar","public":true,"dict":{"favorite_flavor":"vanilla"},"links":{"documents":[{"id":10,"title":"EM"},{"id":20,"title":"Bio"}],"resources":[{"id":100,"type":"image"},{"id":200,"title":"Bio","type":"PDF"}]},"tags":["physics","quantum"],"kind":"asciidoc"}' http://localhost:2300/v1/documents
echo
echo