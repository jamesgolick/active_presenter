module ActivePresenter
  class Base
    class_inheritable_accessor :presented
    self.presented = {}

    def self.presents(*types)
      attr_accessor *types
      
      types.each do |t|
        presented[t] = t.to_s.classify.constantize
      end
    end
    
    def initialize(args = {})
      presented.each do |type, klass|
        send("#{type}=", args[type].is_a?(klass) ? args[type] : klass.new)
        
        send("#{type}").update_attributes(attributes_for(type, args))
      end
    end
    
    protected
      def attributes_for(type, args)
        (args[type].is_a?(Hash) ? args[type] : flattened_attributes_for(type, args)).symbolize_keys
      end
      
      def flattened_attributes_for(type, args)
        args.inject({}) do |hash, next_element|
          key, value = next_element
          hash[key.to_s.delete("#{type}_")] = value if key.to_s.starts_with?("#{type}_")
          hash
        end
      end
  end
end
