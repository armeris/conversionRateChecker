require 'rest_client'
require 'json'
require 'mongo'

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'conversionRates')

response_jpy = RestClient.get 'https://blockchain.info/tobtc', :params => {:currency => :JPY, :value => '1'}
response_eur = RestClient.get 'https://blockchain.info/tobtc', :params => {:currency => :BTC, :value => '1'}

document = {:_id => BSON::ObjectId.new, :origin => :BTC, :destination => :JPY, :rate => response_jpy, :date => Time.now}

client[:conversionRates].insert_one document

document = {:_id => BSON::ObjectId.new, :origin => :BTC, :destination => :EUR, :rate => response_eur, :date => Time.now}

client[:conversionRates].insert_one document

client.close