# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def block_to_partial(partial_name, options = {}, &block)
    options.reverse_merge!(:style => "")
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options))
  end
  
  def tab title, options = {}, &block
    block_to_partial('all/tab', options.merge(:title => title), &block)
  end
  
  def quick_panel left_panels = [], right_panels = [], &block
    concat(render(:partial => "all/quick_panel", 
      :locals => {:left_panels=>left_panels, 
                  :right_panels=>right_panels,
                  :body=>capture(&block)}))
  end
  
  def button title, name, options = {}
    js = "return false;"
    js = "document.location.href = '#{options[:path]}';#{js}" if options.key?(:path)
    js = "#{options[:js]};#{js}" if options.key?(:js)
    #js = "$('##{name}').click();#{js}" if options.key?(:submit) && options[:submit] == true
    js = "$(this).parents('form')[0].onsubmit();#{js}" if options.key?(:submit) && options[:submit] == true

    options = options.reverse_merge!(:submit=>false, :klass=>"", :js=>js)
    options = options.merge(:title => title)
    options = options.merge(:name => name)
    render :partial=>"all/button", :locals => options
  end
  
  def sort_link name, sort_field
    direction = "desc"
    direction_sign = ""
    if params[:sort] == sort_field
      if params[:sdir] == "desc"
        direction = "asc"
        direction_sign = " ▼"
      else
        direction_sign = " ▲"
      end
    end
    
    link_to name + direction_sign, params.merge(:sort=>sort_field, :sdir=> direction)  
  end

  def menu_item_class url_path = "", param = "", value = ""
    klass = "menu_item bold vr_line"
    klass += " selected" if (params[param] == value) || (url_path.length > 0 && request.url.include?(url_path))
    klass
  end
  
end
