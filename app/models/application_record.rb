# frozen_string_literal: true

# ApplicationRecord serves as the base class for all ActiveRecord models in the application
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
