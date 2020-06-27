class Admin::MerchantItemsController < Admin::BaseController

    def index
      @merchant = Merchant.find(params[:merchant_id])
    end

    def edit
      @item = Item.find(params[:merchant_id])
      @merchant = Merchant.find(@item.merchant_id)
    end

    def update
      item = Item.find(params[:id])
      merchant = Merchant.find(params[:merchant_id])
      if params[:edit] == 1
        item.update(item_params)
        updateable?
      else
        if item.active? == true
          item.update(active?:false)
          flash[:notice] = "#{item.name} is no longer for sale"
        else
          item.update(active?:true)
          flash[:notice] = "#{item.name} is now available for sale"
        end
        redirect_to "/admin/merchants/#{merchant.id}/items"
      end
    end

    private

    def item_params
      params.permit(:name, :description, :price, :image, :inventory)
    end

    def updateable?
      if @item.save
        flash[:notice] = "#{@item.name} has been updated"
        redirect_to "/admin/merchants/#{@item.merchant_id}/items"
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        redirect_to "/admin/merchant/items/#{@item.id}"
      end
    end

end
