class DesignsController < ApplicationController
  require 'aws-sdk-sqs'

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
    @status = State.where(name_state: "En proceso").first
    if @status.to_s.strip.empty?
      @status = State.create(name_state: "En proceso")
      @status2 = State.create(name_state: "Disponible")
    end
    
    @designer = Designer.where(email: designer_params[:email]).first  
    if @designer.to_s.strip.empty? 
      @designer = Designer.create!(
        name: designer_params[:name], 
        lastname: designer_params[:lastname],
        email: designer_params[:email]
      )
    end    
        
    @design = Design.create!(
      path_original_design: design_params[:path_original_design],
      price: design_params[:price],
      project_id: params[:id],
      designer_id: @designer.id,
      state_id: @status.id)

    respond_to do |format|
      if @design.save
        flash[:message] = "Hemos recibido tu diseño y lo estamos procesando para que sea publicado."
        designToJson = @design.as_json()
        message = { "imageId" => designToJson['_id'].to_s, 
          "email" => designer_params[:email], 
          "name" => designer_params[:name],
          "lastname" => designer_params[:lastname],
          "dateCreation" => Time.now.strftime("%m/%d/%Y"),
          "path_original_design" => design_params[:path_original_design].original_filename
        }
        send_message(message.to_json)
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

  def design_params
    params.require(:design).permit(:price, :path_original_design)
  end

  def send_message(message)
    sqs = Aws::SQS::Client.new(region: 'us-east-2')
    queue_url = "https://sqs.us-east-2.amazonaws.com/296466592965/MessagesQueue"
    sqs.send_message(queue_url: queue_url, message_body: message)
  end
end
