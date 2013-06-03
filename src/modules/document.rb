class Document
  
  def initialize
    @buffer = 'document'
  end
    
  def body
    
    @buffer += '.body'
    
    self
    
  end
  
  def append_child node
    
    @buffer += ".appendChild(#{node})"
    
    `eval(#{@buffer});`
    
  end
  
end

def create_text_node text
  "document.createTextNode('#{text}')"
end

def document
  Document.new
end
