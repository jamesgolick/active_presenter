require File.dirname(__FILE__)+'/test_helper'
require 'pp'

Expectations do
  expect nil do
    SignupPresenter.new.id
  end

  expect true do
    SignupPresenter.new.new_record?
  end

  expect user: User, account: Account do
    SignupPresenter.presented
  end

  expect User.create!(hash_for_user) do |u|
    SignupPresenter.new(user: u.expected).user
  end

  expect true do
    SignupPresenter.new(user: nil).user.new_record?
  end

  expect User do
    SignupPresenter.new.user
  end

  expect User.any_instance.to.receive(:login=).with('james') do
    SignupPresenter.new(user_login: 'james')
  end

  # admin= should be protected from mass assignment
  # expect SignupPresenter.new.to.be.attribute_protected?(:user_admin)
  # expect SignupPresenter.new(user_admin: true).user.not.to.be.admin?

  expect 'mymockvalue' do
    User.any_instance.stubs(:login).returns('mymockvalue')
    SignupPresenter.new.user_login
  end

  expect User.any_instance.to.receive(:login=).with('mymockvalue') do
    SignupPresenter.new.user_login = 'mymockvalue'
  end

  expect SignupPresenter.new.not.to.be.valid?
  expect SignupPresenter.new(user: User.new(hash_for_user)).to.be.valid?

  expect ActiveModel::Errors do
    s = SignupPresenter.new
    s.valid?
    s.errors
  end

  expect ActiveModel::Errors do
    s = SignupPresenter.new
    s.valid?
    s.user_errors
  end

  expect ActiveModel::Errors do
    s = SignupPresenter.new
    s.valid?
    s.account_errors
  end

  expect ["can't be blank"] do
    s = SignupPresenter.new
    s.valid?
    s.errors[:user_login]
  end

  expect ["can't be blank"] do
    s = SignupPresenter.new
    s.valid?
    s.errors[:user_login]
  end

  expect ["User Password can't be blank"] do
    s = SignupPresenter.new(:user_login => 'login')
    s.valid?
    s.errors.full_messages
  end

  expect ['c4N n07 83 8L4nK'] do
    old_locale = I18n.locale
    I18n.locale = '1337'
    
    s = SignupPresenter.new(:user_login => nil)
    s.valid?
    message = s.errors[:user_login]
    
    I18n.locale = old_locale
    
    message
  end

  expect ['U53R pa22w0rD c4N n07 83 8L4nK'] do
    old_locale = I18n.locale
    I18n.locale = '1337'
    
    s = SignupPresenter.new(:user_login => 'login')
    s.valid?
    message = s.errors.full_messages
    
    I18n.locale = old_locale
    
    message
  end

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
    s = SignupPresenter.new user: User.new(hash_for_user)
    s.save
  end

  expect ActiveRecord::Base.to.receive(:transaction) do
    s = SignupPresenter.new(user_login: "da", user_password: "seekrit")
    s.save!
  end

  expect User.any_instance.to.receive(:save!) do
    s = SignupPresenter.new(user_login: "da", user_password: "seekrit")
    s.save!
  end

  expect Account.any_instance.to.receive(:save!) do
    User.any_instance.stubs(:save!).returns(true)
    s = SignupPresenter.new(user_login: "da", user_password: "seekrit")
    s.save!
  end

  expect ActiveRecord::RecordInvalid do
    SignupPresenter.new.save!
  end

  expect SignupPresenter.new(user: User.new(hash_for_user)).to.be.save!

  expect SignupPresenter.new.to.be.respond_to?(:user_login)
  expect SignupPresenter.new.to.be.respond_to?(:user_password_confirmation)
  expect SignupPresenter.new.to.be.respond_to?(:valid?) # just making sure i didn't break everything :)
  expect SignupPresenter.new.to.be.respond_to?(:nil?, false) # making sure it's possible to pass 2 arguments

  expect User.create!(hash_for_user).not.to.be.login_changed? do |user|
    s = SignupPresenter.new(user: user)
    s.update_attributes user_login: 'Something Totally Different'
  end

  expect SignupPresenter.new(user: User.create!(hash_for_user)).to.receive(:save) do |s|
    s.update_attributes user_login: 'Something'
  end

  expect 'Something Different' do
    s = SignupPresenter.new
    s.update_attributes user_login: 'Something Different'
    s.user_login
  end

  # Multiparameter assignment
  expect Time.parse('March 27 1980 9:30:59 am') do
    s = SignupPresenter.new
    s.update_attributes({
      :"user_birthday(1i)" => '1980',
      :"user_birthday(2i)" => '3',
      :"user_birthday(3i)" => '27',
      :"user_birthday(4i)" => '9',
      :"user_birthday(5i)" => '30',
      :"user_birthday(6i)" => '59'
    })
    s.user_birthday
  end

  expect nil do
    s = SignupPresenter.new
    s.attributes = nil
  end

  # this is a regression test to make sure that _title is working. we had a weird conflict with using String#delete
  expect 'something' do
    s = SignupPresenter.new :account_title => 'something'
    s.account_title
  end

  expect ["can't be blank"] do
    s = SignupPresenter.new
    s.save
    s.errors[:user_login]
  end

  expect ["can't be blank"] do
    s = SignupPresenter.new
    s.save! rescue
    s.errors[:user_login]
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

  # ActiveRecord::Base uses nil id to signify an unsaved model
  expect nil do
    SignupPresenter.new.id
  end

  expect nil do
    returning(SignupPresenter.new(:user => User.new(hash_for_user))) do |presenter|
      presenter.save!
    end.id
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

  expect SamePrefixPresenter.new.to.be.respond_to?(:account_title)
  expect SamePrefixPresenter.new.to.be.respond_to?(:account_info_info)

  expect [:before_validation, :before_save, :after_save] do
    returning(CallbackOrderingPresenter.new) do |presenter|
      presenter.save!
    end.steps
  end

  expect [:before_validation, :before_save] do
    returning(CallbackCantSavePresenter.new) do |presenter|
      presenter.save
    end.steps
  end

  expect [:before_validation, :before_save] do
    returning(CallbackCantSavePresenter.new) do |presenter|
      begin
        presenter.save!
      rescue ActiveRecord::RecordNotSaved
        # NOP
      end
    end.steps
  end

  expect ActiveRecord::RecordNotSaved do
    CallbackCantSavePresenter.new.save!
  end

  expect ActiveRecord::RecordInvalid do
    CallbackCantValidatePresenter.new.save!
  end

  expect [:before_validation] do
    returning(CallbackCantValidatePresenter.new) do |presenter|
      begin
        presenter.save!
      rescue ActiveRecord::RecordInvalid
        # NOP
      end
    end.steps
  end

  expect [:before_validation] do
    returning(CallbackCantValidatePresenter.new) do |presenter|
      presenter.save
    end.steps
  end

  expect ActiveModel::Errors.any_instance.to.receive(:clear) do
    CallbackCantValidatePresenter.new.valid?
  end

  # this should act as ActiveRecord models do
  expect NoMethodError do
    SignupPresenter.new({i_dont_exist: "blah"})
  end

  expect false do
    SignupNoAccountPresenter.new.save
  end

  expect true do
    SignupNoAccountPresenter.new(user: User.new(hash_for_user), account: nil).save
  end

  expect true do
    SignupNoAccountPresenter.new(user: User.new(hash_for_user), account: nil).save!
  end

  expect Address do
    PresenterWithTwoAddresses.new.secondary_address
  end

  expect "123 awesome st" do
    p = PresenterWithTwoAddresses.new(secondary_address_street: "123 awesome st")
    p.save
    p.secondary_address_street
  end

  # attr_protected
  # expect "" do
  #   p = SignupPresenter.new(account_secret: 'swordfish')
  #   pp " ", "p.account", p.account
  #   pp "p.account.secret", p.account.secret
  #   p.account.secret
  # end

  expect "comment" do
    p = HistoricalPresenter.new(history_comment: 'comment', user: User.new(hash_for_user))
    p.save
    p.history_comment
  end

  expect false do
    SignupPresenter.new.changed?
  end

  expect true do
    p = SignupPresenter.new(user: User.new(hash_for_user))
    p.save
    p.user_login = 'something_else'
    p.changed?
  end
end
