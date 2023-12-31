# frozen_string_literal: true

class Module
  # Allows you to make aliases for attributes, which includes
  # getter, setter, and a predicate.
  #
  #   class Content < ActiveRecord::Base
  #     # has a name attribute
  #   end
  #
  #   class Email < Content
  #     alias_attribute :subject, :name
  #   end
  #
  #   e = Email.find(1)
  #   e.name    # => "Superstars"
  #   e.subject  # => "Superstars"
  #   e.subject? # => true
  #   e.subject = "Megastars"
  #   e.name    # => "Megastars"
  def alias_attribute(new_name, old_name)
    # The following reader methods use an explicit `self` receiver in order to
    # support aliases that start with an uppercase letter. Otherwise, they would
    # be resolved as constants instead.
    module_eval <<-STR, __FILE__, __LINE__ + 1
      def #{new_name}; self.#{old_name}; end          # def subject; self.name; end
      def #{new_name}?; self.#{old_name}?; end        # def subject?; self.name?; end
      def #{new_name}=(v); self.#{old_name} = v; end  # def subject=(v); self.name = v; end
    STR
  end
end
