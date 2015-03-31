require 'minitest/autorun'
require_relative '../lib/pca'


class TestPCA < MiniTest::Test

  def test_fit_transform
    d = get_data
    pca = PCA.new components: 1
    transformed = pca.fit_transform d
    assert_equal 1, transformed.size2

    expected = [
      -0.827970186, 
      1.77758033, 
      -0.992197494, 
      -0.274210416,
      -1.67580142, 
      -0.912949103, 
      0.0991094375, 
      1.14457216, 
      0.438046137, 
      1.22382056
    ]

    transformed.size1.times do |i|
      assert_in_delta expected[i], transformed[i]
    end
  end

  def test_inverse_transform
    d = get_data
    pca = PCA.new components: 1
    transformed = pca.fit_transform d
    inverse = pca.inverse_transform(transformed).to_a
    
    d.each_with_index do |row, i|
      row.each_with_index do |val, j|
        assert_in_delta val, inverse[i][j], 0.5 # close-ish
      end
    end
  end

private
  def get_data
    [
      [2.5, 2.4],
      [0.5, 0.7],
      [2.2, 2.9],
      [1.9, 2.2],
      [3.1, 3.0],
      [2.3, 2.7],
      [2.0, 1.6],
      [1.0, 1.1],
      [1.5, 1.6],
      [1.1, 0.9]
    ]
  end
end
