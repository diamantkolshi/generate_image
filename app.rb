require "bundler/setup"
require "sinatra"
require "sinatra/config_file"
require "rack/csrf"
require "ruote"
require "json"
require "sinatra/reloader" if development?
require "./lib/book"
require "pry"

# Load application configuration from YAML file.
config_file "./config.yml"

Dir.glob(File.join("lib/book", "**", "*.rb")).each do |klass|
  require_relative klass
end

get '/' do
  erb :index  
end

post '/upload' do

  filename = params[:file][:filename]
  tempfile = params[:file][:tempfile]
  target = "public/img/#{filename}"

  File.open(target, 'wb') {|f| f.write tempfile.read }
  var = Image.new
  var.create_image(params[:name], params[:text], filename)
  @messages = var.messages
  
  erb :upload
end
