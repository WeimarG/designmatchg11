class UsersController < ApplicationController  
  skip_before_action :verify_authenticity_token
  
  def index
  end

  def create
    if user_params[:password] == user_params[:password_confirmation]
      generate_slug
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
            format.html { redirect_to controller: "sessions", action: "index" }
            format.json { render json: @user.to_json(only: [:company, :email]), status: :created }
        else
            flash[:signup_errors] = "No fue posible hacer el registro, el correo ya se encuentra registrado."
            format.html { render action: "index" }
            format.json { render json:{status: 'ERROR', message:'No fue posible crear el usuario', data:@user.errors}, status: :unprocessable_entity }
        end
      end
    else
      flash[:signup_errors] = "La contraseña y la confirmación de contraseña no coinciden."
      render action: "index"
    end
  end
  
  private

  def user_params
    params.require(:user).permit!
  end   

  def generate_slug
    user_params[:slug] = user_params[:company].gsub(/\s+/, "").downcase + Random.rand(1...100).to_s
  end
end
