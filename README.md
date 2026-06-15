# Couchbase-Mobile-Inventory-Management-Terraform
Couchbase's inventory management demo mobile application [https://github.com/couchbase-examples/couchbase-lite-retail-demo] introduces you to core Couchbase Mobile concepts and unique advantages:
- Moving data from the edge to the cloud and back again. 
- Enabling one hundred percent availability in the field.

With this demo application you can test out:
- Continuously syncing changes made on iOS or Android to Capella. 
- Syncing changes made locally offline in Couchbase Lite to Capella over App Services when internet connectivity is restored.
- Syncing data between devices using peer to peer sync.

## Repository Objective
Although the required infrastructure for this demo application can be created using the Capella User Interface, the goal of this repository is to show you how to create it in a simple and repeatable way using the Capella Terraform Provider.

Simple to me means:
- Setup in the fewest number of steps.
- Setup in the most logical sequence of steps that are optimized for efficiency.

## Get Started
Create an Organization called "Simple Retail" and a Project called "simple-retail." 

![Create Project](images/create-project.png)

## Set Up Configuration Files
Before collecting your credentials, rename the example variables file so you're ready to fill in values as you go:

```bash
mv terraform.tfvars.example terraform.tfvars
```

Also rename the example env file:

```bash
cp .env.example .env
```

## Generate Capella Management API Key
Inside of your Simple Retail Organization or Project, click generate key.  Depending on where you generate your Management API Key, you should see Organization Owner or Project Owner permissions. Make sure one of these permissions are selected.

![Generate API Key](images/generate-key.png)

Give the key a name, "simple-retail" and tick Organization Owner for key permissions.

Do not add an allowed IP address and leave access unrestricted by default.

Disable API key expiration for testing. 

Both are not the most secure options but we will destroy the infrastructure at the end.

![API Key Settings](images/generate-key2.png)

After generating your key, copy the secret.

![Copy Secret](images/copy-secret.png)

Add the secret to `terraform.tfvars`:
```hcl
auth_token = "your-secret-here"
```

Add it to `.env` and export it so the API calls below can use it:
```bash
echo 'AUTH_TOKEN="your-secret-here"' >> .env
export AUTH_TOKEN="your-secret-here"
```

## Use Management API to Fetch IDs
### Fetch Organization ID
Run this curl command in your terminal to return your Organization's ID:

```bash
curl -sS "https://cloudapi.cloud.couchbase.com/v4/organizations" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $AUTH_TOKEN"
```

Find the returned Organization ID in your terminal.

![Organization ID](images/fetch-orgid.png)

Update `organization_id` in `terraform.tfvars`:
```hcl
organization_id = "your-org-id-here"
```

### Fetch Project ID
Replace `{org_id}` with your Organization ID, then run:

```bash
curl -sS "https://cloudapi.cloud.couchbase.com/v4/organizations/{org_id}/projects" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $AUTH_TOKEN"
```

Find the returned Project ID in your terminal.

![Project ID](images/fetch-projectid.png)

Update `project_id` in `terraform.tfvars`:
```hcl
project_id = "your-project-id-here"
```

### Get Public IP
Couchbase Capella requires an allowed IP (allowlist) to permit direct database connections (like for `cbimport`).
Run this command to get your public IP:
```bash
curl -s https://api.ipify.org
```

Update `allowed_cidr` in `terraform.tfvars` with the returned IP, adding `/32` at the end:
```hcl
allowed_cidr = "203.0.113.5/32"
```

You should now have your Management API Secret, Organization ID, Project ID, and Allowed IP. With these, you're ready to build your infrastructure.

Any challenges with using the Management API, please refer to the API Guide [https://docs.couchbase.com/cloud/management-api-guide/management-api-intro.html] and API Reference [https://docs.couchbase.com/cloud/management-api-reference/index.html].

## Capella Terraform Provider Prerequisites
Ensure Terraform >= 1.5.2 is installed [https://developer.hashicorp.com/terraform/install].
For Macs, you can install it using Homebrew:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Ensure Go >= 1.20 is installed [https://go.dev/doc/install].

For any challenges with the Capella Terraform Provider installation, please refer to the documentation [https://registry.terraform.io/providers/couchbasecloud/couchbase-capella/latest/docs].

Check your installation is successful by running terraform version in your terminal.

## Build Infrastructure With Terraform
In the Parent directory, run:

```bash
terraform init
```

![Terraform Init](images/tf-init.png)

Check the plan before building by running:

```bash
terraform plan
```

You should see 17 resources to add, 0 to change, and 0 to destroy.

After reviewing the plan, you can now run terraform apply to build the infrastructure:

```bash
terraform apply
```

Enter yes to start building.

You will see your Capella cluster deploying in the UI.

You'll see that specific resources depend upon another, you can't create an App Service without a Capella cluster to link it to, and are therefore deployed in a specific order. The steps are clearly visible in your terminal.

The exact deployment time may vary but it usually takes around 5 minutes.

## Load Demo Data
The JSON data required for this demo is in the `demo-dataset` directory.

The `cbimport.sh` script automatically reads your cluster connection string and database password from Terraform outputs — no manual editing needed.

> If your public IP has changed since you first ran `terraform apply`, you must update `allowed_cidr` in `terraform.tfvars` and run `terraform apply` again before loading data.

Move to the demo-dataset directory:

```bash
cd demo-dataset
```

Make the script executable:

```bash
chmod +x cbimport.sh
```

Run the script to load all data into the appropriate collections:

```bash
./cbimport.sh
```

You should see confirmation in the terminal that data has imported correctly:

![Data Imported](images/import-data.png)

## Create Endpoint Users
With your infrastructure created, you can now head to your Online endpoints to create your App Users.

You will create two App Users, one for each store and therefore in each App Endpoint.

In the supermarket-aa Endpoint, add App User Name: aa-store-01@supermarket.com and password: P@ssword1.

Assign channels by hitting enter for inventory, orders and profile to the identical linked collection.

Your configuration for the AA Store should look like this:

![AA Store Configuration](images/AA-Store-User.png)

Repeat this for the NYC Store, creating user nyc-store-01@supermarket.com and password: P@ssword1.

Your configuration for the NYC Store should look like this:

![NYC Store Configuration](images/NYC-Store-User.png)

## Mobile Example
Once the infrastructure is built, the data loaded, the app users created, you can head to the relevant README at [https://github.com/couchbase-examples/couchbase-lite-retail-demo] for instructions on how setup and run it in your mobile emulator, Xcode or Android Studio.

You can fetch your Endpoint quickly via terraform. Remove the supermarket at the end when updating the BASE_URL as the code will populate this automatically based on Login credentials.

```bash
terraform output endpoint_url
```

OR you can click into one of your created App Endpoints in Capella and hit connect to find the connection string. 

![Capella Endpoint URL](images/capella-endpoint-url.png)

You will then have to update the CBL_BASE_URL with the store removed, as this is updated dynamically based on Login credentials, for Android in gradle.properties, and for iOS in Info.plist.

![Gradle Properties URL](images/endpoint-base-url.png)

## Clean Up Infrastructure
Run to destroy all of the infrastructure you've created.
```bash
terraform destroy
```