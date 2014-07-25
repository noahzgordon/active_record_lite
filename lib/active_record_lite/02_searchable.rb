require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    Relation.new(:where, self, params)
  end

  def includes(other_table)
    Relation.new(:include, self, other_table)
  end

  def joins(relation)

  end
end

class SQLObject
  extend Searchable
end
