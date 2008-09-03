require File.dirname(__FILE__)+'/test_helper'

Expectations do
  expect ActiveRecord::Base.to.receive(:transaction) do
    s = SignupPresenter.new
    s.save
  end

  expect User.any_instance.to.receive(:save) do
    s = SignupPresenter.new :user => User.new(hash_for_user)
    s.save
  end

  expect Account.any_instance.to.receive(:save) do
    s = SignupPresenter.new :user => User.new(hash_for_user)
    s.save
  end

  expect SignupPresenter.new.not.to.be.save

  expect ActiveRecord::Rollback do
    ActiveRecord::Base.stubs(:transaction).yields
    User.any_instance.stubs(:save).returns(false)
    Account.any_instance.stubs(:save).returns(false)
    s = SignupPresenter.new :user => User.new(hash_for_user)
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
  
  expect User.create!(hash_for_user).not.to.be.login_changed? do |user|
    s = SignupPresenter.new(:user => user)
    s.update_attributes :user_login => 'Something Totally Different'
  end

  expect SignupPresenter.new(:user => User.create!(hash_for_user)).to.receive(:save) do |s|
    s.update_attributes :user_login => 'Something'
  end

  expect 'Something Different' do
    s = SignupPresenter.new
    s.update_attributes :user_login => 'Something Different'
    s.user_login
  end
end
