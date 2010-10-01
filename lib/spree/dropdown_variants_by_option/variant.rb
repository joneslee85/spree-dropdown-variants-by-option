module Spree::DropdownVariantsByOption::Variant

  def self.included(target)
    target.class_eval do
      # Try and find the variant from the supplied pair option_type <--> option value and product
      def self.find_by_option_values(product_id, opt_values)

        join_clause = []
        condition_clause = {'variants.product_id' => product_id, 'variants.deleted_at' => nil}

        opt_values.each_with_index do |opt_value, i|
          join_clause << "JOIN option_values_variants ovv#{i} ON ovv#{i}.variant_id = variants.id"
          condition_clause["ovv#{i}.option_value_id"] = opt_value.last
        end

        # sample SQL: SELECT "variants".* FROM "variants" JOIN option_values_variants ovv0 ON ovv0.variant_id = variants.id JOIN option_values_variants ovv1 ON ovv1.variant_id = variants.id WHERE ("variants"."product_id" = '569012001' AND "variants"."deleted_at" IS NULL AND "ovv0"."option_value_id" = '979459986' AND "ovv1"."option_value_id" = '553775723')
        Variant.all(:joins => join_clause.join(' '),
                    :conditions => condition_clause)
      end
    end
  end

end


