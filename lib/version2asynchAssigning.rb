module Asynchronize
  def self.included(base)
    base.class_eval do
      ##
      # Call to asynchronize a method.
      #
      #   Defines each of the passed methods on that module.
      #
      #   - The new methods wrap the old method within Thread.new.
      #   - Subsequent calls only add methods to the existing Module.
      #
      #   @param methods [Symbol] The methods to be asynchronized.
      #   @example To add any number of methods to be asynchronized.
      #   asynchronize :method1, :method2, :methodn
      #
      def self.asynchronize(*methods)
        # require 'pry'; binding.pry
        async_container = async_naming
        
        async_container.instance_eval do
          Asynchronize._define_methods_on_object(methods, self)
        end
      end
      
      ##
      # Creates and prepends a module named "<className> + Asynchronized"
      #
      #
      def async_naming
        module_name = self.name.split('::')[-1] + 'Asynchronized'
        if const_defined?(module_name) 
          async_container = const_get(module_name)
        else
          async_container = const_set(module_name, Module.new)
          prepend async_container
        end
      end
      
    end
  end

  ##
  # Defines an asynchronous wrapping method with the given name on an object.
  #
  #   Always defines each given method unless it is already defined on obj;
  #   in that case, it will continue to define the remainder of the methods.
  #
  #   @param methods [Array<Symbol>] The methods to be created.
  #   @param obj [Object] The object for the methods to be created on.
  #
  private
  def self._define_methods_on_object(methods, obj)
    methods.each do |method|
      next if obj.methods.include?(method)
      # obj.define_method(method, _build_method)
      obj.send(:define_method, method, _build_method)
    end
  end

  # Always builds the exact same proc. Placed into a named method for clarity.
  def self._build_method
    return Proc.new do |*args, &block|
      return Thread.new(args, block) do |targs, tblock|
        Thread.current[:return_value] = super(*targs)
        tblock.call(Thread.current[:return_value]) if tblock
      end
    end
  end
end