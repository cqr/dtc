class ::TeamFun::FormBuilder

  attr_reader :template, :options, :object

  def initialize(options, object, template)
    @options, @object, @template = options, object, template
  end

  [:text, :email, :password].each do |name|
    define_method name.to_s + '_field' do |field|
      input name, field
    end
  end

  def textarea(field)
    "<textarea id='#{obj_id}_#{field.to_s}'" +\
    "#{class_with_errors(field)} name='#{input_name(field)}'>"+\
    "#{template.preserve object.send(field).to_s}</textarea>"
  end

  def input(type, field)
    "<input id='#{obj_id}_#{field.to_s}'" +\
    "#{class_with_errors(field)} name='#{input_name(field)}'"+\
    " value='#{object.send(field).to_s}' type='#{type}' />"
  end

  def submit_button(text=nil)
    "<button type='submit'>#{text||save_text}</button>"
  end

  def label(field, text=nil)
    "<label for='#{obj_id}_#{field.to_s}'#{class_with_errors(field)}>#{text||field.to_s.humanize}</label>"
  end

  private

  def class_with_errors(field)
    " class='error'" if object.errors[field]
  end

  def obj_id
    @obj_id ||= "#{object_name}#{'_'+object.id.to_s unless object.new_record?}"
  end

  def object_name
    @object_name ||= object.class.name.underscore
  end

  def input_name(field)
    object_name+"[#{field.to_s}]"
  end

  def save_text
    object.new_record? ? 'Create' : 'Update'
  end

end