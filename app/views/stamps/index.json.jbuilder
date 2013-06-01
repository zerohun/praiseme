json.array!(@stamps) do |stamp|
  json.extract! stamp, :title, :description, :used_count, :is_blocked
  json.url stamp_url(stamp, format: :json)
end
