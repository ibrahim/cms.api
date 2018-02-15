dimage?=gcr.io/vspegypt/cmsapi

docker_build:
	docker build -t ${dimage} -f ./build/Dockerfile .
