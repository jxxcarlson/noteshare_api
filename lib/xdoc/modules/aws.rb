
### INTERFACE ###
# AWS.upload
# AWS.put_string
# AWS.get_string
module AWS
  require 'aws-sdk'

  ### INTERFACE ###

  def self.upload(file_name, tmpfile, folder='tmp')

    bucket = "vschool"

    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
        region: 'us-west-1',
        endpoint: 'https://s3.amazonaws.com'
    )

    base_name = File.basename(file_name)

    obj = s3.bucket(bucket).object("#{folder}/#{base_name}")
    obj.upload_file(tmpfile, acl: 'public-read')

    return obj.public_url

  end


  # create file on S3 from string str\
  # http://docs.aws.amazon.com/AmazonS3/latest/dev/UploadObjSingleOpRuby.html
  def self.put_string(str, object_name, folder='tmp')

    bucket = "psurl"
    object_name = "#{folder}/#{object_name}"
    # mime_type = "application/octet-stream"

    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
        region: 'us-west-1',
        endpoint: 'https://s3.amazonaws.com'
    )

    obj = s3.bucket(bucket).object(object_name)

    obj.put(body: str,  acl: 'public-read')

  end

  # read file on S3 and return it as a string
  # https://ruby.awsblog.com/post/Tx354Y6VTZ421PJ/Downloading-Objects-from-Amazon-S3-using-the-AWS-SDK-for-Ruby
  def self.get_string(object_name, folder='tmp')

    bucket = "psurl"
    object_name = "#{folder}/#{object_name}"
    # mime_type = "application/octet-stream"

    s3 = Aws::S3::Client.new(
        credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
        region: 'us-west-1',
        endpoint: 'https://s3.amazonaws.com'
    )


    resp = s3.get_object(bucket: bucket, key: object_name)

    resp.body.read

  end

end