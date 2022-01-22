# What is this

A tool to help you when you accidentally wrote too much code in too many places
in a feature branch. This tool lets you preserve history and break the code
down by folders into individual branches. This is really useful for people who
work on decoupled component architectures.

It seems it is a frequent pattern for engineers to get so focused on making
changes they often need a way to break it up and release it in smaller chunks
to make reviews easier for their peers.

# Usage

1. Be sure you have the branch that needs to be broken up checked out
2. Be sure you are in the project root
3. Ensure that your branch was not already merged into your project's primary branch (if those changes were already applied, there is nothing to split)

```
Usage: git-exfiltrator[-h] [-b] against-ref subject-ref pathspec
   <against> The branch you will merge changes into
   <new-branch> The branch you want to create
   <pathspec> the path you wish to split ("some/path/*")
   <base> (optional) The tool will attempt to auto-detect the common ancestor
	  between your branch and the against target. If your branch histories
          are complicated you can manually provide the original ancestor commit.

Break a big feature branch into a smaller specific branch with the changes from
one specific folder. Also, preserve your commit history.
```

# Benefits
- A late stage fix to development processes (or mindset) which generate massive
  branches instead of many small ones.
- Keeping history of work migrated to a new branch.
- Avoid using primitive cut+paste techniques from one branch to another which
  remove history and are error prone.

# Known Drawbacks
- Commit messages will be duplicated into the extracted branch.
- The user should know how a git-tree works (or have access to someone who
  does) if there are serious complications.
- Possibility of introducing multiple root ancestors (unknown if there are practical drawbacks).

# Installation 
You can install the script using this repo to keep things versioned correctly,
or you can try and do it the hack way.

## Hacky way: 
Cut+paste the script to your home folder and run the bash script whenever you
want to use it.

## Supported way:
1. Clone the repo to your home folder.
2. Make your `$PATH` envvar able to resolve this script. Once you do, git will
   understand `git exfiltrate` (without the `-`) anywhere you want to use it. 
3. Then add this repo to your watchlist/subscriptions on GitHub so you know
   when/if I provide any updates or useful improvements, and you can git-pull
   the update as needed.

(If someone would like to maintain a `.deb` or `brew` dependency I'd be happy
to link to it.)

# Example usage

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

Run git exfiltrate to extract the `b` folder into a new "extract" branch:

```
git checkout feature-branch
./git-exfiltrate master feature-branch-extracted "b/*"
```

The `-extracted` branch will be created with just the contents of `b` from the branch.

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

There was a previous "Stateless" version that let you operate on bare repos but
it proved too unintuitive in practice for a wide audience, so this new version
requires that you are checked out on the right branch and in the root folder.

And yes, the heart of this program is a 1-liner but the real value here is
documenting how to do that one liner and making it dead-simple to an audience
who typically not want to figure it out while needing to deliver more code
quickly.
