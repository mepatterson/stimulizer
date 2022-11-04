# frozen_string_literal: true

require "active_support/concern"
require "dry-configurable"
require "lucky_case"

require_relative "stimulizer/version"
module Stimulizer
  extend Dry::Configurable
  # extend ActiveSupport::Concern

  class Error < StandardError; end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    @@stimulizer_opts = {output: :html_string}

    def _stimulizer_opts
      @@stimulizer_opts
    end

    def stimulize(hash)
      @@stimulizer_opts.merge!(hash.deep_symbolize_keys)
    end
  end

  def stimulus_controller
    build_stimulus_controller
  end

  def stimulus_hash(*args)
    build_stimulus_hash(*args)
  end

  def stimulus(*args)
    output = stimulus_hash(*args)
    return output if _stimulizer_opts[:output] == :hash

    raw(
      output.to_a
        .map { |k, v| %(#{k.to_s.strip}="#{v.to_s.strip}") }
        .join(" ")
        .squish
        .strip
    )
  end

  private

  def _stimulizer_opts
    self.class._stimulizer_opts
  end

  # EXAMPLE: My::Fancy::FooThing => "my--fancy--foo-thing"
  def build_stimulus_controller
    klass = self.class.name
    klass = klass.gsub(_stimulizer_opts[:ignore_prefix], "") if _stimulizer_opts[:ignore_prefix].present?
    klass.underscore.dasherize.gsub("/", "--")
  end

  # USAGE:
  #   <%= stimulus(:controller)   <-- USES THE DEFAULT CONTROLLER
  #   <%= stimulus(controller: "my-fancy-controller")
  #   <%= stimulus(action: "click->doThing")
  #   <%= stimulus(action: "click->doThing mouseup->otherThing")
  #   <%= stimulus(action: "doThing") <-- default event for element
  #   <%= stimulus(target: "button")
  #   <%= stimulus(classes: {foo: "text-red-500", busy: "opacity-50 animate-spin"})
  #   <%= stimulus(values: {url: "https://example.com"})
  #   <%= stimulus(params: {foo: "bar", this_thing: "whatever"})
  #
  # ... or combine them:
  #
  #   <%= stimulus(:controller, target: "button", action: "click->doThing")
  def build_stimulus_hash(default_controller = false, controller_name: nil, controller: nil, target: nil, action: nil, params: nil, values: nil, classes: nil)
    raise ArgumentError(":controller_name specified, but blank") if controller_name&.blank?
    raise ArgumentError(":controller specified, but blank") if controller&.blank?
    raise ArgumentError(":target specified, but blank") if target&.blank?
    raise ArgumentError(":action specified, but blank") if action&.blank?
    raise ArgumentError(":params specified, but blank") if params&.blank?
    raise ArgumentError(":values specified, but blank") if values&.blank?
    raise ArgumentError(":classes specified, but blank") if classes&.blank?

    {}.tap do |hash|
      hash[:"data-controller"] = ""

      local_controller_name = stimulus_controller

      if default_controller.to_s.downcase.to_sym == :controller
        hash[:"data-controller"] += " #{stimulus_controller}"
      elsif controller_name.present?
        hash[:"data-controller"] += " #{controller_name}"
        local_controller_name = controller_name
      end

      hash[:"data-controller"] += " #{controller}" if controller

      hash.delete(:"data-controller") if hash[:"data-controller"].blank?

      if action
        actions = action.squish.split(" ").map do |str|
          next if str.blank?

          arr = str.split("->")
          event, function = arr.last.nil? ? [nil, arr.first] : ["#{arr.first}->", arr.last]

          if function.include?("#")
            "#{event}#{function}"
          else
            "#{event}#{local_controller_name}##{function}"
          end
        end.compact

        hash[:"data-action"] = actions.join(" ")
      end

      params&.each do |key, value|
        hash[:"data-#{local_controller_name}-#{LuckyCase.dash_case(key.to_s)}-param"] = value
      end

      values&.each do |key, value|
        hash[:"data-#{local_controller_name}-#{LuckyCase.dash_case(key.to_s)}-value"] = value
      end

      classes&.each do |key, value|
        hash[:"data-#{local_controller_name}-#{LuckyCase.dash_case(key.to_s)}-class"] = value
      end

      hash[:"data-#{local_controller_name}-target"] = target if target
    end
  end
end
