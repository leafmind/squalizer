class ReportsController < ApplicationController

  before_action :fetch_user

  def index
    @report = Report.new(user: @user)
    @reports = Report.all
  end

  def show
    @report = Report.find params[:id]
  end

  def create
    @report = @user.reports.create(report_params)
    redirect_to user_report_path(@user, @report)
  end

  private

  def fetch_user
    @user ||= User.find params[:user_id]
  end

  def report_params
    params.require(:report).permit(:state)
  end

end