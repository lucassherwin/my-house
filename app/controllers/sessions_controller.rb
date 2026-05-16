# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to root_path if current_person
  end

  def create
    person = Person.find_by(email: params[:email])

    if person&.authenticate(params[:password])
      reset_session
      session[:person_id] = person.id
      render json: { ok: true }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end
