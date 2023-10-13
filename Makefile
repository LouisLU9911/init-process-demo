
CONTAINER_NAME = init_process_demo
IMAGE_TAG = init_process_demo:latest

all: build

build: clean docker-build

bazel-build:
	bazel build :all

docker-build:
	@docker build -t $(IMAGE_TAG) . 2> /dev/null

run-with-init: build
	@docker run --init -d --name $(CONTAINER_NAME) $(IMAGE_TAG) with-init 2> /dev/null | exit

test-with-init: run-with-init
	@echo "Running /test in the container..."
	@echo ""
	@echo "Process table:"
	@docker exec $(CONTAINER_NAME) ps aux
	@echo ""
	@echo "Sleep 2s..."
	@sleep 2
	@echo ""
	@echo "cat /example.txt"
	@docker exec $(CONTAINER_NAME) cat /example.txt
	@echo ""
	@echo "Stop the container using docker stop..."
	time docker stop $(CONTAINER_NAME)
	@echo ""
	@echo "copy /example.txt from the container"
	@docker cp $(CONTAINER_NAME):/example.txt ./ | exit
	@echo "example.txt is deleted by /test if /test received the SIGTERM signal"
	@echo ""
	cat example.txt

run-without-init: build
	@docker run -d --name $(CONTAINER_NAME) $(IMAGE_TAG) without-init 2> /dev/null | exit

test-without-init: run-without-init
	@echo "Running /test in the container..."
	@echo ""
	@echo "Process table:"
	@docker exec $(CONTAINER_NAME) ps aux
	@echo ""
	@echo "Sleep 2s..."
	@sleep 2
	@echo ""
	@echo "cat /example.txt"
	@docker exec $(CONTAINER_NAME) cat /example.txt
	@echo ""
	@echo "Stop the container using docker stop..."
	time docker stop $(CONTAINER_NAME)
	@echo ""
	@echo "copy /example.txt from the container"
	@docker cp $(CONTAINER_NAME):/example.txt ./ | exit
	@echo "example.txt is deleted by /test if /test received the SIGTERM signal"
	@echo ""
	cat example.txt

clean:
	@rm -rf ./example.txt
	@bazel clean 2> /dev/null
	@docker stop $(CONTAINER_NAME) 2> /dev/null | exit
	@docker kill $(CONTAINER_NAME) 2> /dev/null | exit
	@docker rm $(CONTAINER_NAME) | exit

