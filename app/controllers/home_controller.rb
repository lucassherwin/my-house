# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :require_authentication

  def index
    @props = { name: current_person.first_name }
  end
end
