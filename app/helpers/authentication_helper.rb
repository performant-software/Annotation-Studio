module AuthenticationHelper

  def allow_saml_authentication?(tenant)
    if tenant.present?
      tenant.auth_allowed.present? && tenant.auth_allowed.include?(Tenant::AUTHORIZATION_METHODS[:saml])
    else
      idp_cert_fingerprint(tenant).present? && idp_sso_target_url(tenant).present?
    end
  end

  def idp_cert_fingerprint(tenant)
    if tenant.present? && tenant.idp_cert_fingerprint.present?
      tenant.idp_cert_fingerprint
    else
      ENV['IDP_CERT_FINGERPRINT']
    end
  end

  def idp_sso_target_url(tenant)
    if tenant.present? && tenant.idp_sso_target_url.present?
      tenant.idp_sso_target_url
    else
      ENV['IDP_SSO_TARGET_URL']
    end
  end

  def allow_wordpress_oauth_authentication?(tenant)
    if tenant.present?
      tenant.auth_allowed.present? && tenant.auth_allowed.include?(Tenant::AUTHORIZATION_METHODS[:oauth])
    else
      wp_auth_key(tenant).present? && wp_auth_secret(tenant).present? && wp_url(tenant).present?
    end
  end

  def wp_auth_key(tenant)
    if tenant.present? && tenant.wp_auth_key.present?
      tenant.wp_auth_key
    else
      ENV['WP_AUTH_KEY']
    end
  end

  def wp_auth_secret(tenant)
    if tenant.present? && tenant.wp_auth_secret.present?
      tenant.wp_auth_secret
    else
      ENV['WP_AUTH_SECRET']
    end
  end

  def wp_url(tenant)
    if tenant.present? && tenant.wp_url.present?
      tenant.wp_url
    else
      ENV['WP_URL']
    end
  end

  def allow_devise_authentication?(tenant)
    if tenant.present?
      tenant.auth_allowed.present? && tenant.auth_allowed.include?(Tenant::AUTHORIZATION_METHODS[:email])
    else
      ENV['ALLOW_EMAIL_AUTHENTICATION']
    end
  end

  def build_omniauth_link(provider)
    provider_label = case provider
      when :wordpress_hosted then $DOMAIN_CONFIG['oauth_provider']
      when :saml then $DOMAIN_CONFIG['saml_provider']
      else I18n.t(provider, scope: [:devise, :omniauth])
    end

    login_label = I18n.t 'authentication.login_in'

    protocol = Rails.env.production? ? 'https' : 'http'
    url_prefix = root_url(protocol: protocol).gsub(/\/$/, "")
    url = omniauth_authorize_path(resource_name, provider)

    link_to "#{login_label} #{provider_label}", "#{url_prefix}#{url}", :class => "btn btn-default", method: :post
  end

  def saml_attributes
    attrs = $DOMAIN_CONFIG['saml_attributes'] || {}
    attrs.keys.inject({}) { |h, k| h[k] = [attrs[k]]; h }
  end

end