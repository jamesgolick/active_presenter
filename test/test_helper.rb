require File.dirname(__FILE__)+'/../lib/active_presenter'
require 'expectations'
require 'logger'

ActiveRecord::Base.configurations = {'sqlite3' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.boolean  :admin,    :default => false
    t.string   :login,    :default => ''
    t.string   :password, :default => ''
    t.datetime :birthday
  end
  
  create_table :accounts do |t|
    t.string :subdomain, :default => ''
    t.string :title,     :default => ''
  end
  
  create_table :addresses do |t|
    t.string :street
  end

  create_table :account_infos do |t|
    t.string :info
  end
end

class User < ActiveRecord::Base
  validates_presence_of :login, :password
  attr_accessible :login, :password, :birthday
  attr_accessor   :password_confirmation
end
class Account < ActiveRecord::Base; end
class Address < ActiveRecord::Base; end
class AccountInfo < ActiveRecord::Base; end

class PresenterWithTwoAddresses < ActivePresenter::Base
  presents :address, :secondary_address => Address
end

class SignupPresenter < ActivePresenter::Base
  presents :account, :user
end

class EndingWithSPresenter < ActivePresenter::Base
  presents :address
end

class CantSavePresenter < ActivePresenter::Base
  presents :address
  
  before_save :halt
  
  def halt; false; end
end

class SignupNoNilPresenter < ActivePresenter::Base
  presents :account, :user

  def save?(key, instance)
    !instance.nil?
  end
end

class AfterSavePresenter < ActivePresenter::Base
  presents :address
  
  after_save :set_street
  
  def set_street
    address.street = 'Some Street'
  end
end

class SamePrefixPresenter < ActivePresenter::Base
  presents :account, :account_info
end

class CallbackOrderingPresenter < ActivePresenter::Base
  presents :account
  
  before_validation :do_before_validation
  before_save :do_before_save
  after_save :do_after_save
  
  attr_reader :steps
  
  def initialize(params={})
    super
    @steps = []
  end
  
  def do_before_validation
    @steps << :before_validation
  end
  
  def do_before_save
    @steps << :before_save
  end
  
  def do_after_save
    @steps << :after_save
  end
end

class CallbackCantSavePresenter < ActivePresenter::Base
  presents :account
  
  before_validation :do_before_validation
  before_save :do_before_save
  before_save :halt
  after_save :do_after_save
  
  attr_reader :steps
  
  def initialize(params={})
    super
    @steps = []
  end
  
  def do_before_validation
    @steps << :before_validation
  end
  
  def do_before_save
    @steps << :before_save
  end
  
  def do_after_save
    @steps << :after_save
  end

  def halt
    false
  end
end

class CallbackCantValidatePresenter < ActivePresenter::Base
  presents :account
  
  before_validation :do_before_validation
  before_validation :halt
  before_save :do_before_save
  after_save :do_after_save
  
  attr_reader :steps
  
  def initialize(params={})
    super
    @steps = []
  end
  
  def do_before_validation
    @steps << :before_validation
  end
  
  def do_before_save
    @steps << :before_save
  end
  
  def do_after_save
    @steps << :after_save
  end

  def halt
    false
  end
end

def hash_for_user(opts = {})
  {:login => 'jane', :password => 'seekrit' }.merge(opts)
end

