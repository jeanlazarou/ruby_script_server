require 'opal'

class OpalAdapter

  def initialize context
    @context = context
    @parser = Opal::Parser.new
  end
  
  def compile ruby_file
  
    if @context.must_compile?(ruby_file)
      
      parse_and_write ruby_file

    else
    
      compile_known_dependencies ruby_file
      
    end    
    
  end
  
  def parse_and_write ruby_file
  
    source_file = @context.source_path(ruby_file)
    compiled_file = @context.compile_path(ruby_file)
    
    open(compiled_file, "w") do |stream|

      stream.puts @parser.parse(File.read(source_file))
      
    end
    
    @context.compiled_files << compiled_file

    required_files = @parser.requires
    
    compile_dependencies required_files

    save_dependencies ruby_file, required_files

  end

  def compile_dependencies required_files
  
    required_files.each do |name|
    
      source = "#{name}.rb"
      
      self.compile source
      
    end
    
  end

  def save_dependencies ruby_script, required_files
  
    open(@context.dependency_path(ruby_script), 'w') do |out|
      
      required_files.each do |name|
        out.puts name
      end
      
    end
    
  end

  def compile_known_dependencies ruby_script
  
    required_files = load_dependencies(ruby_script)
    
    return if required_files.empty?
    
    compile_dependencies required_files
    
  end
  
  def load_dependencies ruby_script
  
    dep_file = @context.dependency_path(ruby_script)
    
    return [] unless File.exist?(dep_file)
    
    open(dep_file).readlines.map {|file| file.chomp }
    
  end
  
end
