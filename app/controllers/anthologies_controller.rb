class AnthologiesController < ApplicationController
  before_filter :find_anthology, :only => [:show, :edit]

  def show

  end

  def create
    @anthology = Anthology.new(anthology_params)
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
        format.html { render action: "edit" }
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
    params.require(:anthology).permit(:name, :description)
  end
end
