class Relation
  def initialize(method_call, class_type, params = {})
    @class = class_type
    @conditions = {}
    @joined_relations = []

    if method_call = :where
      self.where(params)
    elsif method_call = :include
      self.include(params)
    elsif method_call = :join
      @join_tables << table
    end
  end

  def inspect
    p "<#{@class}: #{@conditions}>"
  end

  def where(params)
    params.each do |attr, value|
      @conditions["#{attr}".to_s] = value
    end
  end

  def includes(relation) # include other relation also??
    @included_relations << relation
  end

  def joins(relation) # join to other relation also??
    @joined_relations << relation
  end

  def load
    where_conditions = []

    @conditions.each do |attr, value|
      where_conditions << "#{attr} = '#{value}'"
    end

    where_clause = where_conditions.join(' AND ')

    # could be bad to interpolate like this, but the data is user-supplied
    # no matter what. Look into another way to improve security. Perhaps raise
    # an error if the attr does not exist and pass values in as arguments.
    query = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{@class.table_name}
      WHERE
        #{where_clause}
    SQL

    query.map { |obj| @class.new(obj) }
  end
end