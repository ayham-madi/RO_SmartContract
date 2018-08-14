pragma solidity ^0.4.24;

contract StoreContract {

    struct Ro {
        string ipfsAddress;
        string previousRo;
        bool initialized;
    }
    mapping(address => Ro[]) private scientistROs;
    mapping(string  => Ro) private roStore;
    event CreateRO(address account, string ipfsHash);
    event RejectRO(address account, string message);

    function loadRo(string ipfsAddress, string preRo) public{

      

      roStore[ipfsAddress] = Ro(ipfsAddress, preRo, true);
      scientistROs[msg.sender].push(Ro(ipfsAddress, preRo, true));
      emit CreateRO(msg.sender, ipfsAddress);
    }

    function getValue(string ipfsAddress) public constant returns (string) {

       return roStore[ipfsAddress].ipfsAddress;
    }




}
