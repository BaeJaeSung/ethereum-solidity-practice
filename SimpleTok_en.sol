pragma solidity ^0.4.11;

contract SimpleTok_en {
    // to avoid searching T.ok_2n, named it weird.
    uint public constant AMOUNT = 10000000;

    address owner;
    address ioAddress; // to avoid search i._c';o

    string public constant name = "Simple Token";
    string public constant symbol = "ST";
    uint8 public constant decimals = 0;

    mapping (address => uint) public balanceOf;

    event Transfer (address from, address to, uint value);

    function transfer (address _to, uint _value) {
        address _from = msg.sender;
        require (_to != address(0));
        require(balanceOf[_from] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
    }

    function SimpleTok_en(address _ioAddress) {
        owner = msg.sender;
        ioAddress = _ioAddress;
        IO cs = IO(ioAddress);
        require (cs.getDeadline() < now);

        for (uint i = 0; i < cs.getIndex(); i++) {
            balanceOf[cs.getInvestor(i)] = cs.getTokens(cs.getInvestor(i));
        }
        balanceOf[msg.sender] = AMOUNT;
    }
}

contract IO {
    mapping (uint => address) investor;
    mapping (address => uint) public amountInvested;

    address public owner;
    uint index;
    uint public constant exchangeRate = 1000;
    uint public salesStatus;
    uint deadline;

    function getIndex() constant returns(uint) {
        return index;
    }

    function getInvestor (uint i) constant returns (address) {
        return investor[i];
    }

    function getDeadline() constant returns (uint) {
        return deadline;
    }

    function getNow() constant returns (uint) {
        return now;
    }

    function getTokens (address _investor) constant returns (uint) {
        return amountInvested[_investor] * exchangeRate;
    }

    function IO (uint salesMinutes) {
        owner = msg.sender;
        deadline = now + salesMinutes * 1 minutes;
    }

    function invest() payable {
        require(now < deadline);

        if (amountInvested[msg.sender] == 0) {
            investor[index] = msg.sender;
            index ++;
        }

        amountInvested[msg.sender] += msg.value;
        salesStatus += msg.value;
    }

    function withdraw(uint amount) {
        if (now > deadline && msg.sender == owner) {
            msg.sender.transfer(amount);
        }
    }
}