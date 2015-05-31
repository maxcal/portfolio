module PermissionsHelper
  # Generates a hash of links to perform CRUD actions on a resource
  # The keys in the hash correspond to the action.
  # Only actions which the user is authorized to perform are included.
  #
  # @param [ActiveRecord::Base|Class] resource
  # @param [Array] actions (optional) a list of crud actions to create links to.
  #   defaults to
  # @param [String] :controller - controller name to use.
  #   Otherwise a guess is performed based on the resource class name.
  # @param [Hash] :url_extras - passed to url_for. Can be used for nested resources.
  # @return [Hash] a list of links to actions which the user is allowed to perform
  def crud_links_for_resource(resource,  actions = nil, controller: nil, url_extras: {}, **kwargs)
    i18n_key = resource.model_name.i18n_key
    controller = controller || resource.model_name.plural
    authorized = authorize_actions(actions || actions_for_resource(resource), resource)
    authorized.each_with_object({}) do |action, hash|
      options = kwargs
      case action
        when :destroy
          options.merge!(
              method: :delete,
              data: {
                  confirm: t("#{ i18n_key }.confirm_destroy", default: t('crud_buttons.confirm_destroy'))
              }.merge(options[:data].to_h)
          )
        when :refresh
          options.merge!(method: :patch)
        else
      end
      url_params = default_url_params(resource, action, controller).merge(url_extras)
      hash[action] = link_to(text_for_action(action, i18n_key),url_params,options)
    end
  end

  private

  def actions_for_resource(resource)
    resource.is_a?(Class) ? [:new] : [:edit, :destroy]
  end

  def authorize_actions(actions, resource)
    actions.keep_if { |action| can? action, resource }
  end

  def text_for_action(action, i18n_key)
    t("#{ i18n_key }.#{action}", default: t("crud_buttons.#{action}"))
  end

  def default_url_params(resource, action, controller)
    params = { action: action, controller: controller }
    params[:id] = resource.to_param unless resource.is_a? Class
    params
  end
end
