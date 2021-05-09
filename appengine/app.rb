# [START app]
require "sinatra"


get "/" do
  send_file File.expand_path('index.html', settings.public_folder)
end

get "/schema" do
  content_type :json

  # Temporary hardcoded JSON string representing an RzWebsiteSchema
  # proto message
  return <<EOF
{
    "1": [
        {
            "1": "Potions",
            "2": "assets/potion_gallery.jpg",
            "3": "assets/potion.jpg"
        },
        {
            "1": "Mushroom",
            "2": "assets/mushroom_gallery.jpg",
            "3": "assets/mushroom.jpg"
        },
        {
            "1": "Stump",
            "2": "assets/stump_gallery.jpg",
            "3": "assets/stump.jpg"
        },
        {
            "1": "Kirby Pancakes",
            "2": "assets/kirby_pancakes_gallery.jpg",
            "3": "assets/kirby_pancakes.jpg"
        },
        {
            "1": "Pika Fruit",
            "2": "assets/pika_fruit_gallery.jpg",
            "3": "assets/pika_fruit.jpg"
        },
        {
            "1": "Girl",
            "2": "assets/tennis_player_gallery.jpg",
            "3": "assets/tennis_player.jpg"
        },
        {
            "1": "Chuck",
            "2": "assets/chuck_gallery.jpg",
            "3": "assets/chuck.jpg"
        }
    ],
    "2": [
        {
            "1": "Link Charm",
            "2": "assets/link_charm_gallery.jpg",
            "3": "assets/link_charm.jpg"
        },
        {
            "1": "Wooden Charm",
            "2": "assets/milk_coffee_charm_gallery.jpg",
            "3": "assets/milk_coffee_charm.jpg"
        },
        {
            "1": "Froggy Shirt",
            "2": "assets/froggy_shirt_gallery.jpg",
            "3": "assets/froggy_shirt.jpg"
        },
        {
            "1": "Froggy Sweater",
            "2": "assets/froggy_sweater_gallery.jpg",
            "3": "assets/froggy_sweater.jpg"
        }
    ]
}
EOF
end

# App Engine uses the health check to ensure that the instance is healthy
# and ready to serve traffic.
get "/_ah/health" do
  "ok"
end
# [END app]
