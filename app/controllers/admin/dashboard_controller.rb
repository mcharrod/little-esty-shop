class Admin::DashboardController < ApplicationController
  def index
    @repository = GithubFacade.repository
  end
end
