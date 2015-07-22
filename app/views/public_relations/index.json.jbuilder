json.array!(@public_relations) do |public_relation|
  json.extract! public_relation, :id
  json.url public_relation_url(public_relation, format: :json)
end
