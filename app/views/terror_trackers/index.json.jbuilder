json.array!(@terror_trackers) do |terror_tracker|
  json.extract! terror_tracker, :id
  json.url terror_tracker_url(terror_tracker, format: :json)
end
