---
title: Useful Unix Commands
author: HKT
layout: page
date: 2015-02-07T08:02:58+00:00
url: /pages/cmd-line-quickies
summary: |
  Useful Unix commands - Change Permission on Folder/Files Recursively,
  , SVN: Unversioned Files and Ignore List,
  SVN: Show Pending Check-ins,
  SVN: (Tortoise SVN like) Show Modifications,
  SVN: Compare Files &#8211; Show differences side-by-side,
  Everyday `grep`
---

### Change Permission on Folder/Files Recursively[^1]

**GOOD**


```bash
find /path/to/base/dir -type d -exec chmod 755 {} +

find /path/to/base/dir -type f -exec chmod 644 {} +```
```

<!--more-->

**BETTER**

```bash
find /path/to/base/dir -type d -print0 | xargs -0 chmod 755

find /path/to/base/dir -type f -print0 | xargs -0 chmod 644
```

**BEST 🙂**

```bash
chmod -R u+rwX,go+rX,go-w /path
```

* * *

### SVN: Unversioned Files and Ignore List

Use this command to get the list of files not under SVN:

```bash
svn status | grep "^\?" | awk "{print \$2}"
```

If one were to find the unversioned files to ignore them from versioning, this would be handy:

```bash
svn status | grep "^\?" | awk "{print \$2}" > unversioned.txt

svn propset svn:ignore -F unversioned.txt .

rm unversioned.txt

svn ci -m "ignore list"
```

* * *

### SVN: Show Pending Check-ins

Use this command to get the list of pending check-ins (similar to the pending check-ins in Tortoise SVN):

```bash
svn stat | grep "^[^?]"
```

<small>Would be really handy and nifty if you define an alias for the above command.</small>

* * *

### SVN: (Tortoise SVN like) Show Modifications

Use this command to show what are the effective changes &#8211; those have changed on the server and also the ones that have changed locally in your code base:

```bash
svn stat &#8211;show-updates | grep "^[^?]"
```

<small>Would be really handy and nifty if you define an alias for the above command.</small>

* * *

### SVN: Compare Files &#8211; Show differences side-by-side

```bash
svn &#8211;diff-cmd "diff" &#8211;extensions "-y &#8211;suppress-common-lines" diff
```

* * *

### Everyday `grep`

To look up files recursively in the given directory for the given text, and display the file name with line number that has the matching text:

```bash
grep -rHn "text to search" /path/to/dir
```

To use a search pattern, use the following command:

```bash
grep -rHn -e "text pattern to search" /path/to/dir
```

<small>r &#8211; search recursively, H &#8211; display the file name with the matching text, n &#8211; display the line number in the file with the matching text</small>

[^1]: http://superuser.com/questions/91935/how-to-chmod-755-all-directories-but-no-file-recursively
