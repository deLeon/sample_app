module ApplicationHelper

  def logo
    logo = image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  ## Exercise 11.5.1
  def warn_if_char_count_exceeded(field_id, update_id, maximum_number_of_chars, options = {})

    ## 1 Simple Counter
    # function = "var remaining_chars = $(#{maximum_number_of_chars}) - $F('#{field_id}').length;
    # $('#{update_id}').innerHTML = remaining_chars;"

    ## 2 Countdown with the red background if count is exceeded
    function = "var out = [];
    var remaining_chars = $(#{maximum_number_of_chars}) - $F('#{field_id}').length;
    if (remaining_chars >= 0) {
    out = remaining_chars;
    document.getElementById('#{field_id}').style.backgroundColor='white'
    } else {
    out = 'Too long by ' + remaining_chars;
    document.getElementById('#{field_id}').style.backgroundColor='red'
    }
    $('#{update_id}').innerHTML = out;"



    out = javascript_tag(function)
    out += observe_field(field_id, options.merge(:function => function))
  end

  def observe_field(field_id, options = {})
    if options[:frequency] && options[:frequency] > 0
      build_observer('Form.Element.Observer', field_id, options)
    else
      build_observer('Form.Element.EventObserver', field_id, options)
    end
  end

  def build_observer(klass, name, options = {})
      if options[:with] && (options[:with] !~ /[\{=(.]/)
        options[:with] = "'#{options[:with]}=' + encodeURIComponent(value)"
      else
        options[:with] ||= 'value' unless options[:function]
      end

      callback = options[:function] || remote_function(options)
      javascript  = "new #{klass}('#{name}', "
      javascript << "#{options[:frequency]}, " if options[:frequency]
      javascript << "function(element, value) {"
      javascript << "#{callback}}"
      javascript << ")"
      javascript_tag(javascript)
  end
end

