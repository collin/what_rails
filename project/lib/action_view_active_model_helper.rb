module ActionView::Helpers::ActiveRecordInstanceTag
  def error_wrapping(html_tag)
    if object.respond_to?(:errors) && object.errors.respond_to?(:full_messages) && object.errors[@method_name] && object.errors[@method_name].any?
      Base.field_error_proc.call(html_tag, self)
    else
      html_tag
    end
  end
end