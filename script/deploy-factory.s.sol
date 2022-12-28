// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { WalletFactory } from "../src/WalletFactory.sol";
import { Wallet } from "../src/Wallet.sol";

contract WalletFactoryScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new WalletFactory();
        vm.stopBroadcast();
    }
}
