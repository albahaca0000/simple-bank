// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract DeploySimpleBank is Script {
    function run() public {
        vm.startBroadcast();

        new SimpleBank();

        vm.stopBroadcast();
    }
}
