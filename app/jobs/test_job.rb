class TestJob # This is not an Active Job job, but pretty legal Crono job.
  def perform(*args)
   puts 'teste'
  end
end