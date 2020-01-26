class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    if params[:id].nil? # if there is no user id in params, show current one
      @user = current_user
    else
      @user = User.where(:id => params[:id])
    end
    @document_list = Document.all # for getting document name in annotations table.
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end

    gon.rabl template: 'app/views/users/show.rabl', as: 'user'
  end

  def remove_user
    respond_to do |format|
      @anthology = Anthology.find(params[:anthology_id])
      Rails.logger.info "**** entering remove doc"
      @user = User.find(params[:user_id])
      Rails.logger.info "The user is #{@user.inspect}"

      if @anthology.present? && @user.present? && @user.anthologies.delete(@anthology)

        format.html {redirect_to users_path, notice: "The user #{@user.fullname} was successfully removed from this anthology"}
      else
        format.html { redirect_to users_path, error: "There was a problem removing the user from this anthology" }
      end
    end
  end

  def anthology_add
    successful = true
    users = []
    begin
      anthology = Anthology.find(params[:anthology])
      params[:user_ids].each do |user_id|
        user = User.find(user_id)
        unless user.anthologies.include?(anthology)
          user.anthologies << anthology
          users << user.fullname
        end
        user.save
      end
    rescue
      successful = false
    end
    respond_to do |format|
      if successful
        if users.count == 1
          users_string = " #{users.first}"
        elsif users.count == 2
          users_string = "s #{users.first} and #{users.last}"
        elsif users.count > 2
          users_string = "s #{users[ 0..-2 ].join(", ")} and #{users.last}"
        end
        format.html { redirect_to users_path, notice: "You added the user#{users_string} to this anthology" }
      else
        format.html { redirect_to users_path, alert: "There was a problem adding users to the anthology selected"}
      end
    end
    # redirect_to anthology_path(Anthology.first)
  end
  def index
    @anthologies = current_user.anthologies.map {|ant| ant.id}.uniq
    @anthologies = [@anthologies, Anthology.where(user_id: current_user.id).pluck(:id) ]
    @anthologies = @anthologies.flatten.uniq
    @anthologies = Anthology.all.map {|ant| ant if @anthologies.include?(ant.id)}
    @anthologies = @anthologies.compact
    if params[:anthology_id].present?
      @anthology = Anthology.find(params[:anthology_id])
    else
      @anthology = Anthology.where(user_id: current_user.id).first
    end
    @users = []
    per_page = 20
    @search_users_count = 0
    if ( params.has_key?(:lastname) || params.has_key?(:email) || params.has_key?(:first_name) ) && ( !(params.has_key?(:users)) || params[:users] == 'search_results' )
      user_set = 'search_results'
    elsif params[:users].present?
      user_set = params[:users]
    else
      user_set = 'all'
    end
    [:firstname, :lastname, :email].each do |query|
      if params.has_key?(query) && params[query].present?
        @search_users_count = User.where("#{query} LIKE ?", "%#{params[query]}%").count
      end
    end
    @tab_state = { user_set => 'active' }
    @all_users_count = User.all.count
    if user_set == 'all'
      @users = User.paginate(:page => params[:page], :per_page => per_page ).order("created_at DESC")
    elsif user_set == 'search_results'
      Rails.logger.info "***"
      Rails.logger.info "entering search results"
      [:firstname, :lastname, :email].each do |query|
        if params.has_key?(query) && params[query].present?
            @users = User.where("#{query} LIKE ?", "%#{params[query]}%")
          end
        end
      if @users.present?
        @users = @users.paginate(:page => params[:page], :per_page => per_page).order('created_at DESC')
      end
    end
  # add search parameters if they are there



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end
  # def index
  #   @anthologies = Anthology.all
  #   if params[:anthology_id].present?
  #     @anthology = Anthology.find(params[:anthology_id])
  #   else
  #     @anthology = Anthology.first
  #   end
  #   @users = User.all
  # end

  def edit
    @user = User.where(:id => params[:id])
  end

  def users_params
    params.require(:user).permit(:email, :password, :agreement, :affiliation, :password_confirmation, 
                                 :remember_me, :firstname, :lastname, :rep_privacy_list, :rep_group_list,
                                 :rep_subgroup_list, :first_name_last_initial, :username) 
  end
end
