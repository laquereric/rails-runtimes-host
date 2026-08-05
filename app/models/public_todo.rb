# frozen_string_literal: true

class PublicTodo < ApplicationRecord
  belongs_to :installation

  validates :title, presence: true
end
