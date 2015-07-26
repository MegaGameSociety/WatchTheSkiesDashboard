json.array!(@news_messages) do |news_message|
  json.extract! news_message, :id
  json.url news_message_url(news_message, format: :json)
end
