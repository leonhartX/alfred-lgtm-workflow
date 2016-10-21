require 'net/http'
require 'fileutils'
require 'open-uri'
require 'json'

list = {items: []}
work_dir = Dir.pwd
FileUtils.rm_rf Dir.glob("#{work_dir}/cache/*")

1.upto(3) do |i|
  json = JSON.parse(Net::HTTP.get URI.parse("http://takashicompany.com/api/lgtm/"))
  id = json['lgtm_image'].split('view/')[1].gsub(/\//, "_")
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
