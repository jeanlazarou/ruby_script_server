class CompileContext

  attr_reader :compiled_files

  def initialize public_dir, source_dir
    
    @public_dir = public_dir
    @source_dir = source_dir

    @compiled_files = []
    
  end
  
  def source_path ruby_file
    "#{@source_dir}/#{ruby_file}"
  end
  
  def compile_path ruby_file
    
    path = "#{compile_directory}/#{ruby_file}.js"
    
    dir = File.dirname(path)
    
    FileUtils.makedirs(dir) unless File.directory?(dir)
    
    path
    
  end

  def compile_directory
    "#{@public_dir}/cjs"
  end
  
  def must_compile? ruby_file

    source = source_path(ruby_file)
    compiled = compile_path(ruby_file)
    
    !File.exist?(compiled) || File.stat(compiled).mtime < File.stat(source).mtime
    
  end

  def dependency_path ruby_script
    
    dep_dir = File.join(@source_dir, File.dirname(ruby_script), '.dep')
    
    Dir.mkdir dep_dir unless File.directory?(dep_dir)
    
    File.join(dep_dir, "#{File.basename(ruby_script)}.dep")
    
  end

end
