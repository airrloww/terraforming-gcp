# graduation-project

1) setup:
    * create a terraform service account, create a key and save it:
    ```bash
    $ export PROJECT_NAME="<project_name_here>"
    $ gcloud iam service-accounts create terraform-admin \
        --description="service account for terraform" \
        --display-name="Terraform Admin" && \
    gcloud projects add-iam-policy-binding $PROJECT_NAME \
        --member=serviceAccount:terraform-admin@$PROJECT_NAME.iam.gserviceaccount.com \
        --role=roles/owner && \
    gcloud iam service-accounts keys create terraform/terraform-admin-key.json \
        --iam-account=terraform-admin@$PROJECT_NAME.iam.gserviceaccount.com
    ```

2) steps: 
    * enable all APIs needed for the project, and create a database on CloudSQL service:
    ```
    $ cd terraform && terraform init
    $ terraform apply -target=module.enable_apis -target=module.sql
    ```
    * add the INSTANCE_CONNECTION_NAME to the API script
    *  create a table from cloudSQL
    ```
    CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL
    );
    ```
    * create cloud function, a cloud function service account, <br>
    allow service account to invoke the function and to access cloud sql:

    ```
    $ terraform apply -target=module.cloud_function
    ``` 