class ProjectsController < ApplicationController
  helper ProjectsHelper
  skip_before_action :verify_authenticity_token
  require 'fileutils'

  def index
    @userId =""

    if cookies[:current_session].to_s.strip.empty?
      @userId = User.find_by(slug: params[:slug])
    else
      @userId = User.find_by(_id: puts Rails.cache.read(cookies[:current_session]))
    end
        
    @uri = "#{request.env['HTTP_HOST'].downcase}/company/#{@userId.slug}"

    @projects = Project.where(user: @userId.id)

    respond_to do |format|
      if !@userId.to_s.strip.empty?
        format.html { render controller: "projects", action: "index" }      
        format.json { render json: @projects.to_json(), status: :ok }					
      else
        render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
      end	
    end
  end

  def show
    @userId = User.find_by(_id: puts Rails.cache.read(cookies[:current_session]))
    @projects = Project.and({user: @userId.id}, {_id: params[:id]}).first

    respond_to do |format|
      if !@userId.to_s.strip.empty?    
        format.html { render controller: "projects", action: "show" }      
        format.json { render json: @projects.to_json(), status: :ok }					
      else
        render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
      end	
    end
  end

  def new
    @userId = User.find_by(_id: puts Rails.cache.read(cookies[:current_session]))
  end

  def create
      @userId = User.find_by(_id: puts Rails.cache.read(cookies[:current_session]))
			@project = Project.create!(
				name_project: params[:name_project],
				description: params[:description],
				e_value: params[:e_value],
				user: @userId.id
			)

			respond_to do |format|
				if @project.save
					format.html { redirect_to controller: "projects", action: "index" }      
          format.json { render json: @project.to_json(), status: :created }					
				else
					format.html { render controller: "projects", action: "new" } 
					format.json { render json:{status: 'ERROR', message:'Project not saved'}, status: :unprocessable_entity }					
				end	
			end
  end

  def edit
    @project = Project.where(_id: params[:id])
  end

  def update
    @userId = User.find_by(_id: puts Rails.cache.read(cookies[:current_session]))
    @project = Project.where(_id: params[:id])
      .update(
        name_project: params[:name_project],
        description: params[:description],
        e_value: params[:e_value]
      )

    respond_to do |format|
      if @project
        format.html { redirect_to controller: "projects", action: "index" }      
        format.json { render json: @project.to_json(), status: :accepted }	
      else
        format.html { render controller: "projects", action: "edit" } 
        format.json { render json:{status: 'ERROR', message:'Project not saved'}, status: :unprocessable_entity }					
      end
    end		
  end

  def delete

  end 

  def destroy
    @user = User.find_by(_id: puts Rails.cache.read(cookies[:current_session]))
    @project = Project.and({user: @user.id}, {_id: params[:id]}).first
    @designs= Design.where(project: params[:id])
    for design in @designs do
      # Remove original designs 
      design.path_original_design.remove!
      design.save!
      
      # Remove original designs folder
      puts Rails.root
      puts design.path_original_design.url
      filePath = Rails.root + design.path_original_design.url
      parentDir = File.dirname(filePath)
      puts parentDir
      
      FileUtils.rm_rf('/home/ubuntu/P1/Proyecto1-Grupo11/public/uploads/design/path_original_design/'+design.id.to_s)
    end

    respond_to do |format|
      if !@user.to_s.strip.empty?
        @designs.delete
        @project.delete
        format.html { redirect_to controller: "projects", action: "index" }       
        format.json { render json:{status: 'SUCCES', message:'Project deleted'}, status: :ok }
      else
        format.json { render json:{status: 'ERROR', message:'Project not exist to the user'}, status: :unprocessable_entity }
      end	
    end
  end

  private

  def project_params
		params.require(:user).permit(:name_project, :description, :e_value)
  end
end
