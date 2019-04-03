# load 'asynchronize'
class Test
  include Asynchronize
  # This can be called anywhere.
  asynchronize :my_test, :my_other_test
  def my_test
    # sleep(30)

    return 'test'
  end
  def my_other_test
    puts "It's all out there"
    sleep(300)
  end
end