class ChangeCncTrafic < ActiveRecord::Migration
  def change
    change_table "cnc_traffics" do |t|
      t.remove :size
      t.string :status
      t.rename :data, :response
      t.rename :dataType, :request
    end
  end
end
