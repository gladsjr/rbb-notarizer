//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.7.0;

import "./RBBRegistry.sol";

contract BNDESPublicTenderNotarizer 
{
    RBBRegsitry public registry;
    uint ownerId;

    struct NotarizedPublicTender
    {
        bytes32 documentListHash;
        uint    lastNotarizationDate;
        uint    version;
    }

    // PublicTenderId => NotarizedPublicTender
    mapping (uint => NotarizedPublicTender) public notarizedPublicTender;

    // Id of the procurement, hash of the document list, 
    // notarization date (now) and version 
    event PublicTenderNotarized(uint, bytes32, uint, uint);

    modifier onlyOwner 
    {
        require(registry.getId(msg.sender) == ownerId, "Só o proprietário pode executar essa função");
        _;
    }

    constructor (address registryAddr) public
    {
        registry = RBBRegistry(registryAddr);
        ownerId = registry.getId(msg.sender);

    }

    function notarizePublicTender (uint publicTenderId, byte32 documentListHash) 
        public onlyOwner
    {   
        // If there is no value set to this procurementId...
        if (notarizedPublicTender[procurementId].documentListHash == 0)
        {
            notarizedPublicTender[publicTenderId] = 
                NotarizedPublicTender(documentListHash, now, 1);
        }
        else
        {
            notarizedPublicTender[publicTenderId].documentListHash = documentListHash;
            notarizedPublicTender[publicTenderId].lastNotarizationDate = now;
            notarizedPublicTender[publicTenderId].version += 1;
        }

        emit PublicTenderNotarized(publicTenderId, 
            notarizedPublicTender[publicTenderId].documentListHash, 
            notarizedPublicTender[publicTenderId].lastNotarizationDate, 
            notarizedPublicTender[publicTenderId].version);
    }
}