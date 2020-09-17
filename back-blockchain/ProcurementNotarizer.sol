pragma solidity ^0.5.0;


import "./RBBRegistry.sol";

contract ProcurementNotarizer 
{
    RBBRegsitry public registry;
    uint ownerId;

    struct NotarizedProcurement
    {
        bytes32 documentListHash;
        uint    lastNotarizationDate;
        uint    version;
    }

    // ProcurementId => NotarizedProcurement
    mapping (uint => NotarizedProcurement) public notarizedProcurement;

    // Id of the procurement, hash of the document list, 
    // notarization date (now) and version 
    event ProcurementNotarized(uint, bytes32, uint, uint);

    modifier onlyOwner 
    {
        require(registry.getId(msg.sender) == ownerId, "Só o proprietário pode executar essa função");
        _;
    }

    constructor (address registryAddr)
    {
        registry = RBBRegistry(registryAddr);
        ownerId = registry.getId(msg.sender);

    }

    function notarizeProcurement (uint procurementId, byte32 documentListHash) 
        public onlyOwner
    {   
        // If there is no value set to this procurementId...
        if (notarizedProcurement[procurementId].documentListHash == 0)
        {
            procurement = NotarizedProcurement(documentListHash, now, 1);
        }
        else
        {
            procurement = notarizedProcurement[procurementId];
            procurement.documentListHash = documentListHash;
            procurement.lastNotarizationDate = now;
            procurement.version += 1;
        }

        emit ProcurementNotarized(procurementId, procurement.documentListHash, 
            procurement.lastNotarizationDate, procurement.version);
    }
}