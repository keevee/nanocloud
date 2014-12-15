ActiveAdmin.register User do
  index do
    column :email
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :aws_key
      f.input :aws_secret
    end
    f.buttons
  end
end
