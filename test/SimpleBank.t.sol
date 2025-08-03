// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank public simpleBank;
    address user = address(0xABCD);
    function setUp() public {
        simpleBank = new SimpleBank();
        vm.deal(user, 100 ether);
    }
    function testDepositSucceeds() public {
        vm.prank(user);
        simpleBank.deposit{value: 0.0001 ether}();
        assertEq(simpleBank.total(), 0.0001 ether);
    }

    function testDepositFailsOnZero() public {
        vm.prank(user);
        vm.expectRevert(SimpleBank.ZeroAmount.selector);
        simpleBank.deposit{value: 0 ether}();
    }

    function testDepositFailsOnLowAmount() public {
        vm.prank(user);
        vm.expectRevert(SimpleBank.InsufficientETH.selector);
        simpleBank.deposit{value: 0.00005 ether}();
    }

    function testWithdrawSucceeds() public {
        vm.startPrank(user);
        simpleBank.deposit{value: 1 ether}();
        console.log("Balance:", address(user).balance);
        simpleBank.withdraw(1 ether);
        console.log("Balance:", address(user).balance);
        vm.stopPrank();
        assertEq(simpleBank.total(), 0 ether);
        assertEq(simpleBank.balances(user), 0 ether);
    }


    function testWithdrawFailsOnLowBalance() public {
        vm.startPrank(user);
        simpleBank.deposit{value: 2 ether}();
        vm.expectRevert(SimpleBank.InsufficientETH.selector);
        simpleBank.withdraw(3 ether);
    }

    function testWithdrawSendsEth() public {
        vm.startPrank(user);
        simpleBank.deposit{value: 20 ether}();
        simpleBank.withdraw(20 ether);
        vm.stopPrank();
        assertEq(address(user).balance, 100 ether);
    }
}
