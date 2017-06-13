pragma solidity ^0.4.7;
// hey test comment
contract Ballot {
    
    mapping(bytes32 => uint) public candidates;
    mapping(address => bool) public voted;
    
    event log_candidate_name(bytes32 log);
    event log_candidate_tally(uint log);
    
    // candidates that are proposed by owner will be initialized to 1, 
    // thus when somebody votes for non-proposed person, value will be 0
    function Ballot(bytes32[] _names) {
        for (uint i = 0; i < _names.length; i++){
            candidates[_names[i]] = 1;
        }
    }
    
    // make sure sender has not voted yet, and the vote is to 
    // candidate in ballot
    // increment candidates tally
    function Vote(bytes32 _vote){
        require(!voted[msg.sender]);
        require(candidates[_vote] != 0);
        
        candidates[_vote]++;
        voted[msg.sender] = true;
        
        log_candidate_name(_vote);
        log_candidate_tally(candidates[_vote]-1);
    }
    
    
}
