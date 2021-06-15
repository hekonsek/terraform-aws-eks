package clails_vpc

import (
	"testing"
)
import "github.com/gruntwork-io/terratest/modules/terraform"
import "github.com/gruntwork-io/terratest/modules/test-structure"
import "github.com/stretchr/testify/assert"

func TestEks(t *testing.T) {
	// Given
	defer test_structure.RunTestStage(t, "destroy_dependencies", func() {
		destroyVpc(t)
	})
	test_structure.RunTestStage(t, "create_dependencies", func() {
		createVpc(t)
	})
	defer test_structure.RunTestStage(t, "destroy_eks", func() {
		destroyEks(t)
	})

	// When
	test_structure.RunTestStage(t, "create_eks", func() {
		createEks(t)
	})

	// Then
	assert.True(t, true)
}

func createVpc(t *testing.T) {
	terraform.Apply(t, terraformOptions("vpc"))
}

func destroyVpc(t *testing.T) {
	terraform.Destroy(t, terraformOptions("vpc"))
}

func createEks(t *testing.T) {
	terraform.Apply(t, terraformOptions("eks"))
}

func destroyEks(t *testing.T) {
	terraform.Destroy(t, terraformOptions("eks"))
}

func terraformOptions(module string) *terraform.Options {
	return &terraform.Options{
		TerraformDir:    "test/" + module,
		TerraformBinary: "terragrunt",
	}
}
