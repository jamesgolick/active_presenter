require File.dirname(__FILE__)+'/test_helper'

class BaseTest < Test::Unit::TestCase
  def test_presents_method_should_store_presented_names_and_their_classes
    assert_equal({:user => User, :account => Account}, SignupPresenter.presented)
  end
end
