# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def block_to_partial(partial_name, options = {}, &block)
    options.reverse_merge!(:style => "")
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options))
  end
  
  def tab title, options = {}, &block
    @use_tab_buttons = true
    options.reverse_merge!(:image => "")
    block_to_partial('all/tab', options.merge(:title => title), &block)
    @use_tab_buttons = false
  end
  
  def quick_panel left_panels = [], right_panels = [], &block
    concat(render(:partial => "all/quick_panel", 
      :locals => {:left_panels=>left_panels, 
                  :right_panels=>right_panels,
                  :body=>capture(&block)}))
  end

  def slider name, options = {}
    options.reverse_merge!(:style => "")
    options.reverse_merge!(:min => 0)
    options.reverse_merge!(:max => 10000)
    options.reverse_merge!(:step => 100)
    options.reverse_merge!(:unit => "")
    options.merge!(:name => name)

    render :partial=>"all/slider", :locals => options
  end

  def checkbox id, text, checked, options = {}
    options.reverse_merge!(:style => "")
    options.merge!(:id => id)
    options.merge!(:text => text)
    options.merge!(:checked => checked)
    render :partial=>"all/checkbox", :locals => options
  end

  def button title, name, options = {}
    js = "return false;"
    js = "document.location.href = '#{options[:path]}';#{js}" if options.key?(:path)
    js = "#{options[:js]};#{js}" if options.key?(:js)
    js = "$(this).parents('form').submit();#{js}" if options.key?(:submit) && options[:submit] == true

    options = options.reverse_merge!(:submit=>false, :klass=>"blue", :js=>js, :style=>"")
    options = options.merge(:title => title)
    options = options.merge(:name => name)
    options[:klass] += " t" if @use_tab_buttons == true

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
  
end
