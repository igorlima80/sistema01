class MenuItemsController < Admin::ApplicationController
  load_and_authorize_resource

  # GET /menu_items
  def index
  end

  # GET /menu_items/1
  def show
  end

  # GET /menu_items/new
  def new
  end

  # GET /menu_items/1/edit
  def edit
  end

  # POST /menu_items
  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      redirect_to @menu_item, notice: 'Menu item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /menu_items/1
  def update
    if @menu_item.update(menu_item_params)
      redirect_to @menu_item, notice: 'Menu item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /menu_items/1
  def destroy
    @menu_item.destroy
    redirect_to menu_items_url, notice: 'Menu item was successfully destroyed.'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def menu_item_params
      params.require(:menu_item).permit(:name, :link, :published, :position,
        :target, :permission, :permission_check, :icon, :menu_item_id)
    end
end
