module Spree::DropdownVariantsByOption::Order

  def self.included(target)
    target.class_eval do
      alias :spree_validate :validate unless method_defined?(:spree_validate)
      alias :validate :site_validate

      def dropdown_variants_by_option_add_variant(variant, quantity = 1)
        if variant.respond_to? :pop
          @variant_errors = I18n.t('not_all_options_specified') if variant.length > 1
          variant = variant.pop
        end

        if variant.nil? || !variant.available?
          @variant_errors = I18n.t('out_of_stock')
        elsif @variant_errors.nil?
          self.add_variant(variant, quantity)
        end

      end
    end
  end

  def site_validate
    self.errors.add_to_base(@variant_errors) unless @variant_errors.nil?
  end

end
