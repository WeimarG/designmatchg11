class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    @user = User.authenticate(login_params[:email], login_params[:password])
    respond_to do |format|
        if !@user.to_s.strip.empty?
            token = generate_token
            Rails.cache.write(token, @user._id)
            cookies.permanent[:current_session] = token
            @user.update(token: token)
            format.html { redirect_to controller: "projects", action: "index" }      
            format.json { render json: {:token => generate_token}, status: :ok }
        else
            flash[:signin_errors] = ['El usuario o la contraseña es incorrecta.']
            format.html { render action: "index" }  
            format.json { render json:{status: 'ERROR', message:'User not found'}, status: :unprocessable_entity }             
        end
    end
  end

  def delete
  end

  def destroy
      @user = User.find_by(token: cookies[:current_session])
      respond_to do |format|
          if !@user.to_s.strip.empty?
            cookies.delete(:current_session)
            @user.update(token: "")
            format.html { redirect_to root_path }       
          else
            format.html { redirect_to controller: "projects", action: "index" }       
            format.json { render json:{status: 'ERROR', message:'User not found'}, status: :unprocessable_entity }             
          end
      end
  end

  private

  def generate_token
      SecureRandom.hex(20)
  end

  def login_params
      params.require(:user).permit(:email, :password)
  end
end
