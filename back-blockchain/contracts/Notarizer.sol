//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.7.0;

import "./RBBRegistry.sol";

contract Notarizer {

    RBBRegistry public rbbRegistry;

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
    event DocumentNotarized(bytes32, uint, uint, uint);
    event NotarizationRevoked(bytes32, uint, uint);

    constructor (address rbbRegistryAddr) public
    {
        rbbRegistry = RBBRegistry (rbbRegistryAddr)
        ;
    }

    function notarizeDocument(bytes32 hash, uint validDays) public 
    {
        require(validDays > 0);
        
        uint expirationDate = now + validDays * 1 days;
        uint attesterRbbId = rbbRegistry.getId(msg.sender);
 
        notarizationInfo[hash][attesterRbbId] = NotarizationInfo(now, expirationDate);

        emit DocumentNotarized(hash, attesterRbbId, now, expirationDate);
    }

    function revoke(bytes32 hash) public 
    {
        uint attesterRbbId = rbbRegistry.getId(msg.sender);

        notarizationInfo[hash][attesterRbbId] = 
            NotarizationInfo(NOTARIZATION_REVOKED, NOTARIZATION_REVOKED);

        emit NotarizationRevoked(hash, attesterRbbId, now);
    }
}