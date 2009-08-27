FormatFormBuilders ||= {}
module ActionView::Helpers
  def fields_for(record_or_name_or_array, *args, &block)
    raise ArgumentError, "Missing block" unless block_given?
    options = args.extract_options!

    case record_or_name_or_array
    when String, Symbol
      object_name = record_or_name_or_array
      object = args.first
    else
      object = record_or_name_or_array
      object_name = ActionController::RecordIdentifier.singular_class_name(object)
    end

    builder = options[:builder] || default_form_builder
    yield builder.new(object_name, object, self, options, block)
  end
end

class ActionView::Base
  def default_form_builder
    FormatFormBuilders[request.format.to_sym] || self.class.default_form_builder
  end
end