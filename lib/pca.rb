require 'gsl'

class PCA
  attr_reader :components, :singular_values, :mean, :explained_variance, :explained_variance_ratio

  def initialize opts = {}
    @n_components = opts[:components]
  end

  def fit x
    x = prepare_data x
    _fit x
    self
  end

  def transform x
    x = prepare_data x, use_saved_mean: true
    _transform x
  end

  def fit_transform x
    x = prepare_data x
    _fit x
    _transform x
  end

  def inverse_transform x
    x = ensure_matrix x
    out = x * @components.transpose
    out.size2.times {|col| out.col(col).add! @mean[col] }
    out
  end

  private
    def prepare_data x, opts = {}
      x = ensure_matrix x
      @mean = calculate_mean(x) unless opts[:use_saved_mean]
      mean_normalize x
      x
    end

    def _fit x
      covariance_matrix = (x.transpose * x) / x.size1
      u, v, s = covariance_matrix.SV_decomp
      @components = slice_n u
      @singular_values = slice_n s
      @explained_variance = @singular_values**2 / x.size1
      @explained_variance_ratio = @explained_variance / @explained_variance.sum
    end

    def _transform x
      x * @components
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
