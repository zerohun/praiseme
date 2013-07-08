config = YAML.load(File.read(File.expand_path("#{Rails.root}/config/sns_infos.yml", __FILE__)))
$fb_app_id = config[Rails.env]["fb_app_id"]
$fb_app_secret = config[Rails.env]["fb_app_secret"]
$fb_namespace = config[Rails.env]["fb_namespace"]

