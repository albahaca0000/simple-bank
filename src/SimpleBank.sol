// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SimpleBank {
    error ZeroAmount();
    error InsufficientETH();

    uint256 public total;
    mapping(address => uint256) public balances;

    function deposit() public payable {
        if (msg.value > 0) {
            if (msg.value >= 0.00001 ether){
               balances[msg.sender] += msg.value;
               total += msg.value;
            } else {
                revert InsufficientETH();
            }
        } else {
            revert ZeroAmount();
        }
    }

    function withdraw(uint256 amount) public {
        if (amount <= balances[msg.sender]) {
            balances[msg.sender] -= amount;
            total -= amount;

            (bool sent, ) = msg.sender.call{value: amount}("");
            require(sent, "ETH transfer failed");
        } else {
            revert InsufficientETH();
        }
    }
}