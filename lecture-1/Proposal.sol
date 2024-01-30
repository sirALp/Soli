// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
    This the homework file #2(proposal system) for the Solidity Bootcamp held by RiseIn , 
    Written by Alperen TEKİN.
*/

contract Task{
    address owner;
    address[] private voters;  
    uint256 private counter;


    
    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "You don't have permissons!");
        _;
    }

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


    function vote(uint8 choice) external {
        require(proposal_history[counter].is_active , "Proposal is not active, You cannot vote!"); 
        // if proposal is still active then we'd go inner if statements otherwise won't even continue
        if (choice == 0 ){
            proposal_history[counter].pass++;
        }
        else if (choice == 1){
            proposal_history[counter].reject++;
        }
        else if (choice == 2){
            proposal_history[counter].approve++;
        }
        
        uint256 totalVote = 
        proposal_history[counter].approve   +
        proposal_history[counter].reject    +
        proposal_history[counter].pass;

        if (totalVote >= proposal_history[counter].total_vote_to_end){
            proposal_history[counter].is_active = false;
        }
        
        
    }







}