dimage?=gcr.io/vspegypt/cms_api

docker_build:
	docker build -t ${dimage} -f ./build/Dockerfile .
