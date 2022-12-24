pragma solidity ^0.8.0;

contract Wallet {
    address public owner;
    mapping(address => uint) public balance;
    mapping(string => address) public usernameToAddress;
    mapping(address => string) public addressToUsername;

    constructor() public {
        owner = msg.sender;
        balance[owner] = 1000000;
    }

    function claimUsername(string memory _username) public {
        require(usernameToAddress[_username] == address(0), "Username is already claimed");
        usernameToAddress[_username] = msg.sender;
        addressToUsername[msg.sender] = _username;
    }

    function deposit() public payable {
        require(msg.value > 0, "Cannot deposit 0 or less Ether");
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(amount > 0, "Cannot withdraw 0 or less Ether");
        require(balance[msg.sender] >= amount, "Insufficient balance");
        balance[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function transfer(address recipient, uint amount) public {
        require(amount > 0, "Cannot transfer 0 or less Ether");
        require(balance[msg.sender] >= amount, "Insufficient balance");
        balance[msg.sender] -= amount;
        balance[recipient] += amount;
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
}

contract AbstractedWallet is Wallet {
    address public abstractedAccount;

    constructor(address _abstractedAccount) public {
        abstractedAccount = _abstractedAccount;
    }

    function deposit() public override payable {
        abstractedAccount.transfer(msg.value);
    }

    function withdraw(uint amount) public override {
        require(abstractedAccount.call.value(amount)(""), "Withdrawal failed");
        balance[msg.sender] += amount;
    }

    function transfer(address recipient, uint amount) public override {
        require(abstractedAccount.call.value(amount)(abi.encodePacked(recipient)), "Transfer failed");
        balance[recipient] += amount;
    }

    function getBalance() public view override returns (uint) {
        (bool success, uint balance) = abstractedAccount.call("", "balanceOf", this);
        require(success, "Failed to get balance");
        return balance;
    }
}
