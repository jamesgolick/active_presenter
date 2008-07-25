require File.dirname(__FILE__)+'/test_helper'

Expectations do
  expect :user => User, :account => Account do
    SignupPresenter.presented
  end
  
  expect User.create!(hash_for_user) do |u|
    SignupPresenter.new(:user => u.expected).user
  end
  
  expect User do
    SignupPresenter.new.user
  end
  
  expect User.any_instance.to.receive(:login=).with('james') do
    SignupPresenter.new(:user_login => 'james')
  end
  
  expect 'mymockvalue' do
    User.any_instance.stubs(:login).returns('mymockvalue')
    SignupPresenter.new.user_login
  end
  
  expect User.any_instance.to.receive(:login=).with('mymockvalue') do
    SignupPresenter.new.user_login = 'mymockvalue'
  end
  
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
  
  expect ActiveRecord::Base.to.receive(:transaction) do
    s = SignupPresenter.new
    s.save
  end
  
  expect User.any_instance.to.receive(:save) do
    s = SignupPresenter.new
    s.save
  end
  
  expect Account.any_instance.to.receive(:save) do
    s = SignupPresenter.new
    s.save
  end
  
  expect SignupPresenter.new.not.to.be.save
  
  expect ActiveRecord::Rollback do
    ActiveRecord::Base.stubs(:transaction).yields
    User.any_instance.stubs(:save).returns(false)
    Account.any_instance.stubs(:save).returns(false)
    s = SignupPresenter.new
    s.save
  end
  
  expect ActiveRecord::Base.to.receive(:transaction) do
    s = SignupPresenter.new
    s.save!
  end
  
  expect User.any_instance.to.receive(:save!) do
    s = SignupPresenter.new
    s.save!
  end
  
  expect Account.any_instance.to.receive(:save!) do
    User.any_instance.stubs(:save!)
    s = SignupPresenter.new
    s.save!
  end
  
  expect ActiveRecord::RecordInvalid do
    SignupPresenter.new.save!
  end
  
  expect SignupPresenter.new(:user => User.new(hash_for_user)).to.be.save!
  
  expect SignupPresenter.new.to.be.respond_to?(:user_login)
  expect SignupPresenter.new.to.be.respond_to?(:valid?) # just making sure i didn't break everything :)
end
