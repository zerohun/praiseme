json.array!(@user_stamps) do |user_stamp|
  json.extract! user_stamp, :stamp_id, :user_id, :score, :level
  json.url user_stamp_url(user_stamp, format: :json)
end