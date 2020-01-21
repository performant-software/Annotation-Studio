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

        format.html {redirect_to @anthology, notice: "The user #{@user.fullname} was successfully removed from this anthology"}
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
        format.html { redirect_to anthology_path(Anthology.find(params[:anthology])), notice: "You added the user#{users_string} to this anthology" }
      else
        format.html { redirect_to users_path, alert: "There was a problem adding users to the anthology selected"}
      end
    end
    # redirect_to anthology_path(Anthology.first)
  end
  def index
    @anthologies = Anthology.all
    if params[:anthology_id].present?
      @anthology = Anthology.find(params[:anthology_id])
    else
      @anthology = Anthology.first
    end
    @users = User.all
  end

  def edit
    @user = User.where(:id => params[:id])
  end

  def users_params
    params.require(:user).permit(:email, :password, :agreement, :affiliation, :password_confirmation, 
                                 :remember_me, :firstname, :lastname, :rep_privacy_list, :rep_group_list,
                                 :rep_subgroup_list, :first_name_last_initial, :username) 
  end
end
