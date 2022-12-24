pragma solidity ^0.6.0;

import "./Wallet.sol";

contract WalletFactory {
    address public owner;
    uint public walletCount;

    constructor() public {
        owner = msg.sender;
    }

    function createWallet() public payable {
        Wallet wallet = new Wallet();
        walletCount++;
    }
}
