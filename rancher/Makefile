.PHONY: all

#----------------------- includes -----------------------
include make/Makefile.ngrok
include make/Makefile.k3d
include make/Makefile.colima
include make/Makefile.rancher
include make/Makefile.docker
#----------------------- includes -----------------------
.DEFAULT_GOAL := help

CLUSTERNAME=rmaster
IMAGE_VERSION=rancher/k3s:v1.25.10-k3s1

RANCHER_PASSWORD=Welcome123

help:
	@echo "Usage:"
	@echo "	Before starting and make sure to run 'make colima/start', this creates a docker environment"
	@echo "	main/start				- start ngrok/install k3s/install rancher/install elemental"
	@echo "	main/stop				- stop ngrok/install k3s/install rancher/install elemental\n"
	@make colima/help
	@make docker/help
	@make k3d/help
	@make ngrok/help
	@make rancher/help

main/start: ngrok/stop ngrok/start docker/registry-stop docker/registry-delete docker/registry-start
	$(eval RANCHER_HOSTNAME := $(subst https://,,$(RANCHER)))
	make k3d/cluster-delete K3D_CLUSTERNAME=$(CLUSTERNAME)
	make k3d/cluster-create K3D_CLUSTERNAME=$(CLUSTERNAME) K3D_K3S_IMAGE_VERSION=$(IMAGE_VERSION)
	make rancher/install CLUSTERNAME=k3d-$(CLUSTERNAME) HOSTNAME=$(RANCHER_HOSTNAME) PASSWORD=$(RANCHER_PASSWORD)
	make ngrok/print-env

main/stop: ngrok/stop docker/registry-stop docker/registry-delete
	make k3d/cluster-delete K3D_CLUSTERNAME=$(CLUSTERNAME)
