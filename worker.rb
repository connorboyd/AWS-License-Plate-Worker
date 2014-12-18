require 'aws-sdk'
require 'pry'

bucket_name = 'cobo6449-images'
AWS.config(
  :access_key_id => '',
  :secret_access_key => '')

s3  = AWS::S3.new
sqs = AWS::SQS.new

queue = sqs.queues.create("alpr-work-queue")

queue.poll do |msg|
  key = msg.body
  filename = "/tmp/images/#{key}.jpg"
  File.open(filename, 'wb') do |file|
    s3.buckets[bucket_name].objects[key].read do |chunk|
      file.write(chunk)
    end
  end
  alpr_results = `alpr #{filename}`
  puts alpr_results
end
