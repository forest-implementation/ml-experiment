# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rubystats` gem.
# Please instead update this file by running `bin/tapioca gem rubystats`.

# source://rubystats//lib/rubystats.rb#37
Beta = Rubystats::BetaDistribution

# source://rubystats//lib/rubystats.rb#22
BetaDistribution = Rubystats::BetaDistribution

# source://rubystats//lib/rubystats.rb#35
Binomial = Rubystats::BinomialDistribution

# source://rubystats//lib/rubystats.rb#20
BinomialDistribution = Rubystats::BinomialDistribution

# source://rubystats//lib/rubystats.rb#42
Cauchy = Rubystats::CauchyDistribution

# source://rubystats//lib/rubystats.rb#29
CauchyDistribution = Rubystats::CauchyDistribution

# source://rubystats//lib/rubystats.rb#38
Exponential = Rubystats::ExponentialDistribution

# source://rubystats//lib/rubystats.rb#24
ExponentialDistribution = Rubystats::ExponentialDistribution

# source://rubystats//lib/rubystats.rb#23
FishersExactTest = Rubystats::FishersExactTest

# source://rubystats//lib/rubystats.rb#43
Gamma = Rubystats::GammaDistribution

# source://rubystats//lib/rubystats.rb#30
GammaDistribution = Rubystats::GammaDistribution

# source://rubystats//lib/rubystats.rb#40
Lognormal = Rubystats::LognormalDistribution

# source://rubystats//lib/rubystats.rb#26
LognormalDistribution = Rubystats::LognormalDistribution

# source://rubystats//lib/rubystats.rb#44
MultivariateNormal = Rubystats::MultivariateNormalDistribution

# source://rubystats//lib/rubystats.rb#31
MultivariateNormalDistribution = Rubystats::MultivariateNormalDistribution

# short-hand notation
#
# source://rubystats//lib/rubystats.rb#34
Normal = Rubystats::NormalDistribution

# source://rubystats//lib/rubystats.rb#19
NormalDistribution = Rubystats::NormalDistribution

# source://rubystats//lib/rubystats.rb#36
Poisson = Rubystats::PoissonDistribution

# source://rubystats//lib/rubystats.rb#21
PoissonDistribution = Rubystats::PoissonDistribution

# This class provides an object for encapsulating uniform distributions
#
# source://rubystats//lib/rubystats/modules.rb#1
module Rubystats; end

# source://rubystats//lib/rubystats/beta_distribution.rb#4
class Rubystats::BetaDistribution < ::Rubystats::ProbabilityDistribution
  # dgr_p = degrees of freedom p
  # dgr_q = degrees of freedom q
  #
  # @return [BetaDistribution] a new instance of BetaDistribution
  #
  # source://rubystats//lib/rubystats/beta_distribution.rb#11
  def initialize(dgr_p, dgr_q); end

  # source://rubystats//lib/rubystats/beta_distribution.rb#51
  def cdf(x); end

  # source://rubystats//lib/rubystats/beta_distribution.rb#66
  def icdf(prob); end

  # source://rubystats//lib/rubystats/beta_distribution.rb#19
  def mean; end

  # Returns the value of attribute p.
  #
  # source://rubystats//lib/rubystats/beta_distribution.rb#7
  def p; end

  # source://rubystats//lib/rubystats/beta_distribution.rb#27
  def pdf(x); end

  # Returns the value of attribute q.
  #
  # source://rubystats//lib/rubystats/beta_distribution.rb#7
  def q; end

  # source://rubystats//lib/rubystats/beta_distribution.rb#88
  def rng; end

  # source://rubystats//lib/rubystats/beta_distribution.rb#23
  def standard_deviation; end
end

# source://rubystats//lib/rubystats/binomial_distribution.rb#8
class Rubystats::BinomialDistribution < ::Rubystats::ProbabilityDistribution
  include ::Rubystats::MakeDiscrete

  # Constructs a binomial distribution
  #
  # @return [BinomialDistribution] a new instance of BinomialDistribution
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#18
  def initialize(trials, prob); end

  # returns the mean
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#40
  def get_mean; end

  # returns the probability
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#35
  def get_probability_parameter; end

  # returns the number of trials
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#30
  def get_trials_parameter; end

  # returns the variance
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#45
  def get_variance; end

  # Returns the value of attribute n.
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#14
  def n; end

  # Sets the attribute n
  #
  # @param value the value to set the attribute n to.
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#15
  def n=(_arg0); end

  # Returns the value of attribute p.
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#14
  def p; end

  # Sets the attribute p
  #
  # @param value the value to set the attribute p to.
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#15
  def p=(_arg0); end

  private

  # Private shared function for getting cumulant for particular x
  # param _x should be integer-valued
  # returns the probability that a stochastic variable x is less than _x
  # i.e P(x < _x)
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#67
  def get_cdf(_x); end

  # Inverse of the cumulative binomial distribution function
  # returns the value X for which P(x < _x).
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#78
  def get_icdf(prob); end

  # Probability density function of a binomial distribution (equivalent
  # to R dbinom function).
  # _x should be an integer
  # returns the probability that a stochastic variable x has the value _x,
  # i.e. P(x = _x)
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#58
  def get_pdf(x); end

  # Private binomial RNG function
  # Variation of Luc Devroye's "Second Waiting Time Method"
  # on page 522 of his text "Non-Uniform Random Variate Generation."
  # There are faster methods based on acceptance/rejection techniques,
  # but they are substantially more complex to implement.
  #
  # source://rubystats//lib/rubystats/binomial_distribution.rb#94
  def get_rng; end
end

# source://rubystats//lib/rubystats/cauchy_distribution.rb#3
class Rubystats::CauchyDistribution < ::Rubystats::ProbabilityDistribution
  # @return [CauchyDistribution] a new instance of CauchyDistribution
  #
  # source://rubystats//lib/rubystats/cauchy_distribution.rb#5
  def initialize(location = T.unsafe(nil), scale = T.unsafe(nil)); end

  private

  # Private method to obtain single CDF value.
  # param x should be greater than 0
  # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
  #
  # source://rubystats//lib/rubystats/cauchy_distribution.rb#33
  def get_cdf(x); end

  # Private method to obtain single inverse CDF value.
  # return the value X for which P(x<X).
  #
  # source://rubystats//lib/rubystats/cauchy_distribution.rb#39
  def get_icdf(p); end

  # source://rubystats//lib/rubystats/cauchy_distribution.rb#15
  def get_mean; end

  # Private method to obtain single PDF value.
  # x should be greater than 0
  # returns the probability that a stochastic variable x has the value X, i.e. P(x=X).
  #
  # source://rubystats//lib/rubystats/cauchy_distribution.rb#26
  def get_pdf(x); end

  # Private method to obtain single RNG value.
  #
  # source://rubystats//lib/rubystats/cauchy_distribution.rb#45
  def get_rng; end

  # source://rubystats//lib/rubystats/cauchy_distribution.rb#19
  def get_variance; end
end

# source://rubystats//lib/rubystats/exponential_distribution.rb#8
class Rubystats::ExponentialDistribution < ::Rubystats::ProbabilityDistribution
  # @return [ExponentialDistribution] a new instance of ExponentialDistribution
  #
  # source://rubystats//lib/rubystats/exponential_distribution.rb#13
  def initialize(decay = T.unsafe(nil)); end

  private

  # Private method to obtain single CDF value.
  # param x should be greater than 0
  # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
  #
  # source://rubystats//lib/rubystats/exponential_distribution.rb#41
  def get_cdf(x); end

  # Private method to obtain single inverse CDF value.
  # return the value X for which P(x<X).
  #
  # source://rubystats//lib/rubystats/exponential_distribution.rb#48
  def get_icdf(p); end

  # source://rubystats//lib/rubystats/exponential_distribution.rb#22
  def get_mean; end

  # Private method to obtain single PDF value.
  # x should be greater than 0
  # returns the probability that a stochastic variable x has the value X, i.e. P(x=X).
  #
  # source://rubystats//lib/rubystats/exponential_distribution.rb#33
  def get_pdf(x); end

  # Private method to obtain single RNG value.
  # return exponential random deviate
  #
  # source://rubystats//lib/rubystats/exponential_distribution.rb#55
  def get_rng; end

  # source://rubystats//lib/rubystats/exponential_distribution.rb#26
  def get_variance; end
end

# source://rubystats//lib/rubystats/modules.rb#3
module Rubystats::ExtraMath
  # source://rubystats//lib/rubystats/modules.rb#4
  def binomial(n, k); end
end

# source://rubystats//lib/rubystats/fishers_exact_test.rb#8
class Rubystats::FishersExactTest
  # @return [FishersExactTest] a new instance of FishersExactTest
  #
  # source://rubystats//lib/rubystats/fishers_exact_test.rb#10
  def initialize; end

  # source://rubystats//lib/rubystats/fishers_exact_test.rb#154
  def calculate(n11_, n12_, n21_, n22_); end

  # source://rubystats//lib/rubystats/fishers_exact_test.rb#91
  def exact(n11, n1_, n_1, n); end

  # source://rubystats//lib/rubystats/fishers_exact_test.rb#62
  def hyper(n11); end

  # source://rubystats//lib/rubystats/fishers_exact_test.rb#66
  def hyper0(n11i, n1_i, n_1i, ni); end

  # source://rubystats//lib/rubystats/fishers_exact_test.rb#58
  def hyper_323(n11, n1_, n_1, n); end

  # source://rubystats//lib/rubystats/fishers_exact_test.rb#54
  def lnbico(n, k); end

  # source://rubystats//lib/rubystats/fishers_exact_test.rb#46
  def lnfact(n); end

  # Reference: "Lanczos, C. 'A precision approximation
  # of the gamma function', J. SIAM Numer. Anal., B, 1, 86-96, 1964."
  # Translation of  Alan Miller's FORTRAN-implementation
  # See http://lib.stat.cmu.edu/apstat/245
  #
  # source://rubystats//lib/rubystats/fishers_exact_test.rb#31
  def lngamm(z); end
end

# source://rubystats//lib/rubystats/gamma_distribution.rb#4
class Rubystats::GammaDistribution < ::Rubystats::ProbabilityDistribution
  # @return [GammaDistribution] a new instance of GammaDistribution
  #
  # source://rubystats//lib/rubystats/gamma_distribution.rb#8
  def initialize(shape = T.unsafe(nil), scale = T.unsafe(nil)); end

  private

  # Private method to obtain single CDF value.
  # param x should be greater than 0
  # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
  #
  # source://rubystats//lib/rubystats/gamma_distribution.rb#37
  def get_cdf(x); end

  # Private method to obtain single inverse CDF value.
  # return the value X for which P(x<X).
  #
  # source://rubystats//lib/rubystats/gamma_distribution.rb#44
  def get_icdf(p); end

  # source://rubystats//lib/rubystats/gamma_distribution.rb#18
  def get_mean; end

  # Private method to obtain single PDF value.
  # x should be greater than or equal to 0.0
  # returns the probability that a stochastic variable x has the value X, i.e. P(x=X).
  #
  # source://rubystats//lib/rubystats/gamma_distribution.rb#29
  def get_pdf(x); end

  # Private method to obtain single RNG value.
  # Generate gamma random variate with
  # Marsaglia's squeeze method.
  #
  # source://rubystats//lib/rubystats/gamma_distribution.rb#52
  def get_rng; end

  # source://rubystats//lib/rubystats/gamma_distribution.rb#22
  def get_variance; end
end

# source://rubystats//lib/rubystats/lognormal_distribution.rb#5
class Rubystats::LognormalDistribution < ::Rubystats::ProbabilityDistribution
  # Constructs a lognormal distribution.
  #
  # @return [LognormalDistribution] a new instance of LognormalDistribution
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#9
  def initialize(meanlog = T.unsafe(nil), sdlog = T.unsafe(nil)); end

  # Returns the mean of the distribution
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#17
  def get_mean; end

  # Returns the standard deviation of the distribution
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#22
  def get_standard_deviation; end

  # Returns the variance of the distribution
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#27
  def get_variance; end

  private

  # Obtain single CDF value
  # Returns the probability that a stochastic variable x is less than X,
  # i.e. P(x<X)
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#44
  def get_cdf(x); end

  # Obtain single inverse CDF value.
  # returns the value X for which P(x&lt;X).
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#50
  def get_icdf(p); end

  # Obtain single PDF value
  # Returns the probability that a stochastic variable x has the value X,
  # i.e. P(x=X)
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#36
  def get_pdf(x); end

  # returns single random number from log normal
  #
  # source://rubystats//lib/rubystats/lognormal_distribution.rb#55
  def get_rng; end
end

# source://rubystats//lib/rubystats/modules.rb#9
module Rubystats::MakeDiscrete
  # source://rubystats//lib/rubystats/modules.rb#10
  def pmf(x); end
end

# source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#6
module Rubystats::MultivariateDistribution
  # override probability_distribution pdf function to work with multivariate input variables
  #
  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#8
  def pdf(x); end
end

# source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#12
class Rubystats::MultivariateNormalDistribution < ::Rubystats::ProbabilityDistribution
  include ::Rubystats::MultivariateDistribution

  # @return [MultivariateNormalDistribution] a new instance of MultivariateNormalDistribution
  #
  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#16
  def initialize(mu = T.unsafe(nil), sigma = T.unsafe(nil)); end

  private

  # Private method to obtain single CDF value.
  # param x should be greater than 0
  # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
  #
  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#54
  def get_cdf(x); end

  # Private method to obtain single inverse CDF value.
  # return the value X for which P(x<X).
  #
  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#60
  def get_icdf(p); end

  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#35
  def get_mean; end

  # Private method to obtain single PDF value.
  # x should be greater than 0
  # returns the probability that a stochastic variable x has the value X, i.e. P(x=X).
  #
  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#46
  def get_pdf(x); end

  # Private method to obtain single RNG value.
  #
  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#66
  def get_rng; end

  # source://rubystats//lib/rubystats/multivariate_normal_distribution.rb#39
  def get_variance; end
end

# source://rubystats//lib/rubystats/normal_distribution.rb#8
class Rubystats::NormalDistribution < ::Rubystats::ProbabilityDistribution
  # Constructs a normal distribution (defaults to zero mean and
  # unity variance).
  #
  # @return [NormalDistribution] a new instance of NormalDistribution
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#13
  def initialize(mu = T.unsafe(nil), sigma = T.unsafe(nil)); end

  # Returns the mean of the distribution
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#26
  def get_mean; end

  # Returns the standard deviation of the distribution
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#31
  def get_standard_deviation; end

  # Returns the variance of the distribution
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#36
  def get_variance; end

  private

  # Obtain single CDF value
  # Returns the probability that a stochastic variable x is less than X,
  # i.e. P(x<X)
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#52
  def get_cdf(x); end

  # Obtain single inverse CDF value.
  # returns the value X for which P(x&lt;X).
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#58
  def get_icdf(p); end

  # Obtain single PDF value
  # Returns the probability that a stochastic variable x has the value X,
  # i.e. P(x=X)
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#45
  def get_pdf(x); end

  # Uses the polar form of the Box-Muller transformation which
  # is both faster and more robust numerically than basic Box-Muller
  # transform. To speed up repeated RNG computations, two random values
  # are computed after the while loop and the second one is saved and
  # directly used if the method is called again.
  # see http://www.taygeta.com/random/gaussian.html
  # returns single normal deviate
  #
  # source://rubystats//lib/rubystats/normal_distribution.rb#94
  def get_rng; end
end

# source://rubystats//lib/rubystats/modules.rb#15
module Rubystats::NumericalConstants; end

# source://rubystats//lib/rubystats/modules.rb#17
Rubystats::NumericalConstants::EPS = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#27
Rubystats::NumericalConstants::GAMMA = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#20
Rubystats::NumericalConstants::GAMMA_X_MAX_VALUE = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#28
Rubystats::NumericalConstants::GOLDEN_RATIO = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#19
Rubystats::NumericalConstants::LOG_GAMMA_X_MAX_VALUE = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#16
Rubystats::NumericalConstants::MAX_FLOAT = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#24
Rubystats::NumericalConstants::MAX_ITERATIONS = T.let(T.unsafe(nil), Integer)

# source://rubystats//lib/rubystats/modules.rb#18
Rubystats::NumericalConstants::MAX_VALUE = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#25
Rubystats::NumericalConstants::PRECISION = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#22
Rubystats::NumericalConstants::SQRT2 = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#21
Rubystats::NumericalConstants::SQRT2PI = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#26
Rubystats::NumericalConstants::TWO_PI = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/modules.rb#23
Rubystats::NumericalConstants::XMININ = T.let(T.unsafe(nil), Float)

# source://rubystats//lib/rubystats/poisson_distribution.rb#4
class Rubystats::PoissonDistribution < ::Rubystats::ProbabilityDistribution
  include ::Rubystats::MakeDiscrete

  # Constructs a Poisson distribution
  #
  # @return [PoissonDistribution] a new instance of PoissonDistribution
  #
  # source://rubystats//lib/rubystats/poisson_distribution.rb#8
  def initialize(rate); end

  # returns the mean
  #
  # source://rubystats//lib/rubystats/poisson_distribution.rb#16
  def get_mean; end

  # returns the variance
  #
  # source://rubystats//lib/rubystats/poisson_distribution.rb#21
  def get_variance; end

  private

  # Private shared function for getting cumulant for particular x
  # param k should be integer-valued
  # returns the probability that a stochastic variable x is less than _x
  # i.e P(x < k)
  #
  # @raise [ArgumentError]
  #
  # source://rubystats//lib/rubystats/poisson_distribution.rb#42
  def get_cdf(k); end

  # Inverse of the cumulative Poisson distribution function
  #
  # source://rubystats//lib/rubystats/poisson_distribution.rb#52
  def get_icdf(prob); end

  # Probability mass function of a Poisson distribution .
  # k should be an integer
  # returns the probability that a stochastic variable x has the value k,
  # i.e. P(x = k)
  #
  # @raise [ArgumentError]
  #
  # source://rubystats//lib/rubystats/poisson_distribution.rb#33
  def get_pdf(k); end

  # Private Poisson RNG function
  # Poisson generator based upon the inversion by sequential search
  #
  # source://rubystats//lib/rubystats/poisson_distribution.rb#65
  def get_rng; end
end

# The ProbabilityDistribution superclass provides an object
# for encapsulating probability distributions.
#
# Author: Jaco van Kooten
# Author: Mark Hale
# Author: Paul Meagher
# Author: Jesus Castagnetto
# Author: Bryan Donovan (port from PHPmath to Ruby)
#
# source://rubystats//lib/rubystats/probability_distribution.rb#13
class Rubystats::ProbabilityDistribution
  include ::Rubystats::NumericalConstants
  include ::Rubystats::SpecialMath
  include ::Rubystats::ExtraMath

  # @return [ProbabilityDistribution] a new instance of ProbabilityDistribution
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#18
  def initialize; end

  # Cummulative distribution function
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#45
  def cdf(x); end

  # check that variable is between lo and hi limits.
  # lo default is 0.0 and hi default is 1.0
  #
  # @raise [ArgumentError]
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#122
  def check_range(x, lo = T.unsafe(nil), hi = T.unsafe(nil)); end

  # source://rubystats//lib/rubystats/probability_distribution.rb#137
  def find_root(prob, guess, x_lo, x_hi); end

  # source://rubystats//lib/rubystats/probability_distribution.rb#129
  def get_factorial(n); end

  # Inverse CDF
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#58
  def icdf(p); end

  # returns the distribution mean
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#22
  def mean; end

  # Probability density function
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#32
  def pdf(x); end

  # Returns random number(s) using subclass's get_rng method
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#71
  def rng(n = T.unsafe(nil)); end

  # returns distribution variance
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#27
  def variance; end

  private

  # private method to be implemented in subclass
  # returns the probability that a stochastic variable x is less then X, i.e. P(x&lt;X).
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#104
  def get_cdf(x); end

  # private method to be implemented in subclass
  # returns the value X for which P(x&lt;X).
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#109
  def get_icdf(p); end

  # private method to be implemented in subclass
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#90
  def get_mean; end

  # private method to be implemented in subclass
  # returns the probability that a stochastic variable x has the value X, i.e. P(x=X).
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#99
  def get_pdf(x); end

  # private method to be implemented in subclass
  # Random number generator
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#114
  def get_rng; end

  # private method to be implemented in subclass
  #
  # source://rubystats//lib/rubystats/probability_distribution.rb#94
  def get_variance; end
end

# Ruby port of SpecialMath.php from PHPMath, which is
# a port of JSci methods found in SpecialMath.java.
#
#
# Ruby port by Bryan Donovan bryandonovan.com
#
# Author:: Jaco van Kooten
# Author:: Paul Meagher
# Author:: Bryan Donovan
#
# source://rubystats//lib/rubystats/modules.rb#41
module Rubystats::SpecialMath
  include ::Rubystats::NumericalConstants

  # Beta function.
  #
  # Author:: Jaco van Kooten
  #
  # source://rubystats//lib/rubystats/modules.rb#436
  def beta(p, q); end

  # Evaluates of continued fraction part of incomplete beta function.
  # Based on an idea from Numerical Recipes (W.H. Press et al, 1992).
  # Author:: Jaco van Kooten
  #
  # source://rubystats//lib/rubystats/modules.rb#474
  def beta_fraction(x, p, q); end

  # Complementary error function.
  # Based on C-code for the error function developed at Sun Microsystems.
  # author Jaco van Kooten
  #
  # source://rubystats//lib/rubystats/modules.rb#699
  def complementary_error(x); end

  # Error function.
  # Based on C-code for the error function developed at Sun Microsystems.
  # Author:: Jaco van Kooten
  #
  # source://rubystats//lib/rubystats/modules.rb#629
  def error(x); end

  # TODO test this
  #
  # source://rubystats//lib/rubystats/modules.rb#215
  def gamma(_x); end

  # Author:: Jaco van Kooten
  #
  # source://rubystats//lib/rubystats/modules.rb#405
  def gamma_fraction(a, x); end

  # Author:: Jaco van Kooten
  #
  # source://rubystats//lib/rubystats/modules.rb#389
  def gamma_series_expansion(a, x); end

  # Incomplete Beta function.
  #
  # Author:: Jaco van Kooten
  # Author:: Paul Meagher
  #
  #  The computation is based on formulas from Numerical Recipes,
  #  Chapter 6.4 (W.H. Press et al, 1992).
  #
  # source://rubystats//lib/rubystats/modules.rb#452
  def incomplete_beta(x, p, q); end

  # Incomplete Gamma function.
  # The computation is based on approximations presented in
  # Numerical Recipes, Chapter 6.2 (W.H. Press et al, 1992).
  #
  # @author Jaco van Kooten
  # @param a require a>=0
  # @param x require x>=0
  # @return 0 if x<0, a<=0 or a>2.55E305 to avoid errors and over/underflow
  #
  # source://rubystats//lib/rubystats/modules.rb#378
  def incomplete_gamma(a, x); end

  # source://rubystats//lib/rubystats/modules.rb#54
  def log_beta(p, q); end

  # Returns the value of attribute log_beta_cache_p.
  #
  # source://rubystats//lib/rubystats/modules.rb#45
  def log_beta_cache_p; end

  # Returns the value of attribute log_beta_cache_q.
  #
  # source://rubystats//lib/rubystats/modules.rb#45
  def log_beta_cache_q; end

  # Returns the value of attribute log_beta_cache_res.
  #
  # source://rubystats//lib/rubystats/modules.rb#45
  def log_beta_cache_res; end

  # source://rubystats//lib/rubystats/modules.rb#238
  def log_gamma(x); end

  # Returns the value of attribute log_gamma_cache_res.
  #
  # source://rubystats//lib/rubystats/modules.rb#45
  def log_gamma_cache_res; end

  # Returns the value of attribute log_gamma_cache_x.
  #
  # source://rubystats//lib/rubystats/modules.rb#45
  def log_gamma_cache_x; end

  # Gamma function.
  # Based on public domain NETLIB (Fortran) code by W. J. Cody and L. Stoltz<BR>
  # Applied Mathematics Division<BR>
  # Argonne National Laboratory<BR>
  # Argonne, IL 60439<BR>
  # <P>
  # References:
  # <OL>
  # <LI>"An Overview of Software Development for Special Functions", W. J. Cody, Lecture Notes in Mathematics, 506, Numerical Analysis Dundee, 1975, G. A. Watson (ed.), Springer Verlag, Berlin, 1976.
  # <LI>Computer Approximations, Hart, Et. Al., Wiley and sons, New York, 1968.
  # </OL></P><P>
  # From the original documentation:
  # </P><P>
  # This routine calculates the Gamma function for a real argument X.
  # Computation is based on an algorithm outlined in reference 1.
  # The program uses rational functions that approximate the Gamma
  # function to at least 20 significant decimal digits.  Coefficients
  # for the approximation over the interval (1,2) are unpublished.
  # Those for the approximation for X .GE. 12 are from reference 2.
  # The accuracy achieved depends on the arithmetic system, the
  # compiler, the intrinsic functions, and proper selection of the
  # machine-dependent constants.
  # </P><P>
  # Error returns:<BR>
  # The program returns the value XINF for singularities or when overflow would occur.
  # The computation is believed to be free of underflow and overflow.
  # </P>
  # Author:: Jaco van Kooten
  #
  # source://rubystats//lib/rubystats/modules.rb#96
  def orig_gamma(x); end
end

# source://rubystats//lib/rubystats/student_t_distribution.rb#5
class Rubystats::StudentTDistribution < ::Rubystats::ProbabilityDistribution
  # Constructs a student t distribution.
  #
  # @return [StudentTDistribution] a new instance of StudentTDistribution
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#9
  def initialize(degree_of_freedom = T.unsafe(nil)); end

  # Returns the mean of the distribution
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#17
  def get_mean; end

  # Returns the standard deviation of the distribution
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#22
  def get_standard_deviation; end

  # Returns the variance of the distribution
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#27
  def get_variance; end

  private

  # Obtain single CDF value
  # Returns the probability that a stochastic variable x is less than X,
  # i.e. P(x<X)
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#43
  def get_cdf(x); end

  # Obtain single inverse CDF value.
  # returns the value X for which P(x&lt;X).
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#49
  def get_icdf(p); end

  # Obtain single PDF value
  # Returns the probability that a stochastic variable x has the value X,
  # i.e. P(x=X)
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#36
  def get_pdf(x); end

  # returns single random number from the student t distribution
  #
  # source://rubystats//lib/rubystats/student_t_distribution.rb#54
  def get_rng; end
end

# source://rubystats//lib/rubystats/uniform_distribution.rb#4
class Rubystats::UniformDistribution < ::Rubystats::ProbabilityDistribution
  # Constructs a uniform distribution (defaults to zero lower and
  # unity upper bound).
  #
  # @return [UniformDistribution] a new instance of UniformDistribution
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#9
  def initialize(lower = T.unsafe(nil), upper = T.unsafe(nil)); end

  # Returns the mean of the distribution
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#18
  def get_mean; end

  # Returns the standard deviation of the distribution
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#23
  def get_standard_deviation; end

  # Returns the variance of the distribution
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#28
  def get_variance; end

  private

  # Obtain single CDF value
  # Returns the probability that a stochastic variable x is less than X,
  # i.e. P(x<X)
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#48
  def get_cdf(x); end

  # Obtain single inverse CDF value.
  # returns the value X for which P(x&lt;X).
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#60
  def get_icdf(p); end

  # Obtain single PDF value
  # Returns the probability that a stochastic variable x has the value X,
  # i.e. P(x=X)
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#37
  def get_pdf(x); end

  # returns single random number
  #
  # source://rubystats//lib/rubystats/uniform_distribution.rb#66
  def get_rng; end
end

# source://rubystats//lib/rubystats/version.rb#2
Rubystats::VERSION = T.let(T.unsafe(nil), String)

# source://rubystats//lib/rubystats/weibull_distribution.rb#3
class Rubystats::WeibullDistribution < ::Rubystats::ProbabilityDistribution
  # @return [WeibullDistribution] a new instance of WeibullDistribution
  #
  # source://rubystats//lib/rubystats/weibull_distribution.rb#6
  def initialize(scale = T.unsafe(nil), shape = T.unsafe(nil)); end

  private

  # Private method to obtain single CDF value.
  # param x should be greater than 0
  # return the probability that a stochastic variable x is less then X, i.e. P(x<X).
  #
  # source://rubystats//lib/rubystats/weibull_distribution.rb#38
  def get_cdf(x); end

  # Private method to obtain single inverse CDF value.
  # return the value X for which P(x<X).
  #
  # source://rubystats//lib/rubystats/weibull_distribution.rb#45
  def get_icdf(p); end

  # source://rubystats//lib/rubystats/weibull_distribution.rb#19
  def get_mean; end

  # Private method to obtain single PDF value.
  # x should be greater than or equal to 0.0
  # returns the probability that a stochastic variable x has the value X, i.e. P(x=X).
  #
  # source://rubystats//lib/rubystats/weibull_distribution.rb#30
  def get_pdf(x); end

  # Private method to obtain single RNG value.
  #
  # source://rubystats//lib/rubystats/weibull_distribution.rb#51
  def get_rng; end

  # source://rubystats//lib/rubystats/weibull_distribution.rb#23
  def get_variance; end
end

# source://rubystats//lib/rubystats.rb#27
StudentTDistribution = Rubystats::StudentTDistribution

# source://rubystats//lib/rubystats.rb#39
Uniform = Rubystats::UniformDistribution

# source://rubystats//lib/rubystats.rb#25
UniformDistribution = Rubystats::UniformDistribution

# source://rubystats//lib/rubystats.rb#41
Weibull = Rubystats::WeibullDistribution

# source://rubystats//lib/rubystats.rb#28
WeibullDistribution = Rubystats::WeibullDistribution