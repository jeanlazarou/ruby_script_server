require 'compile_context'

class ClientSideRubyMiddleware

  def initialize app, src_dir, ruby_file, public_dir
    @src_dir = src_dir
    @ruby_file = ruby_file
    @public_dir = public_dir
  end
  
  def call env
  
    compile_script
    
    [200, {'content-type' => 'text/javascript'}, @content]
    
  end  

  # set the default adapter for the actual compiler to Javascript
  #
  # the adapter contract:
  #  - constructor should expect one argument, a CompileContext object
  #  - the class should respond to 'compile'
  #  - 'compile' takes one argument, the script to compile
  #  - the class should respond to 'load_dependencies'
  #  - 'load_dependencies' takes one argument, a script, and returns
  #    the required scripts
  # 
  def self.adapter_class= adapter_class
    @@adapter_class = adapter_class
  end

  def compile_script

    @context = CompileContext.new(@public_dir, @src_dir)
    
    @compiler = @@adapter_class.new(@context)
    
    @compiler.compile @ruby_file
    
    @content = []
    
    merge_compiled_files @ruby_file
    
  end
  
  def merge_compiled_files ruby_file

    files = @compiler.load_dependencies(ruby_file)
    
    files.each do |path|
    
      file = "#{path}.rb"
      
      merge_compiled_files file
      
    end
    
    @content += open(@context.compile_path(ruby_file)).readlines
    
  end
  
end
