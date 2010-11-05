jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})


var spree_ddvbo_app = {

  addToCart: function(e) {
          e.preventDefault();
          spree_ddvbo_app.getBusy(null); // could really use $.proxy here but spree doesn't have 1.4
          $.post(this.action, $(this).serialize(), spree_ddvbo_app.getNotBusy, "script");
          return false;
  },

  optionValueChanged: function(e) {
          e.preventDefault();
          spree_ddvbo_app.getBusy( function() {
            spree_ddvbo_app.fetchValuesForSecondaryOptions( spree_ddvbo_app.getNotBusy );
            return false;
          });
  },

  fetchValuesForSecondaryOptions: function( fn_after ) {
         $.post('/products/option_value_changed', $("#cart_form").serialize(), fn_after, "script");
  },

  getBusy : function( fn ) {
          $("#busy_indicator").fadeIn('fast', fn);
  },

  getNotBusy : function() {
          $("#busy_indicator").fadeOut('fast');
  }

};

jQuery(document).ready( function () {

  $("#cart_form").bind('submit', spree_ddvbo_app.addToCart);

  $("#option_values_select_primary, #option_values_radio_primary").bind('change', spree_ddvbo_app.optionValueChanged);

});
