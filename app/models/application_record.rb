class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_one_by_name(name)
    return nil if name.blank?

    where('name ilike ?', "%#{name}%").order(:name).first
  end

  def self.select_records(per_page, page)
    results = (per_page || 20).to_i
    skipped_pages = [page.to_i, 1].max - 1
    limit(results).offset(results * skipped_pages)
  end
end
