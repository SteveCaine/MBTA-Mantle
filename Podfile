platform :ios, '9.0'

target 'MBTA-Mantle' do
	pod 'AFNetworking'
	pod 'Mantle'
end

target 'MBTA-MantleTests' do
end


post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
		end
	end
end
