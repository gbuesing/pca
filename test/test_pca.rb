require 'bundler/setup'
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

  def test_fit_transform_with_scale_data
    d = get_data
    pca = PCA.new components: 1, scale_data: true
    transformed = pca.fit_transform d

    expected = [
      -1.03068,
      2.19045,
      -1.17819,
      -0.32329,
      -2.0722,
      -1.10117,
      0.08785,
      1.40605,
      0.53812,
      1.48306
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

  def test_inverse_transform_with_scale_data
    d = get_data
    pca = PCA.new components: 1, scale_data: true
    transformed = pca.fit_transform d
    inverse = pca.inverse_transform(transformed).to_a
    
    d.each_with_index do |row, i|
      row.each_with_index do |val, j|
        assert_in_delta val, inverse[i][j], 0.5 # close-ish
      end
    end
  end

  def test_restore
    d = get_data
    pca = PCA.new scale_data: true
    transformed = pca.fit_transform d
    
    # save and restore components, mean and std
    serialize = { components: pca.components.to_a, mean: pca.mean, std: pca.std }
    saved = Marshal.load Marshal.dump serialize
    
    pca2 = PCA.new components: 1, scale_data: true
    pca2.components = saved[:components]
    pca2.mean       = saved[:mean]
    pca2.std        = saved[:std]
    transformed2 = pca2.transform d

    assert_equal 2, transformed.size2 
    assert_equal 1, transformed2.size2 

    # assert first principal component from both transforms is the same:
    d.length.times do |i|
      assert_in_delta transformed.row(i)[0], transformed2.row(i)[0]
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
