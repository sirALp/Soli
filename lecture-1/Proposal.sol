// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
    This the homework file #2(proposal system) for the Solidity Bootcamp held by RiseIn , 
    Written by Alperen TEKİN.
*/

contract Task{
    
    /* ************** DATAS ******************* */

    address owner;
    address[] private voters;  
    uint256 private counter;

    struct Proposal {
        string title; // title of the proposal --> HOMEWORK 2##
        string description; // Description of the proposal
        uint256 approve; // Number of approve votes
        uint256 reject; // Number of reject votes
        uint256 pass; // Number of pass votes
        uint256 total_vote_to_end; // When the total votes in the proposal reaches this limit, proposal ends
        bool current_state; // This shows the current state of the proposal, meaning whether if passes of fails
        bool is_active; // This shows if others can vote to our contract
    }

    mapping(uint256 => Proposal) proposal_history; // Recordings of previous proposals
    
    constructor(){
        owner = msg.sender;
        voters.push(msg.sender);
    }



    /* ***************** Modifiers ***************** */

    modifier onlyOwner{
        require(msg.sender == owner, "You don't have permissons!");
        _;
    }

    modifier canVote{
        require(!didVote(msg.sender),"You have already voted!");
        // if msg.sender is already voted (didVote returns true) than we won't allow them to revote.
        _;
    }

    modifier active{
        require(proposal_history[counter].is_active , "Proposal is not active, You cannot vote!"); 
        // if proposal is still active then we'd go inner if statements otherwise won't even continue
        _;
    }


    
    
    /* ***************** FUNCTIONS ***************** */

    function createProposal(
        string calldata _title,
        string calldata _description,
        uint256 _total_vote_to_end
    ) external onlyOwner {
        counter++;
        proposal_history[counter] = Proposal(_title,_description,0,0,0,_total_vote_to_end,false,true);
    }

    function setOwner(address new_Owner) external onlyOwner{
        owner = new_Owner;
    }

    function didVote(address _address) internal view returns(bool){
        // looping through voters array which holds all the voters until that moment.
        for (uint256 i = 0 ; i< voters.length ;i++){
            if ( _address == voters[i]) return true;
        }
        return false;
    }

    function vote(uint8 choice) external active canVote{
        if (choice == 0 ){
            proposal_history[counter].pass++;
            proposal_history[counter].current_state = calculateCurrentState();
            voters.push(msg.sender);
        }
        else if (choice == 1){
            proposal_history[counter].reject++;
            proposal_history[counter].current_state = calculateCurrentState();
            voters.push(msg.sender);
        }
        else if (choice == 2){
            proposal_history[counter].approve++;
            proposal_history[counter].current_state = calculateCurrentState();
            voters.push(msg.sender);
        }
        
        uint256 totalVote = 
        proposal_history[counter].approve   +
        proposal_history[counter].reject    +
        proposal_history[counter].pass;

        if (totalVote >= proposal_history[counter].total_vote_to_end){
            proposal_history[counter].is_active = false;
            delete voters;
        }
        
        
    }

    // ::: LOGIC :::
    // every approval equals +3 points
    // every rejection equals -3 points
    // every pass vote equals -1 points
    // if total point is higher than or equals to 0  
    // then proposal is passing
    // otherwise it's failing 
    // math : approval * 3 >= rejection * 3 + pass 
    // 
    // all in all , a pass-vote meaning a third of a reject-vote  

    function calculateCurrentState() private view returns(bool){
        uint256 approved = proposal_history[counter].approve;
        uint256 rejected = proposal_history[counter].reject;
        uint256 passed = proposal_history[counter].pass;

        if (approved*3 >= rejected*3 + passed)
            return true; // meaning proposal is passing 
        else 
            return false;// meaning proposal is failing
    }

}