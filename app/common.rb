# frozen_string_literal: true

# Common includes for ActiveSupport and other gem features
require 'active_support/concern'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/deep_dup'
require 'active_support/core_ext/string/inflections'
require 'awesome_print'
require 'psych'
require 'set'

# Shut Zeitwerk up for now, figure out how to "officially" satisfy it later
Common = true # rubocop:disable Naming/ConstantName
