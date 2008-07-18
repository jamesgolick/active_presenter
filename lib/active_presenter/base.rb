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
      presented.keys.each do |type|
        if args[type].is_a?(presented[type])
          send("#{type}=", args[type])
        else
          send("#{type}=", presented[type].new(attributes_for(type, args).symbolize_keys))
        end
      end
    end
    
    protected
      def attributes_for(type, args)
        returning({}) do |a|
          a.merge(args[type]) if args[type].is_a?(Hash)
          
          args.each do |attribute, value|
            a[attribute.to_s.delete("#{type}_")] = value if attribute.to_s =~ /#{type}_/
          end
        end
      end
  end
end
