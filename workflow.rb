require 'net/http'
require 'fileutils'
require 'open-uri'
require 'json'

list = {items: []}
work_dir = Dir.pwd
FileUtils.rm_rf Dir.glob("#{work_dir}/img/*")

1.upto(3) do |i|
  id = Net::HTTP.get_response('lgtm.in', '/g')['location'].split('/').last
  uri = URI.parse("https://lgtm.in/i/#{id}")
  req = Net::HTTP::Get.new(uri)
  req['Accept'] = 'application/json'
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  json = JSON.parse(http.request(req).body)
  suffix = json['actualImageUrl'].include?(".gif")? "gif" : "jpg"

  File.open("img/#{id}.#{suffix}", 'wb') do |file|
    open(json['actualImageUrl'], 'rb') do |image|
      file.write(image.read)
    end
  end

  item = {
    type: "file:skipcheck",
    title: "#{id}.#{suffix}",
    subtitle: "Likes: #{json['likes']}, Dislikes:#{json['dislikes']}",
    arg: "#{work_dir}/img/#{id}.#{suffix}",
    icon: { path:"img/#{id}.#{suffix}" }
  }
  list[:items].push item
end

