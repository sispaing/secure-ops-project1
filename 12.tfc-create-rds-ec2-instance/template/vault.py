import hvac
import json

def pretty_print_response(response):
    print(json.dumps(response, indent=2, sort_keys=True))

VAULT_URL='http://127.0.0.1:8007'
# You must get the Vault token from the Sink file to use it
with open("./vault_token") as f:
        VAULT_TOKEN = f.readlines()
        VAULT_TOKEN = VAULT_TOKEN[0].strip('\n')

print(f'Vault token = {VAULT_TOKEN}')

client = hvac.Client(url=VAULT_URL, token=VAULT_TOKEN, namespace='admin')
current_token = client.lookup_token()
print('This is the current token: ', current_token)
# Read the data written under path: secret/data/test
read_response = client.secrets.database.read(
    path='test', mount_point='db')

pretty_print_response(read_response)
print(f"Here is the DB Username: {read_response['data']['username']}")
print(f"Here is the DB Password: {read_response['data']['password']}")