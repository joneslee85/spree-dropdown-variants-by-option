module Spree::DropdownVariantsByOption::OrdersController
  JS_ESCAPE_MAP = { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }

  def self.included(target)
    target.class_eval do
      create.before << :add_variants_from_option_values
      create.wants.js
      create.failure.wants.js { render :js => "alert('#{format_js_error}')" }
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

  def format_js_error
    message = "The following error(s) have occurred when trying to add the item to the cart: "
    @order.errors.each_full {|m| message += "#{m} "}
    message.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
    message
  end

end
