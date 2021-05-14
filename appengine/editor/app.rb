# [START app]
require "sinatra"


get "/" do
  send_file File.expand_path('index.html', settings.public_folder)
end

# App Engine uses the health check to ensure that the instance is healthy
# and ready to serve traffic.
get "/_ah/health" do
  "ok"
end
# [END app]
