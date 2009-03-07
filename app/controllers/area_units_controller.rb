class AreaUnitsController < ApplicationController
  before_filter :admin_login_required
  
  # GET /area_units
  # GET /area_units.xml
  def index
    @area_units = AreaUnit.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @area_units }
    end
  end

  # GET /area_units/1
  # GET /area_units/1.xml
  def show
    @area_unit = AreaUnit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @area_unit }
    end
  end

  # GET /area_units/new
  # GET /area_units/new.xml
  def new
    @area_unit = AreaUnit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @area_unit }
    end
  end

  # GET /area_units/1/edit
  def edit
    @area_unit = AreaUnit.find(params[:id])
  end

  # POST /area_units
  # POST /area_units.xml
  def create
    @area_unit = AreaUnit.new(params[:area_unit])

    respond_to do |format|
      if @area_unit.save
        flash[:notice] = 'AreaUnit was successfully created.'
        format.html { redirect_to(@area_unit) }
        format.xml  { render :xml => @area_unit, :status => :created, :location => @area_unit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @area_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /area_units/1
  # PUT /area_units/1.xml
  def update
    @area_unit = AreaUnit.find(params[:id])

    respond_to do |format|
      if @area_unit.update_attributes(params[:area_unit])
        flash[:notice] = 'AreaUnit was successfully updated.'
        format.html { redirect_to(@area_unit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @area_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /area_units/1
  # DELETE /area_units/1.xml
  def destroy
    @area_unit = AreaUnit.find(params[:id])
    @area_unit.destroy

    respond_to do |format|
      format.html { redirect_to(area_units_url) }
      format.xml  { head :ok }
    end
  end
end
