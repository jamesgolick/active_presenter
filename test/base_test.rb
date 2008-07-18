require File.dirname(__FILE__)+'/test_helper'

class BaseTest < Test::Unit::TestCase
  def test_presents_method_should_store_presented_names_and_their_classes
    assert_equal({:user => User, :account => Account}, SignupPresenter.presented)
  end
  
  # {:user => User.find(1)} # User.find(1)
  def test_initialize_should_accept_an_instance_and_assign_it_to_the_instance_var
    u = User.create!(hash_for_user)
    p = SignupPresenter.new(:user => u)
    
    assert_equal u, p.user
  end
end
