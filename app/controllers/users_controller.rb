# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, :correct_user, only: [:show]

  # getting some weird intermittent errors where users are being redirected
  # to '/users' after signup. this is a failsafe last-resort solution
  def index
    redirect_to root_path
  end

  def show
    respond_to do |format|
      format.html # show.html.erb.bak
      format.xml { render xml: @user }
    end
  end

  protected

  def correct_user
    @user = User.find(params[:id])

    redirect_to root_path unless current_user.id == @user.id
  end
end
