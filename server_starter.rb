require 'ruby_script_server'

server = Rack::Builder.new do

  use Rack::ContentType
  use Rack::ShowExceptions

  run RubyScriptServer.new('public', 'src')
  
end

Rack::Server.start :app => server, :Port => 3000
