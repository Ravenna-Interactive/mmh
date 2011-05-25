module ApplicationHelper
  
  def field_error_list model, field=:base, options={}
    options.reverse_merge!(
      :field => field.to_s.humanize.capitalize,
      :class => 'field-errors'
    )
    if model.errors[field]
      content_tag :ul, :class => options[:class] do
        model.errors[field].each do |error|
          concat content_tag(:li, "#{field == :base ? "" : options[:field]} #{error}")
        end
      end
    end
  end
  
end
