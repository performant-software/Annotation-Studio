class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :rememberable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable,
         :timeoutable, :omniauthable, :omniauth_providers => [:wordpress_hosted, :saml]

  validates :agreement, presence: { message: "must be checked. Please check the box to confirm you have read and accepted the terms and conditions." }

  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]

  acts_as_role_user
  acts_as_taggable_on :rep_group, :rep_privacy, :rep_subgroup, :anthology_group

  has_many :documents
  has_and_belongs_to_many :anthologies, join_table: 'users_anthologies'

  # Doesn't handle missing values.
  def fullname
    "#{firstname} #{lastname}"
  end

  def username
    "#{firstname.downcase}#{lastname.first.downcase}"
  end

  # Doesn't handle missing values.
  def first_name_last_initial
     "#{firstname} #{lastname.first}."
  end

  # Doesn't handle missing values.
  def first_initial_last_name
     "#{firstname.first}. #{lastname}"
  end

  def has_document_permissions?(document)
    self.has_role?(:admin) || self == document.user
  end

  def self.all_tags()
    tags = User.rep_group_counts.map{|t| t.name}
    return tags.sort!
  end

  def admin?
    roles.pluck(:name).include? 'admin'
  end

  def teacher?
    roles.pluck(:name).include? 'teacher'
  end

  def self.find_for_wordpress_oauth2(auth, current)
    Rails.logger.info "*****"
    Rails.logger.info "the auth under the find is #{auth}"

    find_for_authentication(auth) do |user|
      user.firstname = auth.info.name.split(' ').first
      user.lastname = auth.info.name.split(' ').length > 1 ? auth.info.name.split(' ').last : " "
    end
  end

  def self.find_for_saml(auth, current)
    Rails.logger.info "*****"
    Rails.logger.info "the auth under the find is #{auth}"

    find_for_authentication(auth) do |user|
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
    end
  end

  private

  def self.find_for_authentication(auth)
    user = User.where(email: auth.info.email.downcase).first_or_initialize do |u|
      yield u, auth if block_given?
      u.agreement = true
      u.password = Devise.friendly_token[0,20]
    end

    user.provider = auth.provider
    user.uid = auth.uid

    user.skip_confirmation! if user.new_record?

    if user.save
      user
    end
  end

end
