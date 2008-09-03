require File.dirname(__FILE__)+'/test_helper'

Expectations do
  expect SignupPresenter.new.not.to.be.valid?
  expect SignupPresenter.new(:user => User.new(hash_for_user)).to.be.valid?

  expect ActiveRecord::Errors do
    s = SignupPresenter.new
    s.valid?
    s.errors
  end

  expect ActiveRecord::Errors do
    s = SignupPresenter.new
    s.valid?
    s.user_errors
  end

  expect ActiveRecord::Errors do
    s = SignupPresenter.new
    s.valid?
    s.account_errors
  end

  expect String do
    s = SignupPresenter.new
    s.valid?
    s.errors.on(:user_login)
  end
  
  expect String do
    s = SignupPresenter.new
    s.save
    s.errors.on(:user_login)
  end

  expect String do
    s = SignupPresenter.new
    s.save! rescue
    s.errors.on(:user_login)
  end
end
