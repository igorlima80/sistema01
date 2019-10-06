class FranchiseeCreateWirecardAccountJob
    def perform(*args)
        Franchisee.where(financial_account:[nil, ""] ).each do |franchisee|
            franchisee.create_financial_account
            franchisee.create_bank_account            
        end           
    end
  end