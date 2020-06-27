creds = Aws::Credentials.new(
  Rails.application.credentials.aws[:ses_access_key_id],
  Rails.application.credentials.aws[:ses_secret_access_key]
)
Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, credentials: creds, region: 'us-east-1')