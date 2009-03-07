class RealtyPurposesController < ApplicationController
  before_filter :admin_login_required
  
  # GET /realty_purposes
  # GET /realty_purposes.xml
  def index
    @realty_purposes = RealtyPurpose.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @realty_purposes }
    end
  end

  # GET /realty_purposes/1
  # GET /realty_purposes/1.xml
  def show
    @realty_purpose = RealtyPurpose.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @realty_purpose }
    end
  end

  # GET /realty_purposes/new
  # GET /realty_purposes/new.xml
  def new
    @realty_purpose = RealtyPurpose.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @realty_purpose }
    end
  end

  # GET /realty_purposes/1/edit
  def edit
    @realty_purpose = RealtyPurpose.find(params[:id])
  end

  # POST /realty_purposes
  # POST /realty_purposes.xml
  def create
    @realty_purpose = RealtyPurpose.new(params[:realty_purpose])

    respond_to do |format|
      if @realty_purpose.save
        flash[:notice] = 'RealtyPurpose was successfully created.'
        format.html { redirect_to(@realty_purpose) }
        format.xml  { render :xml => @realty_purpose, :status => :created, :location => @realty_purpose }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @realty_purpose.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /realty_purposes/1
  # PUT /realty_purposes/1.xml
  def update
    @realty_purpose = RealtyPurpose.find(params[:id])

    respond_to do |format|
      if @realty_purpose.update_attributes(params[:realty_purpose])
        flash[:notice] = 'RealtyPurpose was successfully updated.'
        format.html { redirect_to(@realty_purpose) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @realty_purpose.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /realty_purposes/1
  # DELETE /realty_purposes/1.xml
  def destroy
    @realty_purpose = RealtyPurpose.find(params[:id])
    @realty_purpose.destroy

    respond_to do |format|
      format.html { redirect_to(realty_purposes_url) }
      format.xml  { head :ok }
    end
  end
end
