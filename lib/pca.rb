require 'nmatrix/nmatrix'
require 'nmatrix/lapack_plugin'
# require 'nmatrix/atlas'
# require 'nmatrix/lapacke'

class PCA
  attr_reader :components, :singular_values, :explained_variance, :explained_variance_ratio
  attr_accessor :mean, :std

  def initialize opts = {}
    @n_components = opts[:components]
    @scale_data = opts[:scale_data]
  end

  def fit x
    x = prepare_data x
    _fit x
    self
  end

  def transform x
    x = prepare_data x, use_saved_mean_and_std: true
    _transform x
  end

  def fit_transform x
    x = prepare_data x
    _fit x
    _transform x
  end

  def inverse_transform x
    x = ensure_matrix x
    xit = x.dot @components
    undo_scale(xit) if @scale_data
    undo_mean_normalize xit
    xit
  end

  def components= c
    c = ensure_matrix(c)
    @components = slice_n(c.transpose).transpose
  end

  private
    def prepare_data x, opts = {}
      x = ensure_matrix x
      @mean = calculate_mean(x) unless opts[:use_saved_mean_and_std]
      mean_normalize x
      if @scale_data
        @std = calculate_std(x) unless opts[:use_saved_mean_and_std]
        scale(x)
      end
      x
    end

    def _fit x
      covariance_matrix = (x.transpose.dot x) / x.rows
      covariance_matrix = x.cov
      u, s, vt = covariance_matrix.gesvd
      
      ev = s.transpose**2 / x.rows
      evr = ev / ev.sum(1)[0]

      @explained_variance = slice_n ev
      @explained_variance_ratio = slice_n evr
      @singular_values = slice_n s
      @components = slice_n(u).transpose
    end

    def _transform x
      x.dot @components.transpose
    end

    def ensure_matrix x
      case x
      when NMatrix
        x
      else
        x.to_nm(nil, :float64)
      end
    end

    def calculate_mean x
      x.cols.times.map {|col| x.col(col).mean[0] }
    end

    def mean_normalize x
      x.cols.times {|col| x[0..-1,col] -= @mean[col] }
    end

    def undo_mean_normalize x
      x.cols.times {|col| x[0..-1,col] += @mean[col] }
    end

    def calculate_std x
      x.cols.times.map {|col| x.col(col).std[0] }
    end

    def scale x
      x.cols.times {|col| x[0..-1,col] /= @std[col] }
    end

    def undo_scale x
      x.cols.times {|col| x[0..-1,col] *= @std[col] }
    end

    def slice_n x
      return x unless @n_components
      return x if @n_components >= x.cols
      x[0..-1, 0..(@n_components - 1)]
    end
end
