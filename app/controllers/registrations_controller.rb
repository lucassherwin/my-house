# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
    redirect_to root_path if current_person
  end

  def create
    person = Person.new(registration_params)

    if person.save
      reset_session
      session[:person_id] = person.id
      render json: { ok: true }, status: :created
    else
      render json: { errors: person.errors.full_messages }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotUnique => e
    render json: { errors: ["Email already in use"] }, status: :unprocessable_entity
  end

  private

  def registration_params
    params.permit(:email, :first_name, :last_name, :password)
  end
end
