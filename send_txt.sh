#!/bin/bash

get_current_nonce() {
    docker exec -i aut_client /root/.local/bin/aut account info | grep '"tx_count"' | awk '{print $2}' | tr -d ','
}

# Function to execute a single transaction
## change 5 to ATN value you wanna send each txt

### if you are not using this guide to setup your node 
### https://github.com/web3cdnservices/autonity-validator-toolkit/
### change docker exec -i aut_client /root/.local/bin/aut to auth for all command
perform_transaction_to_wallet1() {
          local specific_nonce=$1
    docker exec -i aut_client /root/.local/bin/aut tx make --to first_wallet --value 5 -n $specific_nonce |
    docker exec -i aut_client /root/.local/bin/aut tx sign --password your_auth_pass - |
    docker exec -i aut_client /root/.local/bin/aut tx send -
}

perform_transaction_to_wallet2() {
    local specific_nonce=$1
    docker exec -i aut_client /root/.local/bin/aut tx make --to second_wallet --value 5 -n $specific_nonce |
    docker exec -i aut_client /root/.local/bin/aut tx sign --password your_auth_pass - |
    docker exec -i aut_client /root/.local/bin/aut tx send -
}

nonce=$(get_current_nonce)
# Infinite loop to send a transaction every second
while true; do
    perform_transaction_to_wallet1 $((nonce++))
    perform_transaction_to_wallet2 $((nonce++))
done