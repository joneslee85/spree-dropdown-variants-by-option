module Spree::DropdownVariantsByOption::Variant

  def self.included(target)
    target.class_eval do
      # Try and find the variant from the supplied pair option_type <--> option value and product
      def self.find_by_option_values(product_id, opt_values)

        join = []
        cond = {'variants.product_id' => product_id}
        i = 0

        opt_values.each_pair do |opt_type, opt_value|
          join << "JOIN option_values_variants ovv#{i} ON ovv#{i}.variant_id = variants.id"
          cond["ovv#{i}.option_value_id"] = opt_value
          i += 1
        end

        # sample SQL: SELECT "variants".* FROM "variants" JOIN option_values_variants ovv0 ON ovv0.variant_id = variants.id JOIN option_values_variants ovv1 ON ovv1.variant_id = variants.id WHERE ("variants"."product_id" = '569012001' AND "ovv0"."option_value_id" = '979459986' AND "ovv1"."option_value_id" = '369541888')
        Variant.all(:joins => join.join(' '),
                    :conditions => cond)
      end
    end
  end

end


