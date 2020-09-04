class SamlController < ApplicationController

  def metadata
    if $DOMAIN_CONFIG['saml_metadata'].present?
      render $DOMAIN_CONFIG['saml_metadata']
    else
      redirect_to root_url
    end
  end

end