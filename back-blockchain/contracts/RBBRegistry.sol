//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.7.0;

contract RBBRegistry  
{

    uint ownerId;
    address ownerAddr;

    constructor (uint id) public 
    {
        ownerId = id;
        ownerAddr = msg.self;
    
    }

    function getId (address addr) public view returns (uint) 
    {
        require(addr == ownerAddr, "Tá maluco???");
        return ownerId;
    }

}