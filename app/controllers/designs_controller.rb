class DesignsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
  end

  def download

    # file_name = params[:path_original_design].split('/').last
    # file_name= Desing.
    # @filename = "#{Rails.root}/#{image_tag design.path_original_design}"
    @filename = "#{design.path_original_design.mini.url}"
    send_file(@filename, :type => 'image/png/jpg') 
  
  end
  
  def create
    @status = State.find_by(name_state: "En proceso")
    if @status.to_s.strip.empty?
      @status = State.create(name_state: "En proceso")
      @status2 = State.create(name_state: "Disponible")
    end
    
    @designer = Designer.find_by(email: designer_params[:email])    
    if @designer.to_s.strip.empty?
      @designer = Designer.create designer_params
      @design = Design.create(path_original_design: design_params[:path_original_design],
        price: design_params[:price],
        project_id: params[:id],
        designer_id: @designer.id,
        state_id: @status.id)
    else 
      @design = Design.create(path_original_design: design_params[:path_original_design],
        price: design_params[:price],
        project_id: params[:id],
        designer_id: @designer.id,
        state_id: @status.id)
    end    
    
    respond_to do |format|
      if @design.save
        flash[:message] = "Hemos recibido tu diseño y lo estamos procesando para que sea publicado."
        format.json { render json: @design.to_json(), status: :created }
        format.html { redirect_to company_path(params[:slug]) }  
      else
        format.html { render controller: "designs", action: "new" } 
        format.json { render json:{status: 'ERROR', message:'Project not saved'}, status: :unprocessable_entity }
      end
    end
  end

  private
  def designer_params
    params.require(:design).permit(:name, :lastname, :email)
  end

  private
  def design_params
    params.require(:design).permit(:price, :path_original_design)
  end
end
