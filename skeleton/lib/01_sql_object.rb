require_relative 'db_connection'
require 'active_support/inflector'
 
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.
require 'byebug'

class SQLObject
  def self.columns
    return @columns if @columns
    col = DBConnection.execute2(<<-SQL).first
    SELECT
    *
    FROM
    #{self.table_name}
    
    SQL
    col.map!(&:to_sym)
    @columns = col
  end


  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        self.attributes[col]
      end
      define_method ("#{col}=") do |value|
        self.attributes[col] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = "#{table_name}s.downcase"
  end

  def self.table_name
    "#{self.to_s.downcase}s"
  end

  def self.all
    heredoc = DBConnection.execute2(<<-SQL)
      SELECT
      *
      FROM #{table_name}
    SQL
    self.parse_all(heredoc)
  end

  def self.parse_all(results)
    results.shift if results.first.is_a?(Array)
    arr = []
    results.each do |result|
      next unless result.is_a? Hash
      arr << self.new(result)
    end
    arr
  end

  def self.find(id)
    self.all.find{ |el| el.id == id}
  end

  def initialize(params = {})
    # byebug
    params.each do |k,v|
      raise "unknown attribute '#{k}'" unless self.class.columns.include?(k.to_sym)
      self.send("#{k.to_sym}=", v)
    end
  end

  def attributes
    @attributes ||= {}
    # ...
  end

  def attribute_values
    @attributes.values
  end

  def insert
    
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
