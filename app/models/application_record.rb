class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_one_by_name(name)
    return nil if name.blank?

    where('name ilike ?', "%#{name}%").order(:name).first
  end
end
