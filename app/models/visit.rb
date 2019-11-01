class Visit < ApplicationRecord
  belongs_to :member

  def visit_json
    self.to_json(     
      except: [:created_at, :updated_at]
      )
  end
  
end
