require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.map do |attr_name, value|
      "#{attr_name} = ?"
    end.join ' AND '

    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL

    results.map { |hash| self.new(hash) }
  end
end

class SQLObject
  extend Searchable
end
