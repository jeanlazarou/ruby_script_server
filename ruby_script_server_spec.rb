require 'ruby_script_server'

require 'rack/mock'

describe RubyScriptServer do

  before do
    @app = RubyScriptServer.new('public', 'src')
  end

  after do
    FileUtils.rmtree 'public/cjs'
  end
  
  it "registers script names as path" do
    Rack::MockRequest.new(@app).get("/hello").status.should.equal 200
  end

  it "creates the compile directory in the public directory" do
    
    File.directory?('public/cjs').should.be.false
    
    Rack::MockRequest.new(@app).get("/hello")
    
    File.directory?('public/cjs').should.be.true
    
  end
  
  it "compiles the scripts" do
    
    File.file?('public/cjs/hello.rb.js').should.be.false
    
    Rack::MockRequest.new(@app).get("/hello")
    
    File.file?('public/cjs/hello.rb.js').should.be.true
    
  end

  it "sends back the compiled javascript" do
  
    response = Rack::MockRequest.new(@app).get("/hello")
    
    response.body.should.equal open("public/cjs/hello.rb.js").readlines.join
    
  end

  it "sends back the compiled script and the dependent javascripts" do
  
    response = Rack::MockRequest.new(@app).get("/script_2")
    
    expected = open("public/cjs/modules/script_1_dep.rb.js").readlines.join
    expected << open("public/cjs/script_1.rb.js").readlines.join
    expected << open("public/cjs/script_2.rb.js").readlines.join
    
    response.body.should.equal expected
    
  end

end
