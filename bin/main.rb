# frozen_string_literal: true

require "bundler/setup"

require 'rubystats'
require "matrix"
require "rinruby"

R.arr = [4,3,2,2,1]
R.eval <<EOF
    library(robustbase)
    res <- mc(arr)
EOF
puts "#{R.res}"
