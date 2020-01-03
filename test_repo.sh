#!/bin/sh

# Sets up a git repo for quick testing of the tool
rm -rf testrepo
mkdir testrepo
cd testrepo || exit 1
git init

mkdir a
echo "hello" >a/1
git add a
git commit -m "Introduces a"

echo "hello" >a/2
git add a
git commit -m "adds to a"

git checkout -b feature-branch
mkdir b c
touch b/b1 c/c1 a/a1
echo "hello new module" >b/b1
echo "hello new module" >c/c1
echo "hello new module" >a/a1

git add --all .
git commit -m "Introduces a1 b1 c1"

touch b/b2 c/c2
echo "hello addition" >b/b2
echo "hello addition" >c/c2

git add --all .
git commit -m "adds to b2 c2"

git checkout master
touch a/3
git add --all a
echo "foo"
git commit -m"Adds a/3"

git checkout feature-branch

echo "------------------"
# runs git-exfiltrate
../git-exfiltrate master feature-branch "b/*"
git lg --all --stat
