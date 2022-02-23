class Admin::AdminInvoicesController < ApplicationController

  def index
    @invoices = Invoice.all

  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  private
  def invoice_params
    params.permit(:status)
  end
end
