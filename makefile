include ../../../make.inc

# YOUR CODE HERE

build_docker_image:
	@echo "Building docker image..."
	@docker build -t docker-hub:my-image -f Dockerfile .


run_docker_image:
	@echo "Running docker image..."
	@docker run --rm -it -p 8000:8000 -e PORT=8000 docker-hub:my-image

push_docker_image:
	@echo "Pushing docker image..."
	@docker push $(DOCKER_IMAGE_NAME)

deploy_docker_image:
	@echo "Deploying docker image..."
	@gcloud run deploy first-app --image $(DOCKER_IMAGE_NAME) --region europe-west1

deploy_docker_image:
	gcloud run deploy --image=us-docker.pkg.dev/project-402010/image
