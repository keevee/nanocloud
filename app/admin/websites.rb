ActiveAdmin.register Website do
  member_action :compile, :method => :post do
    website = Website.find(params[:id])
    website.compile
  end
end
