version := cat semver.txt
next_version := docker-context/scripts/semver.sh bump patch $(version)~
image_name := "jabronix/ci"

# Runs the image in a container and drops you into the shell
run:
	docker run -it \
		--entrypoint /bin/zsh \
		--user dev \
		--mount type=bind,source="${HOME}",target=/localhost \
		--mount type=bind,source="${HOME}/.aws",target="/home/dev/.aws" \
		--mount type=bind,source="${HOME}/.ssh",target="/home/dev/.ssh" \
		--mount type=bind,source="${HOME}/.vimrc",target="/home/dev/.vimrc" \
		--mount type=bind,source="${HOME}/.vim",target="/home/dev/.vim" \
		--workdir /localhost \
		$(image_name):latest

# Runs the image in a container and executes the atlantis executable that starts the server
run-atlantis:
	docker run -t $(image_name)

# CLI that gives you an interactive view of all of the layers
dive:
	docker run --rm -it \
		-v /var/run/docker.sock:/var/run/docker.sock \
		wagoodman/dive:latest $(image_name)

login:
	docker login

# Builds docker image without layer caching.  This is the "production" build.
build:
	docker build --no-cache -t $(image_name) -f Dockerfile docker-context

# Builds docker image with caching.  This is the "development" build.
build-cached:
	docker build -t $(image_name) -f Dockerfile docker-context

version-bump:
	echo "bumping v$(version) to $(next_version)"
	echo "$(next_version)" > semver.txt
	git add .
	git commit -m "chore/bump to version $(next_version)"

tag-commit:
	git tag -a "v$(next_version)" -m "v$(next_version)"
	git tag -a latest -m "latest"

push-git:
	git push -u origin HEAD --follow-tags

tag-push: login version-bump tag-commit push-git

deploy: build tag-push

deploy-cached: build-cached tag-push
