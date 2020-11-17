package clails_vpc

import "testing"
import "github.com/gruntwork-io/terratest/modules/terraform"
import "github.com/stretchr/testify/assert"

func TestOutputs(t *testing.T) {
	// Given
	terraformOptions := &terraform.Options{
		TerraformDir: "test",
	}
	defer terraform.Destroy(t, terraformOptions)

	// When
	terraform.InitAndApply(t, terraformOptions)

	// Then
	clusterEndpoint := terraform.OutputRequired(t, terraformOptions, "cluster_endpoint")
	assert.Equal(t, "Hello, World!", clusterEndpoint)
}
