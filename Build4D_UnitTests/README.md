Build4D_UnitTests User Manual
=
>To test the latest version of Build4D, open the Build4D project and run the buildComponent method. This will build the component directly in the Build4D_UnitTests project.

User settings
-
User settings are mandatory to perform the unit tests on your computer. They are stored in the **Settings/UT_Settings.json** file.
| Attribut | Description |
| :- | :- |
| macCertificate | Certificate name for macOS signature |
| licenseUUD | POSIX path to a **valid** UUD licence file |
| invalid_LicenseUUD | POSIX path to an **invalid** licence file (not a UUD file) |
| macVolumeDesktop | POSIX path to the macOS Volume Desktop folder |
| winVolumeDesktop | POSIX path to the Windows Volume Desktop folder |
| invalid_macVolumeDesktop | POSIX path to a macOS Volume Desktop folder with different version from running 4D version |
| invalid_winVolumeDesktop | POSIX path to a Windows Volume Desktop folder with different version from running 4D version |

Nomenclature
-
Unit tests methods are formatted this way: **{m}ut_{scope}_R{requirement id}_TC{test case id}**.

Each automatic unit test method is prefixed with **ut_**.

Each manual unit test method is prefixed **mut_**. These tests needs human actions such as certificate password for macOS signature or icon checking.

The scopes are:
| Scope | Description |
| :- | :- |
| 1 | Compiled project |
| 2 | Component |
| 3 | Standalone application |
| 4 | Client application |
| 5 | Server application |

Run Unit Tests 
-
Manual unit tests can be performed by running the **runManualUnitTests** method.

Automatic unit tests can be performed by running the **runAutomaticUnitTests** method.

Automatic unit tests for a specified scope can be performed by running the **runUnitTests1{scope}** method.

Each unit test is performed related to the current project and, if it's relevant, related to an external project.

Run Unit Tests in CLI
-
Running all automatic unit tests can be performed from CLI using the parameter:
**--user-param "test"**.

Reports
-
When starting a test method, the timestamp is stored in the **UT_start.log** file, in the project package. 

When ending a test method, the timestamp is stored in the **UT_end.log** file, in the project package.

When running a unit test method, the unit test method name and the timestamp is stored in the **UT_run.log** file, in the project package. Code errors are also logged in this file.

When a false assertion is encountered in a unit test method, the assertion details is stored in the **UT_errors.log** file, in the project package. At the end, if this file does not exist, unit tests passed.

Note that **.log** files can be opened in the console during tests execution to check the content evolution.

Miscellaneous
-
The **logGitHubActions** formats messages in GitHub Actions fomat so that they can be viewed in live in its console.
