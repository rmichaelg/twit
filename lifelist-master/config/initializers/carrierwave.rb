CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAIEKXAGGIFA6IF6EA',                        # required
    :aws_secret_access_key  => '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',                        # required
    :region                 => 'us-west-2'                   # optional, defaults to 'us-east-1'
#    :hosts                  => 's3-us-west-1.amazonaws.com'              # optional, defaults to nil
#    :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = "lifelist-#{Rails.env}"                     # required
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end