// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity ^0.8.0;

import "openzeppelin-contracts/access/Ownable.sol";
import "./Wallet.sol";

contract Factory is Ownable {

    address private _owner;
    // Mapping of wallet addresses to owners address
    // If user doesn't use a EOA, wallet will be owned by this Factory
    // contract. It must be updated to an Operator contract
    mapping(address => address) public walletOwners;
    // Mapping of Username to owner address
    mapping(string => address) public usernameOwners;

    // Mapping of usernames to wallet addresses
    mapping(string => address) public usernameToWalletAddress;
    // Mapping of wallet addresses to usernames
    mapping(address => string) public walletAddressToUsername;

    constructor() {
        _owner = msg.sender;
    }

    // Deploys a new wallet, sets the given username and sets the owner to the caller
    function createWallet(string memory _username) public {
        // Check if the given username has already been saved
        require(usernameToWalletAddress[_username] == address(0), "Username already taken");
        // Create a new wallet contract
        Wallet newWallet = new Wallet(_username);
        // Save the wallet address under the given username
        usernameToWalletAddress[_username] = address(newWallet);
        // Save the owner of the wallet
        walletOwners[address(newWallet)] = msg.sender;
    }
}

