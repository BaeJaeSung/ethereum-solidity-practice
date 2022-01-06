pragma solidity ^0.4.11;

contract slot {
    uint constant JACKPOT = 64;
    address owner;
    uint gameNumber;
    struct game {
        address player;
        bool win;
        uint bettingAmount;
        uint gameResult;
        uint reward;
        uint blockNumber;
    }

    game[] public games;
    event sendResult (address player, bool win, uint amount, uint n1, uint n2, uint n3) ;

    function slot() payable {
        owner = msg.sender;
    }

    function bet() payable {
        if (this.balance < msg.value * JACKPOT) {
            revert();
        }

        bool win = false;
        uint gameResult = uint(block.blockhash(block.number - 1)) % 1000;
        uint n1 = gameResult / 100;
        uint n2 = (gameResult % 100) / 10;
        uint n3 = gameResult % 10;

        uint reward = msg.value;
        if (n1 == n2) {reward = reward * 4; win = true;}
        if (n2 == n3) {reward = reward * 4; win = true;}
        if (n1 == n3) {reward = reward * 4; win = true;}

        if (win)
            msg.sender.transfer(reward);
        else
            reward = 0;

        sendResult(msg.sender, win, reward, n1, n2, n3);
        games.push(game(msg.sender, win, msg.value, gameResult, reward, block.number));
    }

    function killcontract() {
        if (owner == msg.sender)
            selfdestruct(owner);
    }

    function bat() payable {}
}