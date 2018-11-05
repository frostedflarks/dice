pragma solidity ^0.4.24;

contract Dice{

	struct Dice{
		uint8  currentBet;
		bool  isBetSet; //default value is false
		uint8  destiny;
	}

	mapping(address => Dice) private bets;

	uint8 public randomFactor;

	event NewBetIsSet(uint8 currentBet);

	event GameResult(address bidder, uint8 currentBet , uint8 destiny);

	constructor() public{
		randomFactor = 10;
	}

	function getNewbet() public returns(uint8){
		require(bets[msg.sender].isBetSet == false);
		bets[msg.sender].isBetSet = true;
		bets[msg.sender].currentBet = random();
		randomFactor += bets[msg.sender].currentBet;
		emit NewBetIsSet(bets[msg.sender].currentBet);
		return bets[msg.sender].currentBet;
	}

	function roll() public returns(address , uint8 , uint8){
		require(bets[msg.sender].isBetSet == true);
		bets[msg.sender].destiny = random();
		randomFactor += bets[msg.sender].destiny;
		bets[msg.sender].isBetSet = false;
		if(bets[msg.sender].destiny == bets[msg.sender].currentBet){
			msg.sender.transfer(100000000000000);
			emit GameResult(msg.sender, bets[msg.sender].currentBet, bets[msg.sender].destiny);			
		}else{
			emit GameResult(msg.sender, bets[msg.sender].currentBet, bets[msg.sender].destiny);
		}
		return (msg.sender , bets[msg.sender].currentBet , bets[msg.sender].destiny);
	}


    function random() private view returns (uint8) {
       	uint256 blockValue = uint256(blockhash(block.number-1 + block.timestamp));
        blockValue = blockValue + uint256(randomFactor);
        return uint8(blockValue % 5) + 1;
    }

    function() public payable{}
	

}