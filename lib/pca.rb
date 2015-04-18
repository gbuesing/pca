require 'gsl'

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
    xit = x * @components
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
      covariance_matrix = (x.transpose * x) / x.size1
      u, v, s = covariance_matrix.SV_decomp
      
      ev = s**2 / x.size1
      evr = ev / ev.sum

      @explained_variance = slice_n ev
      @explained_variance_ratio = slice_n evr
      @singular_values = slice_n s
      @components = slice_n(u).transpose
    end

    def _transform x
      x * @components.transpose
    end

    def ensure_matrix x
      case x
      when GSL::Matrix
        x
      when Array
        GSL::Matrix[*x]
      else
        x.to_gm
      end
    end

    def calculate_mean x
      x.size2.times.map {|col| x.col(col).mean }
    end

    def mean_normalize x
      x.size2.times {|col| x.col(col).sub! @mean[col] }
    end

    def undo_mean_normalize x
      x.size2.times {|col| x.col(col).add! @mean[col] }
    end

    def calculate_std x
      x.size2.times.map {|col| x.col(col).sd }
    end

    def scale x
      x.size2.times {|col| x.col(col).div! @std[col] }
    end

    def undo_scale x
      x.size2.times {|col| x.col(col).mul! @std[col] }
    end

    def slice_n x
      return x unless @n_components
      case x
      when GSL::Matrix
        x.submatrix(nil, 0, @n_components)
      when GSL::Vector
        x[0, @n_components]
      end
    end
end
