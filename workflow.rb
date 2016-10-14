require 'net/http'
require 'json'

list = {items: []}

1.upto(3) do |i|
  res = Net::HTTP.get_response 'lgtm.in', '/g'
  id = res['location'].split('/').last
  pic_res = Net::HTTP.get_response URI.parse("https://lgtm.in/p/#{id}")
  pic_url = pic_res['location']
  item = {
    title: id,
    subtitle: res['location'],
    arg: id,
    quicklookurl: pic_url
  }
  list[:items].push item
end

print list.to_json
