# frozen_string_literal: true

# Common includes for ActiveSupport and other gem features
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/blank'
require 'psych'

# Shut Zeitwerk up for now, figure out how to "officially" satisfy it later
Common = true # rubocop:disable Naming/ConstantName
