class CardRefundJob
    def perform(*args)
        Reserve.where(reserve_status: 'canceled_with_refund').each do |reserve|
            reserve.realize_refund
        end           
    end
  end