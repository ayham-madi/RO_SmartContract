

var solc = require('solc');
var Web3 = require('web3');
var fs = require('fs');
const bs58 = require('bs58')

var manifestJSON = JSON.parse(fs.readFileSync('test cases/Case 1 /manifest.json', 'utf8'));

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  // set the provider you want from Web3.providers
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
var addr = ('0x7748441efde3970f01d6cf660751f9d188702590');
var defaultAccount = web3.eth.defaultAccount ="7748441efde3970f01d6cf660751f9d188702590";

web3.eth.defaultAccount =defaultAccount;

web3.eth.getBalance(addr, function (error, result) {
	if (!error)
    console.log(result)
	else
		console.log( error);
});

var defaultAccount = web3.eth.defaultAccount ="7748441efde3970f01d6cf660751f9d188702590";

web3.eth.defaultAccount =defaultAccount;

var filepath = 'StoreContract.sol';

var input = fs.readFileSync(filepath).toString();

var output = solc.compile(input, 1); // 1 activates the optimiser

for (var contractName in output.contracts) {

var byteCode = '0x' + output.contracts[contractName].bytecode;
abi = JSON.parse(output.contracts[contractName].interface);
var myContract = new web3.eth.Contract(abi,{from: addr, gasPrice: '2100000'});

var deployContract = myContract.deploy({data:byteCode});
const { digest, hashFunction, size } = getBytes32FromMultiash(manifestJSON.IPFSHash.toString());

console.log(" d: "+ digest+ " h: "+hashFunction+ " s: "+size);
deployContract.send({from:web3.eth.coinbase, data:byteCode, gas: 2000000},function(error, transactionHash){ })
.on('error', function(error){  })
.on('transactionHash', function(transactionHash){ })
.on('receipt', function(receipt){
   console.log(receipt.contractAddress) // contains the new contract address
})
.on('confirmation', function(confirmationNumber, receipt){  })
.then(function(newContractInstance){

    console.log(newContractInstance.options.address) // instance with the new contract address
    newContractInstance.methods.addScietistRO(digest, hashFunction, size).send({from: addr}, function(error, result){
        console.log("result:" + result);
        console.log("addScietistRO adding:" + manifestJSON.IPFSHash);
    }).then(function(){
        console.log('reacall function');
    newContractInstance.methods.getNumberofPacs(addr).call({from: addr}).then(function(receipt){console.log("getNumberofPacs receipt: "+receipt);});
    });
    newContractInstance.methods.uploadRo(manifestJSON.IPFSHash, digest, hashFunction, size).send({from: addr}, function(error, result){
        console.log("result:" + result);

    }).then(function(){
        console.log('reacall function');;
        newContractInstance.methods.isLoaded(manifestJSON.IPFSHash).call({from: addr}).then(function(receipt){console.log("getRo receipt: "+receipt);});
    });

  });
}

function getBytes32FromMultiash(multihash) {
  const decoded = bs58.decode(multihash);

  return {
    digest: `0x${decoded.slice(2).toString('hex')}`,
    hashFunction: decoded[0],
    size: decoded[1],
  };

}
