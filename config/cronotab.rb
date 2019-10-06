# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#
# class TestJob
#   def perform
#     puts 'Test!'
#   end
# end
#
# Crono.perform(TestJob).every 2.days, at: '15:30'
#
#Crono.perform(TestJob).every 1.minute
Crono.perform(CardCompensationJob).every 1.day, at: {hour: 00, min: 30}
Crono.perform(CardRefundJob).every 1.day, at: {hour: 04, min: 00}
Crono.perform(ReceiptCompensationJob).every 1.day, at: {hour: 06, min: 00}
Crono.perform(FranchiseeCreateWirecardAccountJob).every 1.day, at: {hour: 02, min: 00}
Crono.perform(PropertyCreateWirecardAccountJob).every 1.day, at: {hour: 03, min: 00}

