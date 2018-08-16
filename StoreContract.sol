pragma solidity ^0.4.24;

contract RoContract {


    struct Ro {
        bool initialized;
        bytes32 prevRo;
    }

    struct AggResource{
        bytes32 ipfsDigest;
        string resourceRole;
    }



    mapping(address => bytes32[]) private scientistROs;
    mapping(bytes32  => Ro) private roStore;

    mapping(string => bytes32[]) private scientistRscs;

    mapping(bytes32 => bool) private rscStore;
    //mapping(bytes32 => bytes32[]) private roRSCs;

    mapping(bytes32 => AggResource[]) private roRSCss;

    enum ValidationRslt{VALID, NOT_VALID, NEW_RSC} ValidationRslt validationRslt;
    enum RscRole {INPUT, PROCESS, RESULT} RscRole rscRole;
    function uploadRo(bytes32 ipfsAddress, bytes32 predigest) public {
       if(roStore[ipfsAddress].initialized){
         return;
       }
        roStore[ipfsAddress]= Ro( true, predigest );
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

        if (!rscStore[rcsIpfsDigest]){
            return ValidationRslt.NEW_RSC;
        }

        for (uint i =0;i< scientistRscs[owner].length; i++){
        if (scientistRscs[owner][i] == rcsIpfsDigest){
            return ValidationRslt.VALID;
        }
      }
    return ValidationRslt.NOT_VALID;

    }
    function addNewRsc(bytes32 rcsIpfsDigest) public{
        rscStore[rcsIpfsDigest] = true;
    }

    function addScietistRsc(string owner, bytes32 _digest) public{

        scientistRscs[owner].push(_digest);
    }

    function addRoRsc(bytes32 roIPFSDigest, bytes32 rscIPFSDigest, string role) public {

        roRSCss[roIPFSDigest].push(AggResource(rscIPFSDigest, role));
        //roRSCs[roIPFSDigest].push(rscIPFSDigest);
    }

    function returnAggRsc(bytes32 ro, bytes32 rsc) public constant returns(string){
        for (uint i = 0 ; i< roRSCss[ro].length; i++){
            if (roRSCss[ro][i].ipfsDigest == rsc){
                return  roRSCss[ro][i].resourceRole;
            }
        }

        return "null";

    }



    function getNumberofScientistRcs(string scientist) public constant returns(uint){

        return scientistRscs[scientist].length;
    }


    function isRscLoaded(bytes32 rscDigest) public constant returns(bool){

        return rscStore[rscDigest];
    }


    function getNumberofRcsPerPac(bytes32 roDigest) public constant returns(uint){

        return roRSCss[roDigest].length;
    }


    function getROPurpose(bytes32 preDigest, bytes32 newDigest)public constant returns(string){

        bool isRcsChanged = false;
        for(uint i = 0 ; i < roRSCss[preDigest].length ;i++ ){
            for(uint j= 0 ; j< roRSCss[newDigest].length; j++){

                if (pacContainsRcs(preDigest, roRSCss[newDigest][i].ipfsDigest)){
                    continue;
                }else{
                    isRcsChanged = true;
                    if(keccak256(roRSCss[preDigest][i].resourceRole) == keccak256("process")){
                        return "Modified";
                    }
                }
            }
        }
        if(isRcsChanged){
            return "reused";
        }else{
            return "repreduced";
        }
    }


    function pacContainsRcs(bytes32 pacDigest, bytes32 rcsDigest) public constant returns (bool){


        for (uint i = 0 ; i< roRSCss[pacDigest].length; i++)
        {
            if (roRSCss[pacDigest][i].ipfsDigest == rcsDigest){
                return true;
            }
        }

        return false;
    }


    event AddRoRsc(address, string rscHash, string roHash);
    event AddNewRsc(address, string rscIPFS, string rscOwner);
    event NewChange(string newRO, string oldRO, string changePurpoe);
    event CreateRO(address account, string ipfsHash);
    event RejectRO(address account, string message);


    function logAddRoRsc(string rscHash, string roHash)public{
        emit AddRoRsc(msg.sender,  rscHash,  roHash);
    }

    function logAddNewRsc(string rscIPFS, string rscOwner)public{
        emit AddNewRsc(msg.sender,  rscIPFS,  rscOwner);

    }

    function logNewChange(string newRO, string oldRO, string changePurpoe)public{
        emit NewChange( newRO,  oldRO,  changePurpoe);
    }

    function logCreateRO( string ipfsHash)public{
        emit CreateRO(msg.sender ,  ipfsHash);
    }

    function logRejectRO( string message)public{
        emit RejectRO(msg.sender ,  message);
    }







}
