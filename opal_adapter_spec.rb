require 'opal_adapter'
require 'compile_context'

class SpecContext < CompileContext

  def must_compile? ruby_file
  
    if @touched_files and @touched_files.include?(ruby_file)
      true
    else
      super
    end
  
  end
  
  def touch ruby_file
    @touched_files = [] unless @touched_files
    @touched_files << ruby_file
  end
  
end

describe OpalAdapter do

  before do
    @context = SpecContext.new('public', 'src')
    @compiler = OpalAdapter.new(@context)
  end
  
  after do
    FileUtils.rmtree 'public/cjs'
  end
  
  it "creates the compile directory in the public directory" do
    
    File.directory?('public/cjs').should.be.false
    
    @compiler.compile "hello.rb"
    
    File.directory?('public/cjs').should.be.true
    
  end
  
  it "compiles scripts" do
    
    File.file?('public/cjs/hello.rb.js').should.be.false
    
    @compiler.compile "hello.rb"
    
    File.file?('public/cjs/hello.rb.js').should.be.true
    
  end  
  
  it "compiles scripts only once" do
    
    @context.compiled_files.should.be.empty?
    
    @compiler.compile "hello.rb"
    @compiler.compile "hello.rb"
    
    @context.compiled_files.should.equal ['public/cjs/hello.rb.js']
    
  end  

  it "compiles the scripts when source changes" do
        
    @compiler.compile "hello.rb"
    
    @context.touch "hello.rb"
    
    @compiler.compile "hello.rb"
    
    @context.compiled_files.should.equal ['public/cjs/hello.rb.js'] * 2
    
  end

  it "compiles the explict required scripts" do
    
    File.file?('public/cjs/modules/script_1_dep.rb.js').should.be.false
    
    @compiler.compile "script_1.rb"
    
    File.file?('public/cjs/modules/script_1_dep.rb.js').should.be.true
    
  end

  it "compiles the explict required scripts only once" do
    
    @compiler.compile "script_1.rb"
    @compiler.compile "script_1.rb"
    
    @context.compiled_files.should.equal ['public/cjs/script_1.rb.js', 
                                          'public/cjs/modules/script_1_dep.rb.js']
    
  end

  it "compiles the explict required scripts when source changes" do
    
    @compiler.compile "script_1.rb"
    
    @context.touch "modules/script_1_dep.rb"
    
    @compiler.compile "script_1.rb"
    
    @context.compiled_files.should.equal ['public/cjs/script_1.rb.js', 
                                          'public/cjs/modules/script_1_dep.rb.js',
                                          'public/cjs/modules/script_1_dep.rb.js']
    
  end

  it "compiles the indirect required scripts" do
    
    File.file?('public/cjs/script_2.rb.js').should.be.false
    File.file?('public/cjs/script_1.rb.js').should.be.false
    File.file?('public/cjs/modules/script_1_dep.rb.js').should.be.false
    
    @compiler.compile "script_2.rb"
    
    File.file?('public/cjs/script_2.rb.js').should.be.true
    File.file?('public/cjs/script_1.rb.js').should.be.true
    File.file?('public/cjs/modules/script_1_dep.rb.js').should.be.true
    
  end

  it "compiles the indirect required scripts only once" do

    @compiler.compile "script_2.rb"
    @compiler.compile "script_2.rb"
    
    @context.compiled_files.should.equal ['public/cjs/script_2.rb.js', 
                                          'public/cjs/script_1.rb.js',
                                          'public/cjs/modules/script_1_dep.rb.js']
                                          
  end

  it "compiles the indirect required scripts when source changes" do
    
    @compiler.compile "script_2.rb"
    
    @context.touch "modules/script_1_dep.rb"
    
    @compiler.compile "script_2.rb"
    
    @context.compiled_files.should.equal ['public/cjs/script_2.rb.js',
                                          'public/cjs/script_1.rb.js',
                                          'public/cjs/modules/script_1_dep.rb.js',
                                          'public/cjs/modules/script_1_dep.rb.js']
    
  end

end
