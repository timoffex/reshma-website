# [START app]
require "sinatra"
require "google/cloud/storage"


class SchemaGetter
  def initialize
    storage = Google::Cloud::Storage.new
    @bucket = storage.bucket "reshma-website.appspot.com"
    @last_read_time = Time.now
    @last_schema = nil
  end

  def get_schema
    # Refresh schema at most once every minute
    if @last_schema.nil? || Time.now > @last_read_time + 60
      puts "Updating schema"
      schema_file = @bucket.file("schema.json").download
      schema_file.rewind
      @last_schema = schema_file.read
    end

    @last_schema
  end
end

schema_getter = SchemaGetter.new



get "/" do
  send_file File.expand_path('index.html', settings.public_folder)
end

get "/schema" do
  content_type :json
  schema_getter.get_schema
end

# App Engine uses the health check to ensure that the instance is healthy
# and ready to serve traffic.
get "/_ah/health" do
  "ok"
end
# [END app]
