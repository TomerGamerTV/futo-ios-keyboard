require 'xcodeproj'

project_path = 'FUTOKeyboard.xcodeproj'

# Initialize Xcode project
project = Xcodeproj::Project.new(project_path)

# Set base project build settings
project.build_configurations.each do |config|
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['SDKROOT'] = 'iphoneos'
  config.build_settings['CLANG_ENABLE_OBJC_ARC'] = 'YES'
  config.build_settings['SWIFT_VERSION'] = '6.0'
end

# Create principal groups
app_group = project.main_group.find_subpath('FUTOKeyboard', true)
ext_group = project.main_group.find_subpath('FUTOKeyboardExtension', true)

# Create targets
app_target = project.new_target(:application, 'FUTOKeyboard', :ios, '17.0', nil, :swift)
ext_target = project.new_target(:app_extension, 'FUTOKeyboardExtension', :ios, '17.0', nil, :swift)

# App target build configurations
app_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'org.futo.keyboard'
  config.build_settings['INFOPLIST_FILE'] = 'FUTOKeyboard/Info.plist'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'NO'
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
  config.build_settings['SWIFT_VERSION'] = '6.0'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2' # iPhone & iPad
end

# Extension target build configurations
ext_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'org.futo.keyboard.extension'
  config.build_settings['INFOPLIST_FILE'] = 'FUTOKeyboardExtension/Info.plist'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'NO'
  config.build_settings['SWIFT_VERSION'] = '6.0'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  config.build_settings['SKIP_INSTALL'] = 'YES'
end

# Add Keyboard Extension target dependency to the Main App
app_target.add_dependency(ext_target)

# Add Keyboard Extension to Main App's Embed App Extensions build phase
embed_extensions_phase = app_target.new_copy_files_build_phase('Embed App Extensions')
embed_extensions_phase.symbol_dst_subfolder_spec = :plug_ins
embed_extensions_phase.add_file_reference(ext_target.product_reference)

# Map app files
app_files = [
  'FUTOKeyboardApp.swift',
  'DashboardView.swift',
  'OnboardingView.swift',
  'SettingsView.swift',
  'ThemesView.swift',
  'DictationView.swift',
  'AboutView.swift',
  'Assets.xcassets'
]

app_files.each do |filename|
  file_ref = app_group.new_reference("FUTOKeyboard/#{filename}")
  if filename.end_with?('.swift')
    app_target.source_build_phase.add_file_reference(file_ref)
  else
    app_target.resources_build_phase.add_file_reference(file_ref)
  end
end

# Map extension files
ext_files = [
  'KeyboardViewController.swift',
  'KeyboardView.swift',
  'KeyboardLayouts.swift',
  'SuggestionEngine.swift'
]

ext_files.each do |filename|
  file_ref = ext_group.new_reference("FUTOKeyboardExtension/#{filename}")
  if filename.end_with?('.swift')
    ext_target.source_build_phase.add_file_reference(file_ref)
  end
end

project.save

puts "Xcode project created successfully at #{project_path}"
