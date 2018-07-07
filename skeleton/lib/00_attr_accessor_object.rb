class AttrAccessorObject
  def self.my_attr_accessor(*names)
    
    names.each do |name|
      doc = <<-SQL
        def #{name}
          @#{name}
        end
        def #{name}=(value)
          @#{name} = value
        end
              
      SQL
      class_eval doc
      
    end
    # ...
  end
end
