require 'net/http'
require 'fileutils'
require 'open-uri'
require 'json'

num = ENV['num'].to_i
list = {items: []}
work_dir = Dir.pwd
FileUtils.rm_rf Dir.glob("#{work_dir}/cache/*")

1.upto(num) do |i|
  json = JSON.parse(Net::HTTP.get URI.parse("http://takashicompany.com/api/lgtm/"))
  id = json['lgtm_image'].split('/').last(2).join("_")
  File.open("cache/#{id}", 'wb') do |file|
    open(json['lgtm_image'], 'rb') do |image|
      file.write(image.read)
    end
  end

  item = {
    type: "file:skipcheck",
    title: id,
    subtitle: json['lgtm_image'],
    arg: "#{work_dir}/cache/#{id}",
    icon: { path:"cache/#{id}" }
  }
  list[:items].push item
end

print list.to_json
