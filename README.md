# Usage

git forcep [--against=<against-ref>] [--subject=<subject-ref>] [--] [<pathspec>...]

 - `--against` defines the target to merge towards.
 - `--subject` defines the subject branch that files will be extracted from
 - `<pathspec>` same as in `git add`, except only able to add files that exist
   between the subget and the against target.



# Solves this problem


You're faced with a large `feature-branch` and it's making too many changes to
too many parts of the code (See "uses" below). Consider this trivial example
where a feature changes folders `a`, `b`, and `c` inside of commits 46f8642 and
d967302.

Using git-forceps you can extract an entire folder (for example, `b`) into a
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


