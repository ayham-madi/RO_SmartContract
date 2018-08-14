pragma solidity ^0.4.24;

contract StoreContract {

    struct Ro {
        string ipfsAddress;
        address owner;
        string previousRo;
        bool initialized;
    }

    struct Resource{
        string resourceIPFShash;
        string resourceOwner;
        string resourceRole;
        bool loaded;
    }

    mapping(string  => string) private store;
    mapping(string  => Ro) private roStore;
    mapping(string => Resource) private rscStore;
    mapping(string => Resource[]) private roRSCs;

    event CreateRO(address account, string ipfsHash);
    event RejectRO(address account, string message);

    event CreateRoRsc(address, string rscHash, string roHash);
    event addNewRsc(address, string rscIPFS, string rscOwner);

    event LogChanges(string newRO, string oldRO, string changePurpoe);

    function loadRo(string ipfsAddress, string preRo) public{

      if(roStore[ipfsAddress].initialized){
          emit RejectRO( msg.sender, "Package already uploaded");
          return;
      }

      roStore[ipfsAddress] = Ro(ipfsAddress, msg.sender, preRo, true);
      emit CreateRO(msg.sender, ipfsAddress);
    }

    function validateResource(string rcsIpfs, string owner) public constant  returns (bool){

        if(rscStore[rcsIpfs].loaded){
            if(keccak256(owner) == keccak256(rscStore[rcsIpfs].resourceOwner)){
                return true;
            }else{
                return false;
            }
        }
        return true;
    }

    function addRoRsc(string roIPFS, string rscIPFS, string rscOwner, string rscRole ) public constant{

        if(!rscStore[rscIPFS].loaded){
            rscStore[rscIPFS] =  Resource(roIPFS, rscOwner, rscRole, true);
            emit addNewRsc(msg.sender, rscIPFS, rscOwner);
        }
        roRSCs[roIPFS].push(Resource(roIPFS, rscOwner, rscRole, true));
        emit CreateRoRsc(msg.sender,rscIPFS, roIPFS );
    }


    function getValue(string ipfsAddress) public constant returns (string) {

       return roStore[ipfsAddress].ipfsAddress;
    }

     function getRSChash(string ipfsHash) public constant returns (string) {

       return rscStore[ipfsHash].resourceIPFShash;
    }

    function getRSCRole(string ipfsHash) public constant returns (string) {

       return rscStore[ipfsHash].resourceRole;
    }

    function getGetNumberOfRscs(string roHAsh) public constant returns(uint){
        return roRSCs[roHAsh].length;
    }

}

contract LogChanges is StoreContract {

       function logProcessRCSsChanges(string previousHash, string newHash) public constant returns (bool){


        string []previousProcessRcs;
        string []newProcessRcs;

        for (uint i = 0; i < getGetNumberOfRscs(previousHash); i++){

            if(keccak256(getRSCRole(previousHash)) == keccak256("process")){
                previousProcessRcs.push(getRSChash(previousHash));
            }

             if(keccak256(getRSCRole(newHash)) == keccak256("process")){
                newProcessRcs.push(getRSChash(newHash));
            }

        }

        bool change = false;

        for (uint k = 0; k< previousProcessRcs.length; k++){

            if (previousProcessRcs.length != newProcessRcs.length){
                change = true;
                break;
            }
            bool found = false;
            for (uint l = 0; l < newProcessRcs.length; l++){
                if (keccak256(previousProcessRcs[k]) == keccak256(newProcessRcs[l])){
                    found = true;
                    break;
                }
            }
            if(!found){
                change = true;
                break;
            }
        }

        return change;
    }


/*
      function logRCSsChanges(string previousHash, string newHash) public constant returns (bool){



        Resource []oldRSCs =  roRSCs[previousHash];
        Resource []newRSCs =  roRSCs[newHash];

        string []previousRcs;
        string []newRcs;

        for (uint i = 0; i < oldRSCs.length; i++){

            if(keccak256(getRSCRole(previousHash)) != keccak256("process")){
                previousRcs.push(oldRSCs[i].resourceIPFShash);
            }
            if(keccak256(newRSCs[i].resourceRole) != keccak256("process")){
                newRcs.push(newRSCs[i].resourceIPFShash);
            }
        }

        bool change = false;

        for (uint k = 0; k< previousRcs.length; k++){
            if (previousRcs.length != newRcs.length){
                change = true;
                break;
            }
            bool found = false;
            for (uint l = 0; l < newRcs.length; l++){
                if (keccak256(previousRcs[k]) == keccak256(newRcs[l])){
                    found = true;
                    break;
                }
            }
            if(!found){
                change = true;
                break;
            }
        }

        if (change){

            emit LogChanges( newHash,  previousHash, "reused");
        }else{
            emit LogChanges(newHash, previousHash, "repreduced");
        }

        return change;
    } */

}
