all: test-all

clean:
	sudo rm -rf test/eks/.terragrunt-cache test/eks/terraform.tfstate test/eks/.terraform.lock.hcl
	sudo rm -rf test/vpc/.terragrunt-cache test/vpc/terraform.tfstate test/vpc/.terraform.lock.hcl

test-all:
	go test -timeout 30m -v eks_test.go

test-create-dependencies:
	SKIP_destroy_dependencies=true SKIP_create_eks=true SKIP_destroy_eks=true go test -timeout 30m -v eks_test.go

test-destroy-dependencies:
	SKIP_create_dependencies=true SKIP_create_eks=true SKIP_destroy_eks=true go test -timeout 30m -v eks_test.go