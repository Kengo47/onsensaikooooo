require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_provider = 'fog/aws'
  config.fog_directory  = Rails.application.credentials.aws[:fog_directory]
  config.asset_host = Rails.application.credentials.aws[:asset_host]
  config.fog_public = true
  config.fog_attributes = {cache_control: 'max-age=31536000', expires: 1.year.from_now.httpdate}
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
    aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
    region: Rails.application.credentials.aws[:fog_region]
  }
end