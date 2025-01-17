update:
	echo "updating dependencies ..."
	go get -u ./...

build:
	echo "building bench-routes ..."
	go build -o bench-routes src/main.go

view-v1.1:
	cd dashboard/v1.1/ && yarn start

test-views-v1.1:
	cd dashboard/v1.1/ && yarn install
	cd dashboard/v1.1/ && yarn run lint
	cd dashboard/v1.1/ && yarn run tlint
	cd dashboard/v1.1/ && prettier '**/*.tsx' --list-different
	cd dashboard/v1.1/ && yarn run build
	cd dashboard/v1.1/ && yarn start &

clean:
	rm -R build/ bench-routes

test: build
	go clean -testcache
	go test -v ./...

build-frontend:
	cd dashboard/v1.1/ && yarn install && yarn build

test-non-verbose: build
	go clean -testcache
	go test ./...

test-services: build
	./bench-routes &
	cd tests && yarn install
	yarn global add mocha
	mocha tests/browser.js

test_complete: build
	./shell/go-build-all.sh
	echo "test success!"

run:
	echo "compiling go-code and executing bench-routes"
	echo "using 9990 as default service listener port"
	go run src/*.go 9990

run-collector:
	go run src/collector/main.go

fix:
	go fmt ./...
	cd dashboard/v1.1/ && npm run prettier-fix
	cd dashboard/v1.1/ && npm run tlint-fix

lint:
	golangci-lint run

