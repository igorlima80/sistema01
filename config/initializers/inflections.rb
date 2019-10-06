# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
  inflect.irregular 'conveniência', 'conveniências'
  inflect.irregular 'acomodação', 'acomodações'
  inflect.irregular 'avaliação', 'avaliações'
  inflect.irregular 'período especial', 'períodos especiais'
  inflect.irregular 'status do credenciamento', 'status dos credenciamentos'
  inflect.irregular 'status do pagamento', 'status dos pagamentos'
  inflect.irregular 'status da reserva', 'status das reservas'
  inflect.irregular 'tipo de taxa', 'tipos de taxas'
  inflect.irregular 'tipo de viagem', 'tipos de viagens'
  inflect.irregular 'tipo de acomodação', 'tipos de acomodações'
  inflect.irregular 'item de menu', 'itens de menu'
inflect.irregular 'reserve', 'reserves'


#   inflect.uncountable %w( fish sheep )
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
