require "sinatra"
require "sinatra/reloader"
require_relative "./app/ruby/cat_images_client.rb"

get "/" do
  cat_client = CatImagesClient.new

  query_params = {size: "small",limit: 8}

  cat_client.request(endpoint: "/images/search", query_params: query_params)
  @image_urls = cat_client.images
  erb :index
end
