module Pod

  # Model class which describes a Pods target.
  #
  # The Target class stores and provides the information necessary for
  # working with a target in the Podfile and it's dependent libraries.
  # This class is used to represent both the targets and their libraries.
  #
  class Target

    # @return [PBXNativeTarget] the target definition of the Podfile that
    #         generated this target.
    #
    attr_reader :target_definition

    # @return [Sandbox] The sandbox where the Pods should be installed.
    #
    attr_reader :sandbox

    # @return [String] the name of the library.
    #
    def name
      label
    end

    # @return [String] the name of the library.
    #
    def product_name
      "lib#{label}.a"
    end

    # @return [String] the XCConfig namespaced prefix.
    #
    def xcconfig_prefix
      label.upcase.gsub(/[^A-Z]/, '_') + '_'
    end

    def skip_installation?
      false
    end

    # @return [String] A string suitable for debugging.
    #
    def inspect
      "<#{self.class} name=#{name}>"
    end
    alias :to_s :inspect

    #-------------------------------------------------------------------------#

    # @!group Information storage

    # @return [Hash{String=>Symbol}] A hash representing the user build
    #         configurations where each key corresponds to the name of a
    #         configuration and its value to its type (`:debug` or `:release`).
    #
    attr_accessor :user_build_configurations

    # @return [PBXNativeTarget] the target generated in the Pods project for
    #         this library.
    #
    attr_accessor :target

    # @return [Platform] the platform for this library.
    #
    def platform
      @platform ||= target_definition.platform
    end

    #-------------------------------------------------------------------------#

    # @!group Support files

    # @return [Pathname] the folder where to store the support files of this
    #         library.
    #
    def support_files_root
      @sandbox.library_support_files_dir(name)
    end

    # @return [Pathname] the absolute path of the xcconfig file.
    #
    def xcconfig_path
      support_files_root + "#{label}.xcconfig"
    end

    # @return [Pathname] the absolute path of the private xcconfig file.
    #
    def xcconfig_private_path
      support_files_root + "#{label}-Private.xcconfig"
    end

    # @return [Pathname] the absolute path of the header file which contains
    #         the information about the installed pods.
    #
    def target_environment_header_path
      support_files_root + "#{target_definition.label.to_s}-environment.h"
    end

    # @return [Pathname] the absolute path of the prefix header file.
    #
    def prefix_header_path
      support_files_root + "#{label}-prefix.pch"
    end

    # @return [Pathname] the absolute path of the bridge support file.
    #
    def bridge_support_path
      support_files_root + "#{label}.bridgesupport"
    end

    # @return [Pathname] the path of the dummy source generated by CocoaPods
    #
    def dummy_source_path
      support_files_root + "#{label}-dummy.m"
    end

    #-------------------------------------------------------------------------#

  end
end
