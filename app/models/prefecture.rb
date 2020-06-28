# == Schema Information
#
# Table name: prefectures
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Prefecture < ApplicationRecord
  has_many :cities, dependent: :destroy
  has_many :posts, dependent: :destroy
end
