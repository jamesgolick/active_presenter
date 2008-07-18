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
    
    def method_missing(method_name, *args, &block)
      presented.keys.each do |type|
        if method_name.to_s.starts_with?(attribute_prefix(type))
          message = flatten_attribute_name(method_name, type)
          
          if message.ends_with?('=')
            return send(type).send(message, *args, &block)
          else
            return send(type).send(message)
          end
        end
      end
      
      super
    end
    
    protected
      def attributes_for(type, args)
        (args[type].is_a?(Hash) ? args[type] : flattened_attributes_for(type, args)).symbolize_keys
      end
      
      def flattened_attributes_for(type, args)
        args.inject({}) do |hash, next_element|
          key, value = next_element
          hash[flatten_attribute_name(key, type)] = value if key.to_s.starts_with?(attribute_prefix(type))
          hash
        end
      end
      
      def flatten_attribute_name(name, type)
        name.to_s.delete(attribute_prefix(type))
      end
      
      def attribute_prefix(type)
        "#{type}_"
      end
  end
end
