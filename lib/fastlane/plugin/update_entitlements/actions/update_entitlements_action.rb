require 'fastlane/action'
require_relative '../helper/update_entitlements_helper'

module Fastlane
  module Actions
    class UpdateEntitlementsAction < Action
      def self.run(params)
        UI.message("Entitlements File: #{params[:entitlements_file]}")

        entitlements_file = params[:entitlements_file]
        UI.user_error!("Could not find entitlements file at path '#{entitlements_file}'") unless File.exist?(entitlements_file)

        # parse entitlements
        result = Plist.parse_xml(entitlements_file)
        UI.user_error!("Entitlements file at '#{entitlements_file}' cannot be parsed.") unless result

        # set apple signin
        app_apple_signin = params[:apple_signin]
        if app_apple_signin
          result['com.apple.developer.applesignin'] = app_apple_signin
        end
        # set app group identifiers 
        app_group_identifiers = params[:app_group_identifiers]
        if app_group_identifiers
          result['com.apple.security.application-groups'] = app_group_identifiers
        end

        # app payment
        app_payments = params[:app_payments]
        if app_payments
          result['com.apple.developer.in-app-payments'] = app_payments
        end

        # associated domains
        associated_domains = params[:app_associated_domains]
        if associated_domains
          result['com.apple.developer.associated-domains'] = associated_domains
        end

        # save entitlements file
        result.save_plist(entitlements_file)
        UI.message("New entitlements file set: #{result}")
      end

      def self.description
        "update entitlements file"
      end

      def self.authors
        ["zhuys"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "This plugin changes the app group identifiers，apple signin, app payments in the entitlements file."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :entitlements_file,
            env_name: "FL_UPDATE_ENTITLEMENTS_ENTITLEMENTS_FILE_PATH", 
            description: "The path to the entitlement file",
            verify_block: proc do |value|
              UI.user_error!("Please pass a path to an entitlements file. ") unless value.include?(".entitlements")
              UI.user_error!("Could not find entitlements file") if !File.exist?(value) && !Helper.test?
            end),
          FastlaneCore::ConfigItem.new(key: :apple_signin,
            env_name: "FL_UPDATE_ENTITLEMENTS_APP_SIGNIN",
            description: "An Array of access level for the apple signin. Eg. ['Default']",
            is_string: false,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("The parameter apple_signin need to be an Array.") unless value.kind_of?(Array)
            end),
          FastlaneCore::ConfigItem.new(key: :app_group_identifiers,
            env_name: "FL_UPDATE_ENTITLEMENTS_APP_GROUP_IDENTIFIERS",
            description: "An Array of unique identifiers for the app groups. Eg. ['group.com.test.testapp']",
            is_string: false,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("The parameter app_group_identifiers need to be an Array.") unless value.kind_of?(Array)
            end),
          FastlaneCore::ConfigItem.new(key: :app_payments,
            env_name: "FL_UPDATE_ENTITLEMENTS_APP_PAYMENT",
            description: "An Array of unique identifiers for the app payment. Eg. ['merchant.com.test.testapp']",
            is_string: false,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("The parameter app_payments need to be an Array.") unless value.kind_of?(Array)
            end),
          FastlaneCore::ConfigItem.new(key: :app_associated_domains,
            env_name: "FL_UPDATE_ENTITLEMENTS_APP_ASSOCIATED_DOMAINS",
            description: "An Array of unique identifiers for the app associated domains. Eg. ['applinks:cv.test.cn']",
            is_string: false,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("The parameter app associated domains need to be an Array.") unless value.kind_of?(Array)
            end)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
