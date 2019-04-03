class Test2 
  include Asynchronize 
  asynchronize :test
  def test 
    puts 'before sleeping' 
    sleep 2 
    puts 'after sleeping' 
  end 
  th = Test2.new.test 
  puts 'something' 
  th.join 
end 
load 'lib/asynchronize.rb'
 load 'lib/test2.rb'