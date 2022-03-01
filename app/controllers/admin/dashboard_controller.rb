class Admin::DashboardController < ApplicationController
    def index
      @customers = Customer.all
      @invoices = Invoice.all
      @incomplete = @invoices.incomplete
    end
  end
