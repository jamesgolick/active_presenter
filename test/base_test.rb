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

  # admin= should be protected from mass assignment
  expect SignupPresenter.new.to.be.attribute_protected?(:user_admin)
  expect SignupPresenter.new(:user_admin => true).user.not.to.be.admin?

  expect 'mymockvalue' do
    User.any_instance.stubs(:login).returns('mymockvalue')
    SignupPresenter.new.user_login
  end

  expect User.any_instance.to.receive(:login=).with('mymockvalue') do
    SignupPresenter.new.user_login = 'mymockvalue'
  end

  expect SignupPresenter.new.to.be.respond_to?(:user_login)
  expect SignupPresenter.new.to.be.respond_to?(:user_password_confirmation)
  expect SignupPresenter.new.to.be.respond_to?(:valid?) # just making sure i didn't break everything :)


  # this is a regression test to make sure that _title is working. we had a weird conflict with using String#delete
  expect 'something' do
    s = SignupPresenter.new :account_title => 'something'
    s.account_title
  end

  expect 'Login' do
    SignupPresenter.human_attribute_name(:user_login)
  end

  # it was raising with nil
  expect SignupPresenter do
    SignupPresenter.new(nil)
  end
  
  expect EndingWithSPresenter.new.address.not.to.be.nil?

  # this should act as ActiveRecord models do
  expect NoMethodError do
    SignupPresenter.new({:i_dont_exist=>"blah"})
  end
  
  expect CantSavePresenter.new.not.to.be.save # it won't save because the filter chain will halt
  
  expect ActiveRecord::RecordNotSaved do
    CantSavePresenter.new.save!
  end
  
  expect 'Some Street' do
    p = AfterSavePresenter.new
    p.save
    p.address.street
  end
  
  expect 'Some Street' do
    p = AfterSavePresenter.new
    p.save!
    p.address.street
  end
end
