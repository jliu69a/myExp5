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
then, here is the branch struture : "develop" -> "release" -> "dev_4"

and, after any changes, follow the structure, in reverse order, to bring the latest code into "develop" branch.


3,
keep in mind that, when commit the changes, all of the system atuo-updates can be disregarded.  only the code changes are committed in, and this will make the branches merging smoothly.

