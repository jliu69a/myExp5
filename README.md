# myExp5

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



