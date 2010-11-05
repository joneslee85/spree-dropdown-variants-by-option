module Spree::DropdownVariantsByOption::OrdersController
  JS_ESCAPE_MAP = { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }

  def self.included(target)
    target.class_eval do
      create.before << :add_variants_from_option_values
      create.wants.js
      create.failure.wants.js
    end
  end

  private

  def add_variants_from_option_values
    quantity = params[:quantity].to_i
    return if params[:option_values_primary].nil? or quantity < 1
    # Combine primary and non-primary option values to locate the correct variant
    options_params = params[:option_values_primary].merge(params[:option_values] || {}) 

    options_params.reject!{ |k,v| v.empty? }

    if options_params and params[:product_id]
      @variant = Variant.find_by_option_values(params[:product_id], options_params.values)
      @object.dropdown_variants_by_option_add_variant(@variant, quantity)
    end
  end


end
