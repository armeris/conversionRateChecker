require 'rest_client'
require 'json'
require 'mongo'

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'conversionRates')

response_eur_jpy = RestClient.get 'http://api.fixer.io/latest', :params => {:base => 'EUR', :symbols => 'JPY'}
eur_jpy_rate = 0.0

if (response_eur_jpy)
  eur_jpy_rate = JSON.parse(response_eur_jpy)['rates']['JPY']
end

document = {:_id => BSON::ObjectId.new, :origin => :EUR, :destination => :JPY, :rate => (eur_jpy_rate ? (1 / eur_jpy_rate) : eur_jpy_rate), :date => Time.now}

client[:conversionRates].insert_one document

client.close
