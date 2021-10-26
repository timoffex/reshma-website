# [START app]
require "sinatra"
require "google/cloud/storage"


class SchemaService
  def initialize
    storage = Google::Cloud::Storage.new
    @dev_bucket = storage.bucket "reshma-website-dev"
    @last_read_time = Time.now
    @last_schema = nil
  end

  def get_schema
    # Refresh schema at most once every minute
    if @last_schema.nil? || Time.now > @last_read_time + 60
      puts "Updating schema"
      schema_file = @dev_bucket.file("schema.json").download
      schema_file.rewind
      @last_schema = schema_file.read
    end

    @last_schema
  end

  def put_schema(schema_json)
    @last_schema = schema_json

    data = StringIO.new schema_json
    @dev_bucket.create_file data, "schema.json"
  end
end

schema_service = SchemaService.new


# TODO: Require credentials

get "/" do
  send_file File.expand_path('index.html', settings.public_folder)
end

get "/schema" do
  content_type :json
  schema_service.get_schema
end

put "/schema" do
  request.body.rewind
  schema_json = request.body.read
  schema_service.put_schema schema_json
  status 200
end

# App Engine uses the health check to ensure that the instance is healthy
# and ready to serve traffic.
get "/_ah/health" do
  "ok"
end
# [END app]
