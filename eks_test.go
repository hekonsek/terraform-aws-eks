package clails_vpc

import "testing"
import "github.com/gruntwork-io/terratest/modules/terraform"
import "github.com/gruntwork-io/terratest/modules/test-structure"

func TestEks(t *testing.T) {
	// Given
	defer test_structure.RunTestStage(t, "destroy_vpc", func() {
		destroyVpc(t)
	})
	test_structure.RunTestStage(t, "create_vpc", func() {
		createVpc(t)
	})
}

func createVpc(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "test/vpc",
	}
	terraform.InitAndApply(t, terraformOptions)
}

func destroyVpc(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "test/vpc",
	}
	terraform.Destroy(t, terraformOptions)
}
