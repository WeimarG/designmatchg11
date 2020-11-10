class ProjectsController < ApplicationController
  helper ProjectsHelper
  skip_before_action :verify_authenticity_token

  def index
    @userId =""

    if session[:user_id].to_s.strip.empty?
      @userId = User.find_by(slug: params[:slug])
    else
      @userId = User.find_by(token: session[:user_id])
    end
        
    @uri = "#{request.env['HTTP_HOST'].downcase}/company/#{@userId.slug}"
    @projects = Project.select(
      'projects.id, 
      projects.name_project, 
      projects.description,
      projects.e_value',
    ).joins(:user)
    .where(users: {id: @userId.id})
    .all

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
    @userId = User.find_by(token: session[:user_id])
    @projects = Project.joins(:user)
    .where(users: {id: @userId.id})
    .find(params[:id])

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
    @userId = User.find_by(token: session[:user_id])
  end

  def create
      @userId = User.find_by(token: session[:user_id])
			@project = Project.create(
				name_project: params[:name_project],
				description: params[:description],
				e_value: params[:e_value],
				user_id: @userId.id
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
    @project = Project.find(params[:id])
  end

  def update
    @userId = User.find_by(token: session[:user_id])
    @project = Project.where(id: params[:id])
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
    @user = User.find_by(token: session[:user_id])
    @project = Project.where(projects: {user_id: @user.id}).where(projects: {id: params[:id]})
    @ds= Design.where(project_id: params[:id])
    respond_to do |format|
      if !@user.to_s.strip.empty?
        @ds.delete_all
        @project.delete_all
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
