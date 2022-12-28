// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity ^0.8.0;

import "openzeppelin-contracts/utils/math/SafeMath.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract Wallet {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    address payable public owner;
    string public username;
    uint256 public balance;                                 // Revisar si es necesario este balance, ya que es para ETH
    mapping(address => uint) public tokenBalances;

    constructor(string memory _username) {
        owner = payable(msg.sender);
        username = _username;
    }

    function deposit(address _token, uint256 _amount) public payable {
        if (_token == address(0)) {
            // Depositing ETH
            require(msg.value == _amount, "Incorrect amount sent");
            balance = balance.add(_amount);
        } else {
            // Depositing ERC-20 token
            ERC20(_token).transferFrom(msg.sender, address(this), _amount);
            tokenBalances[_token] = tokenBalances[_token].add(_amount);
        }
    }

    function withdraw(address _token, uint256 _amount) public {
    if (_token == address(0)) {
        // Withdrawing ETH
        require(balance >= _amount, "Insufficient ETH balance");
        balance = balance.sub(_amount);
        payable(msg.sender).transfer(_amount);
    } else {
        // Withdrawing ERC-20 token
        require(tokenBalances[_token] >= _amount, "Insufficient token balance");
        ERC20(_token).transfer(msg.sender, _amount);
        tokenBalances[_token] = tokenBalances[_token].sub(_amount);
    }
}

    function transfer(address _to, address _token, uint256 _amount) public {
    if (_token == address(0)) {
        // Transferring ETH
        require(balance >= _amount, "Insufficient ETH balance");
        balance = balance.sub(_amount);
        payable(_to).transfer(_amount);
    } else {
        // Transferring ERC-20 token
        require(tokenBalances[_token] >= _amount, "Insufficient token balance");
        ERC20(_token).transfer(_to, _amount);
        tokenBalances[_token] = tokenBalances[_token].sub(_amount);
    }
}

    function getBalance(address _token) public view returns (uint256) {
        if (_token == address(0)) {
            // Returning balance of ETH
            return balance;
        } else {
            // Returning balance of ERC-20 token
            return tokenBalances[_token];
        }
    }

    receive() external payable {}
}
