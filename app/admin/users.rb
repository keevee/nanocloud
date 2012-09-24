ActiveAdmin.register User do
  index do
    column :email
    column :website
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :website
    end
    f.buttons
  end
end
