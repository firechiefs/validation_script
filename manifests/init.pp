# PURPOSE:
# creates test_[profile_name].(ps1|.sh) validation script
#
# HIERA DATA:
# [color][error] = text color for FAIL messages
# [color][success] = text color for PASS messages
# [extension] = file extension for validation script
# [path] = path to validation script
#
# HIERA EXAMPLE:
# global::validation_settings:
#  color:
#    error:
#      windows: "Red"
#      RedHat: "\e[1;31m"
#    success:
#      windows: "Green"
#      RedHat: "\e[1;32m"
#  extension:
#    windows: ".ps1"
#    RedHat: ".sh"
#  path:
#    windows: C:/Windows/System32/WindowsPowerShell/v1.0
#    RedHat: /usr/local/bin


# PUPPET CODE:
# --> VARIABLES:
#      $profile_name = name of profile
#      $validation_data = data to be validated in script
define validation_script (
  String $profile_name,
  $validation_data,
  $file_extension = undef,
){

  # HIERA LOOKUP:
  # --> VALIDATION SCRIPT VARIABLES:
  $validation_settings = hiera('global::validation_settings')

  # HIERA LOOKUP VALIDATION:
  validate_hash($validation_settings)

  # VALIDATION CODE:
  # --> PARSE OUT OSFAMILY SPECIFICS FROM HIERA LOOKUP
  $script_path = $validation_settings[path][$::osfamily]

  if ($file_extension){
    # Set our locally scoped instance var to the passed param
    $_file_extension = $file_extension
  }
  else{
    # Lookup the extension in hiera based on osfamily
    $_file_extension = $validation_settings[extension][$::osfamily]
  }

  $error_color    = $validation_settings[color][error][$::osfamily]
  $success_color  = $validation_settings[color][success][$::osfamily]

  # --> FUNCTIONAL TESTING: CREATES TEST SCRIPT
  file { "${script_path}/test_${profile_name}${_file_extension}":
    ensure  => file,
    content => epp("${profile_name}/templates/${profile_name}${_file_extension}
.epp", {
      'success_color'   => $success_color,
      'error_color'     => $error_color,
      'validation_data' => $validation_data} # variables you'd like to test
      ),
    mode    => '0755',
  }
}
