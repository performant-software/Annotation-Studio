class AnthologiesController < ApplicationController
  before_filter :find_anthology, :only => [:show, :edit]

  def show
    @page = 1
    if params[:page].present?
      @page = params[:page]
    end
    @anthologies = Anthology.all
    @search_documents_count = 0
    @all_documents_count = @anthology.documents.count
    document_set = 'all'
    total_pages = 1
    @tab_state = { document_set => 'active' }
    if !params[:docs].present? && !params[:author] && !params[:edition] && !params[:title]  || params[:docs] == "all"
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

  def index
    @anthologies = Anthology.all
  end

  def edit

  end

  def destroy
    @anthology.destroy

    respond_to do |format|
      format.html { redirect_to anthologies_url }
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
