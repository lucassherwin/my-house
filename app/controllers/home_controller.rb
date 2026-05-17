# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :require_authentication

  def index
    h = current_person.household
    @props = {
      name: current_person.first_name,
      household: h ? { id: h.id, name: h.name } : nil
    }
  end
end
