pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/WalletFactory.sol";
import "../src/Wallet.sol";

contract WalletFactoryTest is Test {
    WalletFactory public walletFactory;
    Wallet public myWallet;

    address deployerAddress = address(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);

    function setUp() public {
        walletFactory = new WalletFactory();
    }

    function testCreateNewWallet() public {
        address newTestWalletAddress = walletFactory.createWallet("test");
        assertFalse(newTestWalletAddress == address(0));
    }

    function testGetWalletOwner() public {
        address myWalletAddress = walletFactory.createWallet("innvertir");
        address requestedAddress = walletFactory.getWalletOwner(myWalletAddress);
        assertEq(requestedAddress, deployerAddress);
    }

    function testGetWalletByUsername() public {
        address myWalletAddress = walletFactory.createWallet("innvertir");
        address requestedWalletAddress = walletFactory.getWalletByUsername("innvertir");
        assertEq(requestedWalletAddress, myWalletAddress);
    }

    function testGetUsernameByWallet() public {
        address myWalletAddress = walletFactory.createWallet("innvertir");
        string memory requestedUsername = walletFactory.getUsernameByWallet(myWalletAddress);
        assertEq(requestedUsername, "innvertir");
    }

    // function testFailSubtract43() public {
    //     testNumber -= 43;
    // }
}