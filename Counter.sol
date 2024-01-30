// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
    This the homework file #1(counter example) for the Solidity Bootcamp held by RiseIn , 
    Written by Alperen TEKİN. 
*/

contract Task{

    struct Counter{
        int8 count;
        string description;
    }
    Counter public counter;

    address immutable owner;
    constructor(int8 initial_count, string memory initial_description){
        owner = msg.sender;
        counter = Counter({count:initial_count, description:initial_description}); 
    }
    

    modifier onlyOwner {
        require(msg.sender == owner, "You are not allowed to do that! Please contact the owner!");
        _;
    }

    function increment_counter() external onlyOwner{
        counter.count++;
    }

    function decrement_counter() external onlyOwner{
        counter.count--;
    }

    function get_counter() external view returns(int8) {
        return counter.count;
    }

    /*
        ## Homework part !!
    */

   function get_description() external view returns(string memory){
        return counter.description; 
   }

}