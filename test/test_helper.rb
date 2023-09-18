# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ml/experiment"
require "stats/statistics"
require "plotting/gnuplotter"

require "minitest/autorun"
