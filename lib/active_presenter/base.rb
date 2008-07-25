module ActivePresenter
  class Base
    class_inheritable_accessor :presented
    self.presented = {}

    def self.presents(*types)
      attr_accessor *types
      
      types.each do |t|
        define_method("#{t}_errors") do
          send(t).errors
        end
        
        presented[t] = t.to_s.classify.constantize
      end
    end
    
    attr_accessor :errors

    def initialize(args = {})
      presented.each do |type, klass|
        send("#{type}=", args[type].is_a?(klass) ? args.delete(type) : klass.new)
      end
      
      self.attributes = args
    end
    
    def attributes=(attrs)
      attrs.each { |k,v| send("#{k}=", v) }
    end
    
    def respond_to?(method)
      presented_attribute?(method) || super
    end
    
    def method_missing(method_name, *args, &block)
      presented_attribute?(method_name) ? delegate_message(method_name, *args, &block) : super
    end
    
    def valid?
      self.errors = ActiveRecord::Errors.new(self)
      
      presented.keys.each do |type|
        presented_inst = send(type)
        
        merge_errors(presented_inst, type) unless presented_inst.valid?
      end
      
      errors.empty?
    end
    
    def save
      saved = nil
      
      ActiveRecord::Base.transaction do
        saved = presented_instances.map(&:save).all?
        raise ActiveRecord::Rollback unless saved # TODO: Does this happen implicitly?
      end
      
      saved
    end
    
    def save!
      ActiveRecord::Base.transaction do
        presented_instances.each(&:save!)
      end
    end
    
    protected
      def presented_instances
        presented.keys.map { |key| send(key) }
      end
      
      def delegate_message(method_name, *args, &block)
        presentable = presentable_for(method_name)
        send(presentable).send(flatten_attribute_name(method_name, presentable), *args, &block)
      end
      
      def presentable_for(method_name)
        presented.keys.detect do |type|
          method_name.to_s.starts_with?(attribute_prefix(type))
        end
      end
    
      def presented_attribute?(method_name)
        !presentable_for(method_name).nil?
      end
      
      def flatten_attribute_name(name, type)
        name.to_s.delete(attribute_prefix(type))
      end
      
      def attribute_prefix(type)
        "#{type}_"
      end
      
      def merge_errors(presented_inst, type)
        presented_inst.errors.each do |att,msg|
          errors.add(attribute_prefix(type)+att, msg)
        end
      end
  end
end
