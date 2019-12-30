# Usage

```
git exfiltrator <against-ref> <subject-ref> <pathspec>

 - <against> defines the target to merge towards.
 - <subject> defines the subject branch that files will be extracted from
 - <pathspec> same as in `git add`, except only able to add files that exist
   between the <subject> and the <against> target found in each commit.
```

# Known Uses
- Breaking up a large branch or Pull Request into many smaller ones.
- Releasing (or moving) code that is "ready" without waiting for code that is
  "not ready"
- Wanting to remove some feature or migrate development to another branch
  without losing history.

# Benefits
- A late stage fix to development processes which generate massive PRs instead
  of many small PRs.
- Keeping history of work migrated to a new branch.
- Avoid using primitive cut+paste techniques.

# Known Drawbacks
- Commit messages will be duplicated into the extracted branch.
- Operator should know how a git-tree works.

# Installation 

You can install the script using this repo to keep things versioned correctly, or you can try and do it the hack way.

Hacky way: Cut+paste the script to your home folder and run the bash script whenever you want to use it.

Supported way: Clone the repo to your home folder. Make your `$PATH` envvar able to resolve this script. Once you do, git will understand `git exfiltrate` (without the `-`) anywhere you want to use it. Then add this repo to your watchlist/subscriptions on GitHub so you know when/if I provide any updates or useful improvements.

(If someone would like to maintain a `.deb` or `brew` dependency I'd be happy to link to it.)

# Example

[![asciicast](https://asciinema.org/a/OwPrRxKT0IHauAdgXZ5p74naT.svg)](https://asciinema.org/a/OwPrRxKT0IHauAdgXZ5p74naT)

Imagine you're faced with a large `feature-branch` and it's making too many
changes to too many parts of the code (See "uses" below). Consider this trivial
example where a feature changes folders `a`, `b`, and `c` inside `feature-branch`.

Using git-exfiltrate you can extract an entire folder (for example, `b`) into a
new branch which will reduce the impact of merging to master, and still
maintain a logical commit history.

```
*   (master)
|  a/3 | 0
| *   (feature-branch)
| |  b/b2 | 1 +
| |  c/c2 | 1 +
| * 
|/
|    a/a1 | 1 +
|    b/b1 | 1 +
|    c/c1 | 1 +
* 
|  a/2 | 1 +
* 
   a/1 | 1 +
```

Run git exfiltrator to extract the `b` folder into a new "extract" branch:

```
./git-exfiltrate master feature-branch "b/*"
```

The `-extracted` branch will be merged into the `subject` argument provided.
Note that the extracted branch has an unrelated history from the original
`feature-branch`. This means master has all of folder `b`, and a complete
timeline of changes related to `b`, but none of the work from `a` or `c` is
included.

```
*   e01009e  (master)
|\
| * ce4ca64  (feature-branch-extracted)
| * f3bf092
* | 4b2ebd6
|/
| * d4c374e  (refs/original/refs/heads/feature-branch-extracted, feature-branch)
| * 4724dbb
|/
* 927799f
* 219e9b2
```

Typically the next step might be merging the rest of `feature-branch` into
master. Simply `git merge feature-branch` from `master` as you normally would.

> Note: This step is not required to use the tool, and not the only correct way
> to use the tool. This is simply a common task which users of this tool will
> perform.

```
*   078f69a  (master)
|\
| * d4c374e  (refs/original/refs/heads/feature-branch-extracted, feature-branch)
| * 4724dbb
* |   e01009e
|\ \
| * | ce4ca64  (feature-branch-extracted)
| * | f3bf092
| |/
* | 4b2ebd6
|/
* 927799f
* 219e9b2
```

# Regrets
I wish I didn't have to create this tool. The reality is that most of this
industry is writing massive PRs which are difficult to work with. Changing the
default "development mindset" of developers and software managers *globally* is
a hard task. I can't fix the industry with a bash script, but I can fix a git
branch.

I hope one day our entire industry (not just some pockets of it) will fully
embrace and be capable of working only in small incremental changes.
