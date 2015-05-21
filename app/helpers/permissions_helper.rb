module PermissionsHelper
  # Generates a hash of links to edit or destroy a resource
  # @param [Instance|Class] resource
  # @param [Actions] (optional) a list of crud actions to create links to.
  #   defaults to
  # @param [Hash] kwargs optional hash to pass to link to
  # @option kwargs [String] :controller - controller name to use.
  #   Otherwise a guess is performed based on the resource class name.
  # @option kwargs [Hash] url_extras - passed to url_for. Can be used for nested resources.
  # @return [Hash] a list of links to actions which the user is allowed to perform
  def crud_links_for_resource(resource,  actions = nil, **kwargs)
    i18n_key = resource.model_name.i18n_key
    controller = kwargs[:controller] || i18n_key.to_s.pluralize
    unless actions
      if resource.is_a? Class
        actions = [:new]
      else
        actions = [:edit, :destroy]
      end
    end
    actions.keep_if { |action| can? action, resource }.each_with_object({}) do |action, hash|
      url_params = { action: action, controller: controller, id: resource }.merge(kwargs[:url_extras].to_h)
      txt = t("#{ i18n_key }.#{action}")
      if resource.is_a? Class
        url_params.except!(:id)
      end
      options = kwargs.except(:controller, :url_extras)
      case action
        when :destroy
          options.merge!(
              method: :delete,
              data: { confirm: t("#{ i18n_key }.confirm_#{action}") }.merge(options[:data].to_h)
          )
        when :refresh
          options.merge!(
              method: :patch
          )
        else
      end
      hash[action] = link_to(txt,url_params,options)
    end
  end
end
