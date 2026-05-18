class HouseholdsController < ApplicationController
  before_action :require_authentication

  def new
    redirect_to household_path(current_person.household) if current_person.household
  end

  def create
    if current_person.household
      return render json: { errors: ["You already belong to a household"] }, status: :unprocessable_entity
    end

    household = Household.new(household_params)

    # both must save successfully or rollback
    ActiveRecord::Base.transaction do
      household.save!
      current_person.update!(household: household)
    end

    render json: { id: household.id, name: household.name }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def show
    @household = current_person.household

    if @household.nil? || @household.id != params[:id]
      return redirect_to(current_person.household ? household_path(current_person.household) : new_household_path)
    end

    @props = { household: { id: @household.id, name: @household.name } }
  end

  private

  def household_params
    params.require(:household).permit(:name)
  end
end
