#!/bin/bash
TARGET="/home/drew/tmp/drewhughlett"
GIT_DIR="/home/drew/code/drewhughlett.git"
BRANCH="main"
CONTAINER_NAME="drewhughlett"
IMAGE_NAME="home"

while read oldrev newrev ref
do
	# only checking out the main (or whatever branch you would like to deploy)
	if [ "$ref" = "refs/heads/$BRANCH" ];
	then
		filelist=$(git diff-tree --no-commit-id --name-only -r $newrev)
		echo "Ref $ref received. Deploying ${BRANCH} branch to production..."

		mkdir -p $TARGET
		git --work-tree=$TARGET --git-dir=$GIT_DIR checkout -f $BRANCH
		cd $TARGET

    # echo "Building new Docker image"
		# docker build -f Dockerfile -t $IMAGE_NAME .
		# cd /
		# rm -rf $TARGET

		# echo "Redeploying UI..."
		# docker stop $CONTAINER_NAME
    # docker rm $CONTAINER_NAME
    # docker run -d --rm --name=$CONTAINER_NAME -p 80:80 $IMAGE_NAME
	else
		echo "Ref $ref received. Doing nothing: only the ${BRANCH} branch may be deployed on this server."
	fi
done