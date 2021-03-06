# == Schema Information
#
# Table name: labels
#
#  id         :integer          not null, primary key
#  project_id :integer
#  name       :string(255)
#  color      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Label < ActiveRecord::Base
  include Colorist

  belongs_to :project, touch: true
  has_and_belongs_to_many :bids

  before_destroy :touch_all_bids

  default_scope -> { order("name") }

  def text_color
    return "light" unless self.color
    Color.from_string("#"+self.color).brightness > 0.6 ? "dark" : "light"
  end

  private
  def touch_all_bids
    self.bids.update_all(updated_at: Time.now)
  end
end
