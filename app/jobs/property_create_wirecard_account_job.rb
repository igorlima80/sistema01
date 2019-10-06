class PropertyCreateWirecardAccountJob
    def perform(*args)
        Property.where(financial_account:[nil, ""] ).each do |property|
            property.create_financial_account
            property.create_bank_account  
        end           
    end
  end