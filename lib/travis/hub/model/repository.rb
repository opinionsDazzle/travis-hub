class Repository < ActiveRecord::Base
  has_many :builds

  def migrating?
    migration_status == 'migrating'
  end
end
