# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

def shared_pods
  pod 'RealmSwift'
  pod 'IceCream'
end

target 'MyTime' do
  platform :ios, '13.0'
  
  # Pods for MyTime
  shared_pods
  pod 'FSCalendar'

  target 'MyTimeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyTimeUITests' do
    # Pods for testing
  end

end

target 'MyTimeWatchApp Extension' do
  platform :watchos, '6.0'
  shared_pods
end

target 'MyTime Today Extension' do
  platform :ios, '13.0'
  shared_pods
end