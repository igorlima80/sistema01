module ApplicationHelper
  def eval_with_rescue(code)
    begin
      eval(code)
    rescue Exception => e
      "error"
    end
  end

  def status_label(status = true)
    "<span class='label label-#{status ? 'success' : 'danger'}'>#{t(status)}</span>".html_safe
  end

  def star_rating(score = 0.0)
    r = ''
    score.to_i.times do
      r = r + "<i class='text-yellow fa fa-star'></i>"
    end
    if score.modulo(1) > 0.0
      if score.modulo(1) < 0.5
        r = r + "<i class='text-yellow fa fa-star-half-empty'></i>"
      else
        r = r + "<i class='text-yellow fa fa-star-half-full'></i>"
      end
    end
    (4 - score.to_i).times do
      r = r + "<i class='text-yellow fa fa-star-o'></i>"
    end
    r.html_safe
  end
end
