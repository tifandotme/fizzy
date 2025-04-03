class Bubble::Engagement < ApplicationRecord
  belongs_to :bubble, class_name: "::Bubble"
end
