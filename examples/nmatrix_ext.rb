require 'nmatrix/nmatrix'

NMatrix.class_eval do

  def row(row_number, get_by = :copy)
    if row_numbers = get_row_or_col_index_array(row_number)
      out = NMatrix.new [row_numbers.length, cols], default_value, dtype: dtype, stype: stype

      row_numbers.each_with_index do |rownum, i|
        out[i, 0..-1] = self[rownum, 0..-1]
      end

      out
    else
      rank(0, row_number, get_by)
    end
  end

  def column(col_number, get_by = :copy)
    if col_numbers = get_row_or_col_index_array(col_number)
      out = NMatrix.new [rows, col_numbers.length], default_value, dtype: dtype, stype: stype

      col_numbers.each_with_index do |colnum, i|
        out[0..-1, i] = self[0..-1, colnum]
      end

      out
    else
      rank(1, col_number, get_by)
    end
  end

  alias :col :column

  private
    def get_row_or_col_index_array arg
      return unless arg.is_a?(Array) || arg.is_a?(NMatrix)
      out = arg.to_a.flatten
      out = booleans_to_indexes(out) unless out.first.is_a?(Integer)
      out
    end

    def booleans_to_indexes row_numbers
      row_numbers.map.with_index {|v, i| i if v}.compact
    end
end


# require 'pp'

# puts "Dense matrix:"

# d = NMatrix.indgen [3,3]

# pp d                        # => [ [0, 1, 2]   [3, 4, 5]   [6, 7, 8] ]
# pp d.row 0                  # => [ [0, 1, 2] ]
# pp d.row [0,2]              # => [ [0, 1, 2]   [6, 7, 8] ]
# pp d.row d.sum(1) > 6       # => [ [3, 4, 5]   [6, 7, 8] ]
# pp d.col 0                  # => [ [0]   [3]   [6] ]
# pp d.col [0,2]              # => [ [0, 2]   [3, 5]   [6, 8] ]
# pp d.col d.sum(0) > 12      # => [ [2]   [5]   [8] ]
# pp d.row([0,2]).col([0,2])  # => [ [0, 2]   [6, 8] ]


# puts "\nSparse matrix:"

# y = NMatrix.diagonal([1,2,3], stype: :yale)

# pp y                        # => [ [1, 0, 0]   [0, 2, 0]   [0, 0, 3] ]
# pp y.row 0                  # => [ [1, 0, 0] ]
# pp y.row [0,2]              # => [ [1, 0, 0]   [0, 0, 3] ]
# pp y.row y.sum(1) > 2       # => [ [0, 0, 3] ]
# pp y.col 0                  # => [ [1]   [0]   [0 ]
# pp y.col [0,2]              # => [ [1, 0]   [0, 0]   [0, 3] ]
# pp y.col y.sum(0) > 2       # => [ [0]   [0]   [3] ]
# pp y.row([0,2]).col([0,2])  # => [ [1, 0]   [0, 3] ]

