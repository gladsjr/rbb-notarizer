//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.7.0;

import "./RBBRegistry.sol";

contract Notarizer {

    RBBRegsitry public rbbRegistry;

    // Constant that indicates that the document notarization was revoked
    uint NOTARIZATION_REVOKED = 0;

    struct NotarizationInfo {
        // Notarization date (0 means "not verified")
        uint notarizationDate;
        // Verification expiration date (0 means "never expires")
        uint expiratioDate;
    }

    // document hash => Attester RBB Id => notarizationInfo
    mapping (bytes32 => mapping (uint => NotarizationInfo)) public notarizationInfo;

    // Document hash, attester RBB Id, date of today and expiration date
    event DocumentNotarized(byte32, uint, uint, uint);

    constructor (address rbbRegistryAddr)
    {
        rbbRegistry = (RBBRegistry) rbbRegistryAddr;
    }

    function notarizeDocument(bytes32 hash, uint validDays) public 
    {
        require(validDays > 0);
        
        uint expirationDate = now + validDays * 1 days;
        uint attesterRbbId = rbbRegistry.getId(msg.sender);
 
        notarizationInfo[hash][attesterRbbId] = notarizationInfo(now, expirationDate);

        emit DocumentNotarized(hash, attesterRbbId, now, expirationDate);
    }

    function revoke(bytes32 hash) public {
        uint attesterRbbId = rbbRegistry.getId(msg.sender);

        verifications[hash][attesterRbbId] = 
            notarizationInfo(NOTARIZATION_REVOKED, NOTARIZATION_REVOKED);

        emit NotarizationRevoked(hash, attesterRbbId, now);
    }
}