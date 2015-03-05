class AddCommonNameToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :common_name, :string
  end
end
