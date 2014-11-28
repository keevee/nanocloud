ActiveAdmin.register Website do
  member_action :compile, :method => :post do
    website = Website.find(params[:id])
    website.compile
  end

  form do |f|
    f.inputs "Properties" do
      f.input :name
      f.input :user
    end
    f.inputs "Directories" do
      f.input :input_bucket_name
      f.input :preview_bucket_name
      f.input :output_bucket_name
    end
    f.inputs "FTP Properties (optional)" do
      f.input :host
      f.input :username
      f.input :password
    end

    f.buttons
  end

end
