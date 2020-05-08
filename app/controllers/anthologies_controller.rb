class AnthologiesController < ApplicationController
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
    if @current_tab == 'users' && current_user.admin?
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
                @search_users_count = User.where("users.email like ?", "%#{params[query]}%").count
                @users = User.where("users.email like ?", "%#{params[query]}%")
              elsif query == :name
                @search_users_count = User.where("users.firstname like ? OR users.lastname like ? OR users.full_name like ?",
                  "%#{params[query]}%", "%#{params[query]}%", "%#{params[query]}%").count
                @users = User.where("users.firstname like ? OR users.lastname like ? OR users.full_name like ?",
                  "%#{params[query]}%", "%#{params[query]}%", "%#{params[query]}%")
              end
            end
          end
          @users = @users.paginate(:page => @page, :per_page =>10 )
        else
          @users = []
        end
      end
    else
      if !params[:docs].present? && !params[:author] && !params[:edition] && !params[:title] || params[:docs] == "all"
        @tab_state = { 'all' => 'active' }
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
          [:title, :author, :edition].each do |query|
            if params.has_key?(query) && params[query].present?
              if query == :edition
                @search_documents_count = Document.tagged_with(params[query]).count
                @documents = Document.tagged_with(params[query])
              elsif params.has_key?(query) && params[query].present?
                @search_documents_count = Document.where("#{query} LIKE ?", "%#{params[query]}%").count
                @documents = Document.where("#{query} LIKE ?", "%#{params[query]}%")
              end
            end
          end
          @documents = @documents.paginate(:page => @page, :per_page =>10 )
        else
          @documents = []
        end
      end
    end
  end

  def create
    @anthology = Anthology.new(anthology_params)
    @anthology.user = current_user
    respond_to do |format|
      if @anthology.save
        format.html { redirect_to anthologies_url, notice: 'Anthology was successfully created.', anchor: 'created'}
        format.json { render json: @anthology, status: :created, location: @anthology }
      else
        format.html { render action: "new" }
        format.json { render json: @anthology.errors, status: :unprocessable_entity }
      end
    end

  end

  def remove_doc
    respond_to do |format|
      @anthology = Anthology.find(params[:anthology_id])
      Rails.logger.info "**** entering remove doc"
      @document = Document.find(params[:document_id])
      Rails.logger.info "The doc is #{@document.inspect}"

      if @anthology.present? && @document.present? && @anthology.documents.delete(@document)

        format.html {redirect_to @anthology, notice: "The document #{@document.title} was successfully removed from this anthology"}
      else
        format.html { redirect_to anthologies_path, error: "There was a problem removing the document from this anthology" }
      end
    end
  end

  def remove_user
    respond_to do |format|
      @anthology = Anthology.find(params[:anthology_id])
      Rails.logger.info "**** removing user"
      @user = User.find(params[:user_id])
      Rails.logger.info "The user is #{@user.inspect}"

      if @anthology.present? && @user.present? && @anthology.users.delete(@user)
        format.html {redirect_to anthology_path(@anthology, tab: "users"), tab: 'users', notice: "The user #{@user.full_name} was successfully removed from this anthology"}
      else
        format.html { redirect_to anthologies_path, error: "There was a problem removing the user from this anthology" }
      end
    end
  end

  def add_user
    respond_to do |format|
      @anthology = Anthology.find(params[:anthology_id])
      Rails.logger.info "**** adding user"
      @user = User.find(params[:user_id])
      Rails.logger.info "The user is #{@user.inspect}"
      
      if @anthology.present? && @user.present?
        @anthology.users << @user
        format.html {redirect_to anthology_path(@anthology, tab: "users"), notice: "The user #{@user.email} was successfully added to this anthology"}
      else
        format.html { redirect_to anthologies_path, error: "There was a problem adding the user to this anthology" }
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
        format.html { redirect_to anthologies_url, notice: 'Anthology was successfully updated.' }
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
    @anthology = Anthology.friendly.find(params.has_key?(:anthology_id) ? params[:anthology_id] : params[:id])
  end

  def anthology_params
    params.require(:anthology).permit(:name, :description, :banner)
  end
end
