pragma solidity ^0.4.24;

contract RoContract {

    struct Ro {
        bool initialized;
        string prevRo;
    }

    struct Resource{
        string resourceRole;
        bool loaded;
    }


    mapping(address => string[]) private scientistROs;
    mapping(string  => Ro) private roStore;


    mapping(string => string[]) private scientistRscs;

    mapping(string => Resource) private rscStore;
    mapping(string => string[]) private roRSCs;

/*

    event addRoRsc(address, string rscHash, string roHash);
    event addNewRsc(address, string rscIPFS, string rscOwner);
    event LogChanges(string newRO, string oldRO, string changePurpoe);
    event CreateRO(address account, string ipfsHash);
    event RejectRO(address account, string message);*/

    function uploadRo(string ipfsAddress, string prero) public {
        if(roStore[ipfsAddress].initialized){
          //emit RejectRO( msg.sender, "Package already uploaded");
         return;
      }
        roStore[ipfsAddress]= Ro(true, prero );
    }
    function addRO(string s) public {
        scientistROs[msg.sender].push(s);

    }
    function getNumberofPacs(address scientist) public constant returns (uint) {


        return scientistROs[scientist].length;

    }

    function getRo (string s) public constant returns (string){

        return (roStore[s].prevRo);

    }


  /*  function validateResource(string rcsIpfs, string owner) public constant  returns (bool){

        if(rscStore[rcsIpfs].loaded){

            for(uint i = 0 ;i < scientistRscs[owner].length ;i++ ){
                if( keccak256(scientistRscs[owner][i]) == keccak256(rcsIpfs)){
                 return true;
                }
            }

            return false;
        }
        return true;
    }*/


   // function addRoNewRsc(string roIPFS, string rscIPFS, string rscOwner, string rscRole ) public {
    function addRoNewRsc(string roIPFS, string rscIPFS) public {
        /*if(!rscStore[rscIPFS].loaded){
            rscStore[rscIPFS] =  Resource( rscRole, true);
            scientistRscs[rscOwner].push(rscIPFS);
            emit addNewRsc(msg.sender, rscIPFS, rscOwner);

        }*/
        roRSCs[roIPFS].push(rscIPFS);
        //emit addRoRsc(msg.sender,rscIPFS, roIPFS );
    }

    function getNumberofrscPacs(string roIPFS) public constant returns (uint){
        return roRSCs[roIPFS].length;
    }






}
