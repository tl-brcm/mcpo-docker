# MCP-O Docker

This project provides a Docker-based environment for running a SiteMinder Policy MCP server and exposing it through the **MCP-to-OpenAPI (mcpo)** proxy. This setup converts the MCP server's protocol into a standard, secure OpenAPI-compatible RESTful API, allowing it to be easily integrated with LLM agents and other modern applications like [Open WebUI](https://github.com/open-webui/open-webui).

The environment uses Docker Compose to orchestrate the deployment of three key services:
-   **`mcpo`**: A proxy that makes the MCP server available as a secure RESTful API.
-   **`mcp-server`**: The SiteMinder Policy MCP, which handles policy management.
-   **`vault`**: A HashiCorp Vault instance for securely managing the SiteMinder password.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup and Configuration

The environment requires a one-time setup to store the SiteMinder password securely in Vault.

1.  **Set Script Permissions:**
    Make the shell scripts executable:
    ```bash
    chmod +x onboard_siteminder_password.sh verify-vault.sh start_mcp_docker.sh
    ```

2.  **Start Vault Service:**
    To store the password, the Vault container must be running. Start it using Docker Compose:
    ```bash
    docker-compose up -d vault
    ```

3.  **Store SiteMinder Password:**
    Run the onboarding script to securely store the SiteMinder password in Vault. You will be prompted to enter the password.
    ```bash
    ./onboard_siteminder_password.sh
    ```

4.  **Verify (Optional):**
    You can verify that the password was stored correctly by running the verification script:
    ```bash
    ./verify-vault.sh
    ```

## Running the Application

Once the initial setup is complete, you can start the entire application stack.

1.  **Start All Services:**
    Use Docker Compose to build and start all services in the correct order.
    ```bash
    docker-compose up --build
    ```
    The MCP-O service will be available at `http://localhost:8000`.

2.  **Stopping the Services:**
    To stop all running containers, use:
    ```bash
    docker-compose down
    ```

## Services

The `docker-compose.yml` file defines the following services:

-   **`mcpo`**: The main MCP-O application. It is configured via `config.json` to connect to the `mcp-server`.
-   **`mcp-server`**: The SiteMinder Policy MCP service (`siteminder-policy-mcp`). It retrieves the necessary SiteMinder credentials from the Vault service at startup.
-   **`vault`**: A HashiCorp Vault instance running in development mode. It is used to securely store the SiteMinder password.

## Utility Scripts

-   **`onboard_siteminder_password.sh`**: A script to securely prompt for and store the SiteMinder password in the Vault instance. This is a required first-time setup step.
-   **`verify-vault.sh`**: A helper script to check if the SiteMinder credentials have been successfully stored in Vault.
-   **`start_mcp_docker.sh`**: An alternative run script that starts *only* the `mcpo` container using `docker run`. This is useful for running MCP-O as a standalone container, but it assumes that its dependent services (like `mcp-server`) are accessible.
