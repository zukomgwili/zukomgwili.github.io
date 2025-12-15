# Compatibility shim: Ruby 3.4 removed Object#tainted?/taint APIs used by some
# libraries (e.g., older Liquid). Provide a safe no-op implementation so
# templates relying on tainted? continue to work under newer Rubies.

unless ''.respond_to?(:tainted?)
  class Object
    # In modern Ruby versions tainting APIs were removed. Provide a safe no-op
    # implementation to preserve compatibility with libraries calling #tainted?
    def tainted?
      false
    end
  end
end
