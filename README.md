# OCBC

## Working On Project

All new work must be done in a feature/branch based off develop and then a pull-request, in github, must be made.
The pull-request will be reviewed and changes may be requested before being approved.

### Reasons for rejection of pull-requests
* Types do not follow Swift naming conventions
* Code does not follow rules required in SwiftLint and SwiftFormat
* Any of the three tools mentioned below have been removed
* An image or other large asset was added directly to the repo instead of git-lfs
* There is *dead* or *commented* code

## Build Requirements:

### Cocoa Pods
#### IQKeyboardManagerSwift
* While developing iOS apps, we often run into issues where the iPhone keyboard slides up and covers the UITextField/UITextView. IQKeyboardManager allows you to prevent this issue of keyboard sliding up and covering UITextField/UITextView without needing you to write any code or make any additional setup. To use IQKeyboardManager you simply need to add source files to your project.

#### Alamofire
* In order to keep Alamofire focused specifically on core networking implementations, additional component libraries have been created by the Alamofire Software Foundation to bring additional functionality to the Alamofire ecosystem.

#### NVActivityIndicatorView
* NVActivityIndicatorView is a collection of awesome loading animations.


