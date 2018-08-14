pragma solidity ^0.4.24;

contract RoContract {

    struct Ro {
        bool initialized;
        string ipfsHash;
        string prevRo;
    }

    struct Resource{
        string resourceIPFShash;
        string resourceRole;
        bool loaded;
    }

    mapping(address => Ro[]) private scientistROs;// by address
    mapping(string  => Ro) private roStore; //by ipfs hash


    mapping(string => Resource) private rscStore;
    mapping(string => Resource[]) private roRSCs;
    mapping(string => string[]) private scientistRscs; //

    event addRoRsc(address, string rscHash, string roHash);
    event addNewRsc(address, string rscIPFS, string rscOwner);
    event LogChanges(string newRO, string oldRO, string changePurpoe);
    event CreateRO(address account, string ipfsHash);
    event RejectRO(address account, string message);

    function uploadRo(string ipfsAddress, string prero) public {

        if(roStore[ipfsAddress].initialized){
              emit RejectRO( msg.sender, "Package already uploaded");
              return;
          }
        scientistROs[msg.sender].push(Ro(true, ipfsAddress, prero));
    }
    function getNumberofPacs(address scientist) public constant returns (uint) {

        return scientistROs[scientist].length;

    }

}
