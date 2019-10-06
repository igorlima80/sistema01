class CardCompensationJob
    def perform(*args)
        Reserve.where(reserve_status: 'paid_capture_pending').or(Reserve.where(reserve_status: 'fresh')).each do |reserve|
            agora = Date.today
            dias = ( self.checkin_date.day - agora.day )

            if dias <= reserve.setting.days_for_reserve_refund # Verificando se passou o prazo para reembolso
                reserve.perform_transaction        
            end
            
        end           
    end
  end