# PURPOSE:
creates test_[profile_name].(ps1|.sh) validation script

This defined type facilitates creating test scripts on nodes.  Passing in the name of a module and data to validate, this type will look for an epp template script in the module's templates path.  

If a manifest that declares this type runs on a Windows node, this type will look for an epp template file with an extension of .ps1.epp.  Similarly, if the node is RedHat, then the extension is .sh.epp.

If you have a module called my_modules_name, it should have a directory structure of:

```
  - my_modules_name
    - manifests
      ...
    - templates
      test_my_modules_name.(ps1|.sh).epp
```
in order for this type to locate your template and generate a test script.


# HIERA DATA:
[color][error] = text color for FAIL messages

[color][success] = text color for PASS messages

[extension] = file extension for validation script

[path] = path to validation script

# HIERA EXAMPLE:
```
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
```

# USAGE
```
$validation_data = "something to test on the node" in a module manifest

# declaration of the validation_script type:
validation_script { 'my_modules_name:
  profile_name    => 'my_modules_name',
  validation_data => $validation_data,
}
```
