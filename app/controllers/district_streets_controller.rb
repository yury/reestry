class DistrictStreetsController < ApplicationController
  # GET /district_streets
  # GET /district_streets.xml
  def index
    @district_streets = DistrictStreet.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @district_streets }
    end
  end

  # GET /district_streets/1
  # GET /district_streets/1.xml
  def show
    @district_street = DistrictStreet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @district_street }
    end
  end

  # GET /district_streets/new
  # GET /district_streets/new.xml
  def new
    @district_street = DistrictStreet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @district_street }
    end
  end

  # GET /district_streets/1/edit
  def edit
    @district_street = DistrictStreet.find(params[:id])
  end

  # POST /district_streets
  # POST /district_streets.xml
  def create
    @district_street = DistrictStreet.new(params[:district_street])

    respond_to do |format|
      if @district_street.save
        flash[:notice] = 'DistrictStreet was successfully created.'
        format.html { redirect_to(@district_street) }
        format.xml  { render :xml => @district_street, :status => :created, :location => @district_street }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @district_street.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /district_streets/1
  # PUT /district_streets/1.xml
  def update
    @district_street = DistrictStreet.find(params[:id])

    respond_to do |format|
      if @district_street.update_attributes(params[:district_street])
        flash[:notice] = 'DistrictStreet was successfully updated.'
        format.html { redirect_to(@district_street) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @district_street.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /district_streets/1
  # DELETE /district_streets/1.xml
  def destroy
    @district_street = DistrictStreet.find(params[:id])
    @district_street.destroy

    respond_to do |format|
      format.html { redirect_to(district_streets_url) }
      format.xml  { head :ok }
    end
  end
end
