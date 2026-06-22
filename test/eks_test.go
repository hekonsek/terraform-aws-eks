package test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestEKSModuleApplyAndVerify(t *testing.T) {
	if os.Getenv("TERRATEST_SKIP_DEPLOY") != "" {
		t.Skip("TERRATEST_SKIP_DEPLOY set; skipping deployment")
	}

	region := firstSet("TF_VAR_region", "TERRATEST_REGION", "AWS_REGION", "AWS_DEFAULT_REGION")
	if region == "" {
		region = "us-east-1"
	}

	suffix := strings.ToLower(random.UniqueId())
	clusterName := fmt.Sprintf("eks-test-%s", suffix)
	vpcName := fmt.Sprintf("%s-vpc", clusterName)

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		Vars: map[string]interface{}{
			"region":       region,
			"cluster_name": clusterName,
			"vpc_name":     vpcName,
		},
		EnvVars: map[string]string{
			"AWS_REGION":       region,
			"TF_IN_AUTOMATION": "true",
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	require.Equal(t, clusterName, terraform.Output(t, terraformOptions, "cluster_name"))
	require.Equal(t, "default", terraform.Output(t, terraformOptions, "node_group_name"))
	require.NotEmpty(t, terraform.Output(t, terraformOptions, "cluster_arn"))
	require.NotEmpty(t, terraform.Output(t, terraformOptions, "node_group_arn"))
}

func firstSet(names ...string) string {
	for _, name := range names {
		if value := strings.TrimSpace(os.Getenv(name)); value != "" {
			return value
		}
	}
	return ""
}
