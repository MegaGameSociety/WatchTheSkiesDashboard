json.array!(@incomes) do |income|
  json.extract! income, :id
  json.url income_url(income, format: :json)
end
