class MetaData < ActiveRecord::Base
  establish_connection "evercam_db_#{Rails.env}".to_sym

  self.table_name = "meta_datas"
  belongs_to :camera
  belongs_to :user, :foreign_key => 'user_id', :class_name => 'EvercamUser'
end
