// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
    This the homework file #2(proposal system) for the Solidity Bootcamp held by RiseIn , 
    Written by Alperen TEKİN.
*/

contract Task{
    address immutable owner;
    address[] private voters;  
    
    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "You don't have permissons!");
        _;
    }

    struct Proposal{
        uint256 approveCounter; // aye vote number
        uint256 rejectCounter;  // nay vote number
        uint256 passCounter;    // swing-vote number
        uint256 voteLimit;      // limits the possible number of votes can be casted
        bool isVotingContinuing;// if voteLimit not exceeded it returns true,otherwise false, meaning voting is over
        bool votingStatus;      // will return wheter the current proposal is failing or passing(success)
    }



    function isAlreadyVoted() private view returns(bool){
        for (uint i = 0; i<voters.length; i++)
            if ( voters[i] == msg.sender ) return true;
        return false;
    }

    

    function createProposal(uint256 voteLimit,string memory description)external onlyOwner(){

    }


    function voteApproval() external{

    }











}