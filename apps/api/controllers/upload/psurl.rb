require 'aws-sdk'

# http://docs.aws.amazon.com/sdkforruby/api/index.html
# http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Bucket.html

=begin
#Uploading an object using a pre-signed URL for SDK for Ruby - Version 2.

require 'aws-sdk-resources'
require 'net/http'

s3 = Aws::S3::Resource.new(region:'us-west-2')

obj = s3.bucket('BucketName').object('KeyName')
# Replace BucketName with the name of your bucket.
# Replace KeyName with the name of the object you are creating or replacing.

url = URI.parse(obj.presigned_url(:put))

body = "Hello World!"
# This is the contents of your object. In this case, it's a simple string.

Net::HTTP.start(url.host) do |http|
  http.send_request("PUT", url.request_uri, body, {
# This is required, or Net::HTTP will add a default unsigned content-type.
    "content-type" => "",
  })
end

puts obj.get.body.read
# This will print out the contents of your object to the terminal window.
=end

module Api::Controllers::Upload
  class Psurl
    include Api::Action

    def presigned(params)
      if params[:filename] && params[:type]

        bucket = "psurl"

        s3 = Aws::S3::Resource.new(
            credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
            region: 'us-standard',
            endpoint: 'https://s3.amazonaws.com'
        )

        obj = s3.bucket(bucket).object(params[:filename])
        # url = URI.parse(obj.presigned_url(:put))
        url = URI.parse(obj.presigned_url(:put, :content_type => params[:type], :expires => 10*60))
        puts "================================"
        puts "url: #{url.to_s}"
        puts "================================"
        {:url => url.to_s}.to_json
      else
        {:error => 'Invalid Params'}.to_json
      end
    end

    def call(params)
      puts "params[:filename]: #{params[:filename]}"
      puts "params[:type]: #{params[:type]}"
      self.body = presigned(params)
    end
  end
end
