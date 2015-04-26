require 'openssl'

class AwsPolicyDocumentRepository < BaseRepository
  DEFAULT_MAX_UPLOAD = 12582912
  DEFAULT_UPLOAD_PATH = "uploads/"
  
  def self.upload_policy
    Base64.encode64(
      {
        expiration: 30.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        conditions: [
          { bucket: CONFIG[:s3_bucket] },
          { acl: 'public-read' },
          ["starts-with", "$key", DEFAULT_UPLOAD_PATH],
          ["content-length-range", 0, DEFAULT_MAX_UPLOAD],
          { success_action_status: '201' }
        ]
      }.to_json
    ).gsub(/\n|\r/, '')
  end
  
  def self.upload_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        CONFIG[:aws_secret_key_id],
        self.upload_policy
      )
    ).gsub(/\n/, '')
  end
end