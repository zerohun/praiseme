json.array!(@compliments) do |compliment|
  json.extract! compliment, :sender_id_id, :receiver_id_id, :stamp_id, :description
  json.url compliment_url(compliment, format: :json)
end