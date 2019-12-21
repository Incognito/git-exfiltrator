# Usage

git exfiltrator [--against=<against-ref>] [--subject=<subject-ref>] [--] [<pathspec>...]

 - `--against` defines the target to merge towards.
 - `--subject` defines the subject branch that files will be extracted from
 - `<pathspec>` same as in `git add`, except only able to add files that exist
   between the subget and the against target.



# Solves this problem


You're faced with a large `feature-branch` and it's making too many changes to
too many parts of the code (See "uses" below). Consider this trivial example
where a feature changes folders `a`, `b`, and `c` inside of commits 46f8642 and
d967302.

Using git-exfiltrate you can extract an entire folder (for example, `b`) into a
new branch which will reduce the impact of merging to master, but still
maintain somewhat of a logical commit history (without havint to cut+paste in
the entire file into a new branch.


```
* 63caf00  (master)
| 
|  a/3 | 0
|  1 file changed, 0 insertions(+), 0 deletions(-)
| * 46f8642  (feature-branch)
| | 
| |  b/b2 | 1 +
| |  c/c2 | 1 +
| |  2 files changed, 2 insertions(+)
| * d967302
|/  
|   
|    a/a1 | 1 +
|    b/b1 | 1 +
|    c/c1 | 1 +
|    3 files changed, 3 insertions(+)
* 8ba0e15
| 
|  a/2 | 1 +
|  1 file changed, 1 insertion(+)
* 8f5255d
  
   a/1 | 1 +
   1 file changed, 1 insertion(+)
```

After running git exfiltrator to extract the b folder:
```
../git-exfiltrate master feature-branch "b/*"
```

The `-extracted` branch will be merged into master. Note that the extracted
branch has an unrelated history from the original `feature-branch`. This means
master has all of folder `b`, and a complete timeline of changes related to b,
but none of the work from `a` or `c` is included.


```
*   34d518c  (master)
|\
| * 166931a  (feature-branch-extracted)
| |
| |  b/b2 | 1 +
| |  1 file changed, 1 insertion(+)
| * aab8a36
| |
| |  b/b1 | 1 +
| |  1 file changed, 1 insertion(+)
| * aa531d8
| * 844c676
* 75d4261
|
|  a/3 | 0
|  1 file changed, 0 insertions(+), 0 deletions(-)
| * c5b2f25  (refs/original/refs/heads/feature-branch-extracted, feature-branch)
| |
| |  b/b2 | 1 +
| |  c/c2 | 1 +
| |  2 files changed, 2 insertions(+)
| * 8320ea7
|/
|
|    a/a1 | 1 +
|    b/b1 | 1 +
|    c/c1 | 1 +
|    3 files changed, 3 insertions(+)
* 85a89b2
|
|  a/2 | 1 +
|  1 file changed, 1 insertion(+)
* 900b39c

   a/1 | 1 +
   1 file changed, 1 insertion(+)
```

For the final step, feature-branch is now ready for merging into master. Simply
`git merge feature-branch` from `master` as you normally would.



```
Merge made by the 'recursive' strategy.
 a/a1 | 1 +
 c/c1 | 1 +
 c/c2 | 1 +
 3 files changed, 3 insertions(+)
 create mode 100644 a/a1
 create mode 100644 c/c1
 create mode 100644 c/c2
```

Resulting in a master that has all work in it.


```
*   7e3ae5e  (master)
|\
| * c5b2f25  (refs/original/refs/heads/feature-branch-extracted, feature-branch)
| * 8320ea7
* |   34d518c
|\ \
| * | 166931a  (feature-branch-extracted)
| * | aab8a36
| * | aa531d8
| * | 844c676
|  /
* | 75d4261
|/
* 85a89b2
* 900b39c

```

# Uses
todo

# Drawbacks
todo

# Thoughts
todo
