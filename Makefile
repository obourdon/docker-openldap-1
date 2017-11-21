NAME = osixia/openldap
VERSION = 1.2.3

.PHONY: build build-nocache test tag-latest push push-latest release git-tag-version

build:
	docker build -t $(NAME):$(VERSION) --rm image

build-nocache:
	docker build -t $(NAME):$(VERSION) --no-cache --rm image

test:
	env NAME=$(NAME) VERSION=$(VERSION) bats test/test.bats

tag-latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

tag-olivier:
	docker tag $(NAME):$(VERSION) obourdon/$(shell echo $(NAME) | sed -e 's?/?-?g'):$(VERSION)

push-olivier:
	docker push obourdon/$(shell echo $(NAME) | sed -e 's?/?-?g'):$(VERSION)

push:
	docker push $(NAME):$(VERSION)

push-latest:
	docker push $(NAME):latest

release: build test tag-latest push push-latest

olivier: build test tag-olivier push-olivier

git-tag-version: release
	git tag -a v$(VERSION) -m "v$(VERSION)"
	git push origin v$(VERSION)
