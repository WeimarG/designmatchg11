CarrierWave.configure do |config|
 config.fog_credentials = { provider: 'AWS', aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'], aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], region: 'us-east-2'}
    if Rails.env.test? || Rails.env.cucumber?
        config.storage           = :file
        config.enable_processing = false
        config.root              = "#{Rails.root}/tmp"
    else
        config.storage = :fog        
    end

    config.asset_host = "http://d33ipb1vzn24gg.cloudfront.net"
    config.cache_dir        = "#{Rails.root}/tmp/upload"
    config.fog_directory    = ENV['S3_BUCKET']
    end
module Carrierwave
    module MiniMagick
        def quality(percentage)
            manipulate! do |img|
                img.quality(percentage.to_s)
                img = yield(img) if block_given?
                img
            end
        end
    end
end
