pragma solidity ^0.4.7;

import "HumanStandardToken.sol";

contract Ballot2{
    
    HumanStandardToken public vote_token;
    
    mapping(address => bool) public voted;
    mapping(bytes32 => uint) public candidates;
    
    address public govt;
    uint256 public population;
    bytes32[] public names;
    
    event debug_balance(uint256 x);
    event debug_address(address x);
    event log_winner(bytes32 winner);
    event log_tie(bytes32 tie_condition);
    
    function Ballot2(address[] _citizens, bytes32[] _names){
        govt = msg.sender;
        population = _citizens.length;
        vote_token = new HumanStandardToken(population, "vote_token", 3,"");
        
        // go through citizens, and grant them the right to vote
        for (uint32 i = 0; i < population; i++){
            vote_token.approve(_citizens[i],1);
        }
        
        // go through candidate names, and set their tally to 1, in order
        // to make only names defined by government voteable. 
        // push those names to a state variable to check their tally in the end
        for (uint32 j = 0; j < _names.length; j++){
            candidates[_names[j]] = 1;
            names.push(_names[j]);
        }
    }

    function checkCitizenship(address[] _citizens){
        for (uint32 i = 0; i < _citizens.length; i++){
            debug_address(_citizens[i]);
            debug_balance(vote_token.balanceOf(_citizens[i]));
        }
    }
   
    function ask_to_vote(bytes32 _vote){
        vote_token.approve(govt,1);
        //require(vote_token.transferFrom(msg.sender, govt, 1));
        require(!voted[msg.sender]);
        require(candidates[_vote] != 0);
         
        candidates[_vote]++;
        voted[msg.sender] = true;
        if (vote_token.balanceOf(govt) == population){
            announce_winner();
        }
    }
    
    function announce_winner(){
        bytes32 leader = "";
        uint256 max = 0;
        bool tie = false;
        for (uint32 i = 0; i < names.length; i++){
            if (candidates[names[i]] == max) {
                tie = true;
            }
            else if (candidates[names[i]] > max) {
                max = candidates[names[i]];
                leader = names[i];
                tie = false;
            }
        }
        if (tie == true){
            log_tie("There is a tie, repeat election");
        }
        else{
            log_winner(leader);
        }
    }
}


    
    

