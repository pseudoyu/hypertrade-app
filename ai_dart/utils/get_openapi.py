import json
import httpx


def generate_example_body(schema, components):
    """Generate an example JSON body based on the provided schema."""
    example = {}
    if "properties" in schema:
        for prop, details in schema["properties"].items():
            if "type" in details:
                if details["type"] == "string":
                    example[prop] = details.get("example", "example_string")
                elif details["type"] == "integer":
                    example[prop] = details.get("example", 0)
                elif details["type"] == "boolean":
                    example[prop] = details.get("example", False)
                elif details["type"] == "array":
                    example[prop] = [
                        generate_example_body(details["items"], components)
                    ]
                elif details["type"] == "object":
                    example[prop] = generate_example_body(details, components)
            elif "$ref" in details:
                ref_path = details["$ref"].split("/")[-1]
                example[prop] = generate_example_body(
                    components["schemas"][ref_path], components
                )
    return example


def generate_curl_commands(
    openapi_json, base_url="http://0.0.0.0:8006", token="your_jwt_token"
):
    """
    Generate curl commands from OpenAPI JSON.

    Parameters:
        openapi_json (dict): The OpenAPI JSON object.
        base_url (str): The base URL for the API requests.
        token (str): The JWT token for Authorization header.

    Returns:
        list: A list of curl command strings.
    """
    curl_commands = []

    paths = openapi_json.get("paths", {})
    components = openapi_json.get("components", {})

    for path, methods in paths.items():
        for method, details in methods.items():
            url = f"{base_url}{path}"
            curl_command = f"curl -X {method.upper()} '{url}'"

            # Add headers
            curl_command += " -H 'accept: application/json'"
            curl_command += f" -H 'Authorization: Bearer {token}'"

            # Handle query parameters
            parameters = details.get("parameters", [])
            for param in parameters:
                if param["in"] == "query":
                    if "required" in param and param["required"]:
                        curl_command += f" -G --data-urlencode '{param['name']}={{YOUR_{param['name'].upper()}}}'"

            # Handle request body
            if "requestBody" in details:
                content = details["requestBody"]["content"]
                if "application/json" in content:
                    schema_ref = content["application/json"]["schema"].get("$ref")
                    if schema_ref:
                        schema_name = schema_ref.split("/")[-1]
                        example_body = generate_example_body(
                            components["schemas"][schema_name], components
                        )
                        curl_command += f" -H 'Content-Type: application/json' -d '{json.dumps(example_body)}'"

            curl_commands.append(curl_command)

    return curl_commands


def fetch_openapi_json(url="http://0.0.0.0:8006/api/openapi.json"):
    """
    Fetch the OpenAPI JSON from the given URL.

    Parameters:
        url (str): The URL to fetch the OpenAPI JSON from.

    Returns:
        dict: The parsed JSON response.
    """
    try:
        # Send a GET request to the specified URL
        response = httpx.get(url)

        # Raise an exception if the request was unsuccessful
        response.raise_for_status()

        # Parse and return the JSON response
        openapi_json = response.json()
        return openapi_json

    except httpx.RequestError as e:
        print(f"An error occurred while requesting {url}: {e}")
    except httpx.HTTPStatusError as e:
        print(f"HTTP error occurred: {e}")
    except ValueError as e:
        print(f"Error parsing JSON: {e}")


# Example usage
openapi_json = fetch_openapi_json()
if openapi_json:
    curl_commands = generate_curl_commands(
        openapi_json,
        base_url="http://0.0.0.0:8006",
        token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZW5nd2VuaGFvQG5jdWhvbWUuY2x1YiIsImV4cCI6MTcyNTUyNjQ1NiwiaWF0IjoxNzI1MTY2NDU2fQ.Kq6cV38_WwBULczZX5m-oF91GWkmDkv6tE7LRuTzcxg",
    )
    for command in curl_commands:
        print(command)
        print("-------------------------------------------")
