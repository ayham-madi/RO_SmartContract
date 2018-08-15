pragma solidity ^0.4.24;

contract RoContract {

    struct Multihash {
        bytes32 digest;
        uint8 hashFunction;
        uint8 size;
    }

    struct Ro {
        bool initialized;
        Multihash prevRo;
    }

    struct Resource{
        string resourceRole;
        bool loaded;
    }

    mapping(address => Multihash[]) private scientistROs;
    mapping(string  => Ro) private roStore;

    mapping(string => Multihash[]) private scientistRscs;

    mapping(string => Resource) private rscStore;
    mapping(string => Multihash[]) private roRSCs;

    event addRoRsc(address, string rscHash, string roHash);
    event addNewRsc(address, string rscIPFS, string rscOwner);
    event LogChanges(string newRO, string oldRO, string changePurpoe);
    event CreateRO(address account, string ipfsHash);
    event RejectRO(address account, string message);

    function uploadRo(string ipfsAddress, bytes32 _digest, uint8 _hashFunction, uint8 _size) public {
       if(roStore[ipfsAddress].initialized){
          emit RejectRO( msg.sender, "Package already uploaded");
         return;
       }
        roStore[ipfsAddress]= Ro( true, Multihash(_digest, _hashFunction, _size) );
        emit CreateRO(msg.sender,  ipfsAddress);
    }
    function getNumberofrscPacs(string roIPFS) public constant returns (uint){
        return roRSCs[roIPFS].length;
    }

    function addScietistRO(bytes32 _digest, uint8 _hashFunction, uint8 _size) public{
    Multihash memory entry = Multihash(_digest, _hashFunction, _size);
    scientistROs[msg.sender].push(entry);

    }

    function getNumberofPacs(address scientist) public constant returns (uint) {
        return scientistROs[scientist].length;
    }

    function isLoaded (string s) public constant returns (bool){
        return (roStore[s].initialized);
    }


}
