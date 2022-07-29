This is the status of all changes.


on 2022-07-29 (Friday)

1.
have a clean start with this mobile app.  the branches are :

"dev_8" -> "develop" -> "dev_11"

the most updated veresion is in "dev_11", and need to fix the issue of data not refreshed correctly when changing payment types and/or vendors.


2.
here is the log:

user-MBP> myExp5 % git branch
* dev_8
user-MBP> myExp5 % git checkout -b develop
Switched to a new branch 'develop'
user-MBP> myExp5 %
user-MBP> myExp5 % git push
fatal: The current branch develop has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin develop

user-MBP> myExp5 % git push --set-upstream origin develop
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote:
remote: Create a pull request for 'develop' on GitHub by visiting:
remote:      https://github.com/jliu69a/myExp5/pull/new/develop
remote:
To https://github.com/jliu69a/myExp5.git
 * [new branch]      develop -> develop
Branch 'develop' set up to track remote branch 'develop' from 'origin'.
user-MBP> myExp5 %
user-MBP> myExp5 %
user-MBP> myExp5 % git branch
  dev_8
* develop
user-MBP> myExp5 %
user-MBP> myExp5 % git checkout -b dev_11
Switched to a new branch 'dev_11'
user-MBP> myExp5 %
user-MBP> myExp5 % git branch
* dev_11
  dev_8
  develop
user-MBP> myExp5 %
user-MBP> myExp5 % git push
fatal: The current branch dev_11 has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin dev_11

user-MBP> myExp5 % git push --set-upstream origin dev_11
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote:
remote: Create a pull request for 'dev_11' on GitHub by visiting:
remote:      https://github.com/jliu69a/myExp5/pull/new/dev_11
remote:
To https://github.com/jliu69a/myExp5.git
 * [new branch]      dev_11 -> dev_11
Branch 'dev_11' set up to track remote branch 'dev_11' from 'origin'.
user-MBP> myExp5 %
user-MBP> myExp5 %
user-MBP> myExp5 % git branch
* dev_11
  dev_8
  develop
user-MBP> myExp5 %





////////////////////////////////////////////////////////////////////////////////

(old notes)

This is the new version of MyExpensesTracker app.  It is using the latest version of Alamofire and SwiftyJson frameworks, including the JSON parsing via Codable.

dev_2 is the current working version.
dev_3 is with view models.

//

here are the changes :

1,
need to create the "develop", from the most up-to-date code.  that is the "dev_3" branch.  and then create the "release" branch from "develop" branch.  next from "release" branch off to a new branch, called "dev_4".

after all of these steps are completed successfully, then delete the "dev_3" branch.  and the "dev_4" will be the new working branch.

"dev_2" is the existing working version.  will save as a reference, and remain untouched.


2,
then, here is the branch struture : "develop" -> "release" -> "dev_6"

after any changes, follow the structure, in reverse order, to bring the latest code into "develop" branch.

the next change is to use shared top-nav, and replace the existing UIView on every page.

NOTE: "dev_6" is the latest branch now.  the "dev_4" is being removed.


3,
keep in mind that, when commit the changes, all of the system auto-updates can be disregarded.  only the code changes are committed in, and this will make the branches merging smoothly.

//

currently it is at the version 8, and it should be branched off to be develop.  it will be a clean start.

the original develop can be branched off as a backup.

after that, it will be like: "dev_8" -> "develop" -> "dev_11".

