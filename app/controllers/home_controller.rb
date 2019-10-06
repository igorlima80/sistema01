class HomeController < Admin::ApplicationController
  def index
    @user_kind = ''
    params[:q] ||= {}
    params[:q][:s] ||= 'name asc'
    params[:q][:the_date] ||= Time.zone.today
   # @q = current_user.accommodations.ransack(params[:q])
  #  @accommodations = @q.result(distinct: true)
    if current_user.has_role? :admin
      @user_kind = 'Admin'
    
    end
  end
end
