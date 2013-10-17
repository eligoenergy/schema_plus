module SchemaPlus
  module ActiveRecord
    module ConnectionAdapters
      class CheckConstraintDefinition

        attr_accessor :table_name, :column_name, :check

        def initialize(table_name, column_name, check)
          self.table_name = table_name
          self.column_name = column_name
          self.check = check
        end

        # Dumps a definition of foreign key.
        def to_dump(opts={})
          dump = ""
          dump << "add_column_check_constraint #{table_name.to_s}, #{column_name.to_s}" unless opts[:inline]
          dump << ", check: #{check.inspect}"
          dump << "\n"
          dump
        end

        def to_sql()
          check_expression = if check.is_a? Array
            "#{::ActiveRecord::Base.connection.quote_column_name(column_name)} in (#{check.map { |c| ::ActiveRecord::Base.connection.quote(c) }.join(", ")})"
          elsif check.is_a? String
            check
          else
            raise "Invalid column '#{column_name}' check constraint in table '#{table_name}'."
          end

          " check (#{check_expression})"
        end

      end
    end
  end
end
