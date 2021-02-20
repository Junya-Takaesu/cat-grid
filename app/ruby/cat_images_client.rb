class CatImagesClient
  require "net/http"
  require "uri"
  require "json"

  attr_reader :images, :parsed_json

  BASE_URL = "https://api.thecatapi.com/v1/"
  PATH_IMAGES_SEARCH = "images/search"
  PATH_IMAGES_UPLOAD = "images/upload"
  X_API_KEY = ENV["CAT_IMAGES_X_API_KEY"]

  def initialize
    @images
  end

  def request(endpoint: "", query_params: {})
    return if endpoint.empty?

    @endpoint = trim_request_path(endpoint)
    @query_params = concat_query_params(query_params)

    case @endpoint
    when PATH_IMAGES_SEARCH
      @parsed_json = JSON.parse(image_search)
      @images = extract_urls
    when PATH_IMAGES_UPLOAD
      # Do upload here...
    end
  end

  private
    def trim_request_path(path)
      path = path.gsub(/^\//, "")
      path = path.gsub(/\/$/, "")
    end

    def concat_query_params(query_params)
      concat = ""
      query_params.each do |key, value|
        concat += "#{key}=#{value}&"
      end
      concat = concat.gsub(/&$/, "")
    end

    def image_search
      url = URI(BASE_URL+PATH_IMAGES_SEARCH)
      url += "?#{@query_params}" unless @query_params.empty?
      Net::HTTP.get(url)
    end

    def extract_urls
      urls = []
      @parsed_json.each do |hash|
        urls.push hash["url"]
      end
      urls
    end
end

if $0 == __FILE__
  cat_images_api = CatImagesApi.new

  query_params = {
    size: "small",
    limit: 10
  }

  cat_images_api.request(endpoint: "/images/search", query_params: query_params)
  pp cat_images_api.images
end

