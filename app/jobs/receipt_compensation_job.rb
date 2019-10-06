class ReceiptCompensationJob
    def perform(*args)
        Receipt.where(date_of_compensation: Date.today, status: 'pending').each do |receipt|
            receipt.realize_transfer
        end           
    end
  end