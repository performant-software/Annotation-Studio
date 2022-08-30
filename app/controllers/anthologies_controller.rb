class AnthologiesController < ApplicationController
  include ApplicationHelper

  before_filter :find_anthology, :only => [:show, :edit, :destroy]
  before_filter :authenticate_user!

  def show
    @page = 1
    if params[:page].present?
      @page = params[:page]
    end
    @anthologies = Anthology.all
    @search_documents_count = 0
    @all_documents_count = @anthology.documents.count
    @search_users_count = 0
    @all_users_count = @anthology.users.count
    document_set = 'all'
    @tab_state = { document_set => 'active' }
    @current_tab = params[:tab]
    if @current_tab == 'users' && (can? :update, Anthology)
      Rails.logger.info "******** We are in users tab"
      if !params[:docs].present? && !params[:email] && !params[:name] || params[:docs] == "all"
        @tab_state = { 'all' => 'active' }
        if params[:order].present? && ["full_name", "email"].include?(params[:order])
          if params[:order] == "full_name"
            @users = @anthology.users.order(full_name: :desc).paginate(:page => @page, :per_page =>10 ).uniq
          else
            @users = @anthology.users.order(params[:order].to_sym).paginate(:page => @page, :per_page =>10 ).uniq
          end
        else
          @users = @anthology.users.paginate(:page => @page, :per_page =>10 ).uniq
        end
      else
        @tab_state = { 'search_results' => 'active' }
        if params[:email].present? || params[:name].present?
          [:email, :name].each do |query|
            if params.has_key?(query) && params[query].present?
              if query == :email
                @users = User.where("users.email ILIKE ?", "%#{params[query]}%")
                @search_users_count = @users.count
              elsif query == :name
                @users = User.where("users.firstname ILIKE ? OR users.lastname ILIKE ? OR users.full_name ILIKE ?",
                  "%#{params[query]}%", "%#{params[query]}%", "%#{params[query]}%")
                @search_users_count = @users.count
              end
            end
          end
          @users = @users.paginate(:page => @page, :per_page =>10 )
        else
          @users = []
        end
      end
    else
      Rails.logger.info "******** We are in documents tab"
      if !params[:docs].present? && !params[:author] && !params[:edition] && !params[:title] || ( params[:docs] == "all" )
        @tab_state = { 'all' => 'active' }
        @docs = "all"
        if params[:order].present? && ["title", "author", "created_at"].include?(params[:order])
          if params[:order] == "created_at"
            @documents = @anthology.documents.order(created_at: :desc).paginate(:page => @page, :per_page =>10 )
          else
            @documents = @anthology.documents.order(params[:order].to_sym).paginate(:page => @page, :per_page =>10 )
          end
        else
          @documents = @anthology.documents.paginate(:page => @page, :per_page =>10 )
        end
      else
        @tab_state = { 'search_results' => 'active' }
        if params[:author].present? || params[:edition].present? || params[:title].present?
          if params[:docs] != "all"
            [:title, :author, :edition].each do |query|
              if params.has_key?(query) && params[query].present?
                if query == :edition
                  tags = Tag.where('name ILIKE ?', "%#{params[query]}%").pluck(:name)
                  @search_documents_count = Document.tagged_with(tags, any: true).count
                  @documents = Document.tagged_with(tags, any: true).order("vetted DESC NULLS LAST")
                elsif params.has_key?(query) && params[query].present?
                  @search_documents_count = Document.where("#{query} ILIKE ?", "%#{params[query]}%").count
                  @documents = Document.where("#{query} ILIKE ?", "%#{params[query]}%").order("vetted DESC NULLS LAST")
                end
              end
            end
          else
            if params[:order].present? && ["title", "author", "created_at"].include?(params[:order])
              if params[:order] == "created_at"
                @documents = @anthology.documents.order(created_at: :desc).paginate(:page => @page, :per_page =>10 )
              else
                @documents = @anthology.documents.order(params[:order].to_sym).paginate(:page => @page, :per_page =>10 )
              end
            else
              @documents = @anthology.documents.paginate(:page => @page, :per_page =>10 )
            end

          end
          if params.has_key?(:order) && params[:order].present?
            @documents = @documents.order(params[:order])
          end
          @documents = @documents.paginate(:page => @page, :per_page =>10 )
        else
          @documents = []
        end
      end
    end
    @searched_name = (params[:name] || [])
    @searched_email = (params[:email] || [])
  end

  def create
    @anthology = Anthology.new(anthology_params)
    @anthology.user = current_user
    respond_to do |format|
      if @anthology.save
        current_user.rep_group_list.add(@anthology.slug)
        current_user.save
        format.html { redirect_to current_user, notice: 'Anthology was successfully created.', anchor: 'created'}
        format.json { render json: @anthology, status: :created, location: @anthology }
      else
        format.html { render action: "new" }
        format.json { render json: @anthology.errors, status: :unprocessable_entity }
      end
    end

  end

  def remove_user
    respond_to do |format|
      @anthology = Anthology.find(params[:anthology_id])
      Rails.logger.info "**** removing user"
      @user = User.find(params[:user_id])
      Rails.logger.info "The user is #{@user.inspect}"
      @searched_name = (params[:name] || [])
      @searched_email = (params[:email] || [])

      if @anthology.present? && @user.present? && @anthology.users.delete(@user)
        @user.rep_group_list.remove(@anthology.slug)
        @user.save
        format.html {redirect_to anthology_path(@anthology, tab: "users", name: @searched_name, email: @searched_email), tab: 'users', notice: "The user #{@user.full_name} was successfully removed from this anthology"}
      else
        format.html { redirect_to anthologies_path(@anthology, tab: "users", name: @searched_name, email: @searched_email), error: "There was a problem removing the user from this anthology" }
      end
    end
  end

  def add_user
    respond_to do |format|
      @anthology = Anthology.find(params[:anthology_id])
      Rails.logger.info "**** adding user"
      @user = User.find(params[:user_id])
      Rails.logger.info "The user is #{@user.inspect}"
      @searched_name = (params[:name] || [])
      @searched_email = (params[:email] || [])

      if @anthology.present? && @user.present?
        add_user_to_anthology(@user, @anthology)
        format.html {redirect_to anthology_path(@anthology, tab: "users", name: @searched_name, email: @searched_email), notice: "The user #{@user.email} was successfully added to this anthology"}
      else
        format.html { redirect_to anthologies_path(@anthology, tab: "users", name: @searched_name, email: @searched_email), error: "There was a problem adding the user to this anthology" }
      end
    end
  end

  def index
    @anthologies = Anthology.all
  end

  def edit

  end

  def destroy

    respond_to do |format|
    if @anthology.destroy
      format.html { redirect_to anthologies_url, notice: "You successfully deleted the anthology" }
    else
      format.html { redirect_to anthologies_url, alert: "There was a problem deleting the anthology" }
    end
      format.json { head :no_content }
    end
  end

  def update
    @anthology = Anthology.friendly.find(params[:id])

    respond_to do |format|
      if @anthology.update_attributes(anthology_params)
        format.html { redirect_to @anthology, notice: 'Anthology was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_anthology_url(id: @anthology.friendly_id), alert: @anthology.error_messages}
        format.json { render json: @anthology.errors, status: :unprocessable_entity }
      end
    end

  end

  def new
    @anthology = Anthology.new
  end

  private

  def find_anthology
    @anthology = Anthology.includes(:users, :documents).friendly.find(params.has_key?(:anthology_id) ? params[:anthology_id] : params[:id])
  end

  def anthology_params
    params.require(:anthology).permit(:name, :description, :banner)
  end
end
