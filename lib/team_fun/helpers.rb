module ::TeamFun::Helpers
  def form_for(object, options = {}, &block)
    if options[:method] and options[:method].to_s != 'get'
      method, options[:method] = options[:method], 'post'
    end
    if method.blank? or options[:action].blank?
      unless object.new_record?
        method ||= 'put'
        options[:action] ||= uri_for(object)
      else
        options[:action] ||= "/#{object.class.name.pluralize.underscore}"
      end
    end
        
    form =  "<form method='#{options.delete(:method)||'post'}'#{options_to_attributes(options)}>\n"
    form << haml_indent << "  <input type='hidden' name='_method' value='#{method}' />\n" if method
    block = capture_haml(::TeamFun::FormBuilder.new(options, object, self), &block)
    block.each_line do |line|
      form << haml_indent + '  ' + line
    end
    form + "</form>"
  end
  
  def link_to(location, text = nil, options = {})
    "<a href='#{uri_for(location)}'#{options_to_attributes(options)}>#{text||location.to_s}</a>"
  end
  
  def uri_for(object)
    return object.to_uri if object.respond_to?(:to_uri)
    return object.to_s if object.kind_of? String
    "/#{object.class.name.pluralize.underscore}/#{object.id}"
  end
  
  def redirect_to(object)
    redirect uri_for(object)
  end
  
  def options_to_attributes(options)
    options.inject('') { |str, hash| str << " #{hash[0].to_s}='#{hash[1].to_s}'" }
  end
  
  def script_tag(location)
    "<script type='text/javascript' src='#{location}'></script>"
  end
  
  def render_partial(sym)
    haml sym, :layout => false
  end
end