class Merchant::MerchantItemsController < Merchant::BaseController

    def index
      @user = current_user
    end

   def show
      @items = Item.where("merchant_id = #{params[:id]}")
    end

   def edit
      @item = Item.find(params[:id])
      @merchant = current_user
    end

    def new
        @merchant = current_user
    end

    def update
      @item = Item.find(params[:id])
      if params[:edit] == "1"
        @item.update(item_params)
        updateable?
      else
        change_item_status
        redirect_to "/merchant/items"
      end
    end

    def create
        item = Item.new(merchant_item_params)
        item.merchant_id = current_user.merchant_id
        if item.save
            flash[:success] = "#{item.name} has been added to list of items"
            redirect_to "/merchant/items"
        else
            flash[:error] = "All fields must me completed"
            render :new
        end
    end

    def destroy
        item = Item.find(params[:id])
        item.delete
        flash[:notice] = "#{item.name} has been deleted"
        redirect_to "/merchant/items"
    end

    private

    def merchant_item_params
        params.permit(:name, :description, :image, :price, :inventory, :active?)
    end

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

  def change_item_status
    item = Item.find(params[:id])
    if item.active? == true
      item.update(active?:false)
      flash[:notice] = "#{item.name} is no longer for sale"
    else
      item.update(active?:true)
      flash[:notice] = "#{item.name} is now available for sale"
    end
  end
end
