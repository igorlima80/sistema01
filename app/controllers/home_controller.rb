class HomeController < Admin::ApplicationController
  def index
    @user_kind = ''
    params[:q] ||= {}
    params[:q][:s] ||= 'name asc'
    params[:q][:the_date] ||= Time.zone.today
   # @q = current_user.accommodations.ransack(params[:q])
   # @accommodations = @q.result(distinct: true)
    if current_user.has_role? :admin
      @user_kind = 'Admin'
    
    end
    @leaders = Leader.all
    @members = Member.all
    @members_visited = Member.where(status: "visited")
    @members_unvisited = Member.where(status: "unvisited")
    @visits = Visit.order(created_at: :desc)
  end
end
