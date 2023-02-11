require 'models/permission'
require 'models/alert'

before '/admin/alerts*' do
	unless has_permission?(Permission::MANAGE_RESOURCES)
		raise Sinatra::NotFound
	end
end

get '/admin/alerts/?' do
	require_login
	@breadcrumbs << {:text => 'Admin Alerts'}

	alerts = Alert.all.order(:category_id).to_a
	alerts.sort_by! {|alert| alert.category_id.to_s + alert.name.downcase + alert.description.downcase}
	erb :'admin/alerts', :layout => :fixed, :locals => {
		:alerts => alerts
	}

end

get '/admin/alerts/create/?' do
	require_login
	@breadcrumbs << {:text => 'Admin Alerts', :href => '/admin/alerts/'} << {:text => 'Create Alert'}

	erb :'admin/edit_alert', :layout => :fixed, :locals => {
		:alert => Alert.new
	}
end

post '/admin/alerts/create/?' do
	require_login

	if  params[:name] == ""
		flash :error, 'Error', 'Please enter alert name'
		redirect back
	end

	alert = Alert.new
	alert.name = params[:name]
	alert.category_id = params[:category_id]
	alert.description = params[:description]
	alert.save

	flash(:success, 'Alert Created', "Your Alert #{alert.name} has been created.")
	redirect '/admin/alerts/'
end

post '/admin/alerts/:alert_id/delete/?' do
	require_login

	# check that this is a valid alert
	alert = Alert.find_by(:id => params[:alert_id])
	if alert.nil?
		flash(:alert, 'Not Found', 'That alert does not exist.')
		redirect '/admin/alerts/'
	end

	alert.destroy

	flash(:success, 'Alert Deleted', "Your alert #{alert.name} has been deleted.")
	redirect '/admin/alerts/'
end

get '/admin/alerts/:alert_id/edit/?' do
	require_login
	@breadcrumbs << {:text => 'Admin Alerts', :href => '/admin/alerts/'} << {:text => 'Edit Alert'}

	# check that this is a valid alert
	alert = Alert.find_by(:id => params[:alert_id])
	if alert.nil?
		flash(:alert, 'Not Found', 'That alert does not exist.')
		redirect '/admin/alerts/'
	end

	erb :'admin/edit_alert', :layout => :fixed, :locals => {
		:alert => alert
	}
end

post '/admin/alerts/:alert_id/edit/?' do
	require_login

	# check that this is a valid alert
	alert = Alert.find_by(:id => params[:alert_id])
	
	if alert.nil?
		flash(:alert, 'Not Found', 'That alert does not exist.')
		redirect '/admin/alerts/'
	end

    if  params[:name] == ""
		flash :error, 'Error', 'Please enter the updated alert name'
		redirect back
	end

	alert.name = params[:name]
	alert.category_id = params[:category_id]
	alert.description = params[:description]
	alert.save

	flash(:success, 'Alert Updated', "Your alert #{alert.name} has been updated.")
	redirect '/admin/alerts/'
end