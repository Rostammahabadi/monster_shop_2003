class Merchant::MerchantItemsController < Merchant::BaseController

    def index
      @user = current_user
    end

    def show
      @items = Item.where("merchant_id = params[:id]")
    end

    def edit
      @item = Item.find(params[:item_id])
      @merchant = current_user
    end

    def update
      @item = Item.find(params[:item])
      @item.update(item_params)
      updateable?
    end

    private

    def item_params
      params.permit(:name, :description, :price, :image, :inventory)
    end

    def updateable?
      if @item.save
        flash[:notice] = "#{@item.name} has been updated"
        redirect_to "/merchant/items"
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        redirect_to "/merchant/items/#{@item.id}"
      end
    end
end
