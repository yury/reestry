class RealtyTypesController < ApplicationController
  before_filter :admin_login_required
  
  # GET /realty_types
  # GET /realty_types.xml
  def index
    @realty_types = RealtyType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @realty_types }
    end
  end

  # GET /realty_types/1
  # GET /realty_types/1.xml
  def show
    @realty_type = RealtyType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @realty_type }
    end
  end

  # GET /realty_types/new
  # GET /realty_types/new.xml
  def new
    @realty_type = RealtyType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @realty_type }
    end
  end

  # GET /realty_types/1/edit
  def edit
    @realty_type = RealtyType.find(params[:id])
  end

  # POST /realty_types
  # POST /realty_types.xml
  def create
    @realty_type = RealtyType.new(params[:realty_type])

    respond_to do |format|
      if @realty_type.save
        flash[:notice] = 'RealtyType was successfully created.'
        format.html { redirect_to(@realty_type) }
        format.xml  { render :xml => @realty_type, :status => :created, :location => @realty_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @realty_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /realty_types/1
  # PUT /realty_types/1.xml
  def update
    @realty_type = RealtyType.find(params[:id])

    respond_to do |format|
      if @realty_type.update_attributes(params[:realty_type])
        flash[:notice] = 'RealtyType was successfully updated.'
        format.html { redirect_to(@realty_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @realty_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /realty_types/1
  # DELETE /realty_types/1.xml
  def destroy
    @realty_type = RealtyType.find(params[:id])
    @realty_type.destroy

    respond_to do |format|
      format.html { redirect_to(realty_types_url) }
      format.xml  { head :ok }
    end
  end
end
