pragma solidity ^0.4.24;

contract RoContract {


    struct Ro {
        bool initialized;
        bytes32 prevRo;
    }

    struct Resource{
        string resourceRole;
        bool loaded;
    }

    mapping(address => bytes32[]) private scientistROs;
    mapping(bytes32  => Ro) private roStore;

    mapping(string => bytes32[]) private scientistRscs;

    mapping(bytes32 => Resource) private rscStore;
    mapping(bytes32 => bytes32[]) private roRSCs;

    event logRoRsc(address, string rscHash, string roHash);
    event logNewRsc(address, string rscIPFS, string rscOwner);
    event LogChanges(string newRO, string oldRO, string changePurpoe);
    event CreateRO(address account, string ipfsHash);
    event RejectRO(address account, string message);

    enum ValidationRslt{VALID, NOT_VALID, NEW_RSC} ValidationRslt validationRslt;

    function uploadRo(bytes32 ipfsAddress, bytes32 _digest) public {
       if(roStore[ipfsAddress].initialized){
         return;
       }
        roStore[ipfsAddress]= Ro( true,_digest );
    }

    function addScietistRO(bytes32 _digest) public{

    scientistROs[msg.sender].push( _digest);
    }

    function getNumberofPacs(address scientist) public constant returns (uint) {
        return scientistROs[scientist].length;
    }

    function isRoLoaded (bytes32 s) public constant returns (bool){
        return (roStore[s].initialized);
    }

    function validateResource(bytes32 rcsIpfsDigest, string owner) public constant  returns (ValidationRslt){

        if (!rscStore[rcsIpfsDigest].loaded){
            return ValidationRslt.NEW_RSC;
        }

        for (uint i =0;i< scientistRscs[owner].length; i++){
        if (scientistRscs[owner][i] == rcsIpfsDigest){
            return ValidationRslt.VALID;
        }
         return ValidationRslt.NOT_VALID;
      }

    }
    function addNewRsc(bytes32 rcsIpfsDigest, string role) public{
        rscStore[rcsIpfsDigest] = Resource(role, true);
    }

    function addScietistRsc(string owner, bytes32 _digest) public{

        scientistRscs[owner].push(_digest);
    }

    function addRoRsc(bytes32 roIPFSDigest, bytes32 rscIPFSDigest) public {


        roRSCs[roIPFSDigest].push(rscIPFSDigest);
    }


    function getNumberofScientistRcs(string scientist) public constant returns(uint){

        return scientistRscs[scientist].length;
    }


    function isRscLoaded(bytes32 rscDigest) public constant returns(bool){

        return rscStore[rscDigest].loaded;
    }


    function getNumberofRcsPerPac(bytes32 roDigest) public constant returns(uint){

        return roRSCs[roDigest].length;
    }

}
