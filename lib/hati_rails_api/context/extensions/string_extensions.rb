# frozen_string_literal: true

# Simple string extension for camelize if ActiveSupport is not available
class String
  def camelize
    return self if empty?

    # Handle underscored strings - capitalize all words
    split('_').map(&:capitalize).join
  end
end
