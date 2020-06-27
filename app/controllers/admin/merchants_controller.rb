class Admin::MerchantsController < Admin::BaseController


  def index
    @merchants = Merchant.all # overwrite to sort(:name)
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.status == "disabled"
      enable_merchant
      flash[:notice] = "#{merchant.name} is now enabled."
    else
      merchant.update(status: 1)
      merchant.inactivate_items
      flash[:notice] = "#{merchant.name} has been disabled"
    end
    redirect_to admin_merchants_path
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  private

  def enable_merchant
    merchant = Merchant.find_by(params[:id])
    merchant.activate_items
    merchant.update(status: 0)
  end

end
