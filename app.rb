# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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