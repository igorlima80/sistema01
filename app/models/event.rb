class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true, optional: true, dependent: :destroy
  
  belongs_to :user

  monetize :value_cents, allow_nil: true

  after_create :create_eventable

  def create_eventable
    unless eventable
      ev = Kernel.const_get(self.eventable_type).new(
        start_date: start_date,
        final_date: final_date,
        user: user,
        accommodation: accommodation,
        event: self
      )
      ev.name = name if Kernel.const_get(self.eventable_type).column_names.include? 'name'
      ev.value = value if Kernel.const_get(self.eventable_type).column_names.include? 'value_cents'
      ev.save
      self.eventable_id = ev.id
      self.save
    end
  end

  def as_json(options = {})
    json_to_return = super(except: [ 'eventable_type', 'eventable_id',
      'value_cents', 'value_currency', 'created_at', 'updated_at'])
    json_to_return[:value] = ActionController::Base.helpers.number_to_currency(value) if value_cents
    json_to_return[:start] = start_date
    json_to_return[:end] = final_date + 1.day
    # json_to_return[:url] = '#'
    json_to_return[:allDay] = true
    # json_to_return[:rendering] = 'background'
    json_to_return[:extendedProps] = {}
    json_to_return[:extendedProps][:kind] = case eventable_type
      when 'Reserve'
        'Reserva'
      when 'Unavailability'
        'Indisponibilidade'
      when 'SpecialPeriod'
        'Período Especial'
      else
        'Evento'
    end
    json_to_return[:title] = case eventable_type
      when 'Reserve'
        'Reserva'
      when 'Unavailability'
        'indisponível'
      when 'SpecialPeriod'
        "#{name.blank? ? 'período especial' : name}: #{ActionController::Base.helpers.number_to_currency(value)}"
      else
        'gray'
    end
    json_to_return[:color] = case eventable_type
      when 'Reserve'
        'green'
      when 'Unavailability'
        'red'
      when 'SpecialPeriod'
        'blue'
      else
        'gray'
    end
    return json_to_return
  end
end
