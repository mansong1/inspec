
module Inspec
  module HashLikeStruct
    def keys
      members
    end

    def key?(item)
      members.include?(item)
    end
  end

  RunData = Struct.new(
    :controls,     # Array of Inspec::RunData::Control (flattened)
    :other_checks,
    :profiles,     # Array of Inspec::RunData::Profile
    :platform,     # Inspec::RunData::Platform
    :statistics,   # Inspec::RunData::Statistics
    :version       # String
  ) do
    include HashLikeStruct
    def initialize(raw_run_data)
      self.controls   = raw_run_data[:controls].map { |c| Inspec::RunData::Control.new(c) }
      self.profiles   = raw_run_data[:profiles].map { |p| Inspec::RunData::Profile.new(p) }
      self.statistics = Inspec::RunData::Statistics.new(raw_run_data[:statistics])
      self.platform   = Inspec::RunData::Platform.new(raw_run_data[:platform])
      self.version    = raw_run_data[:version]
    end

    # This is the data schema version of the run_data. Reporter authors are advised to check
    # this value, and if it is not what they expect, to error out.
    def schema_version
      "0.1.0"
    end

  end

  class RunData
    Platform = Struct.new(
      :name, :release, :target
    ) do
      include HashLikeStruct
      def initialize(raw_plat_data)
        %i{name release target}.each { |f| self[f] = raw_plat_data[f] || "" }
      end
    end
  end
end

require_relative "run_data/result"
require_relative "run_data/control"
require_relative "run_data/profile"
require_relative "run_data/statistics"
