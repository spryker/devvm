# How to release
There is a [CI system](https://jenkins.korekontrol.net/) watching this repository.
It will trigger a build on each commit to `master` branch. If it's succesful, the
box file for preview will be available [here](https://jenkins.korekontrol.net/get/spryker/).

If the commit in master has also associated a tag name, it will automatically generate
github release (with the same name as tag) and will publish the vm file there.

Please do not tag if release is not tested.

Keep in mind that "just" tagging will not create a new build (if the last commit hash
didn't change). So to make sure that build happens, please do commit + tag and then push.



