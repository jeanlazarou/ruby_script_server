require 'rack'
require 'client_side_ruby_middleware'

require 'opal_adapter'

ClientSideRubyMiddleware.adapter_class = OpalAdapter

class RubyScriptServer

  def initialize public_dir, src_dir
    @web_app = create_app(public_dir, src_dir)
  end
  
  def call env
    @web_app.call env
  end

  private
  
  def create_app public_dir, src_dir

    Rack::Builder.new do

      Dir["#{src_dir}/*.rb"].each do |ruby_file|

        name = File.basename(ruby_file)

        name =~ /(.*)\.rb$/

        map "/#{$1}" do
        
          use ClientSideRubyMiddleware, src_dir, name, public_dir

        end
        
      end
      
      run Rack::File.new(public_dir)

    end.to_app

  end

end
