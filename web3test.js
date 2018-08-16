var solc = require('solc');
var Web3 = require('web3');
var fs = require('fs');
const bs58 = require('bs58');

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
//const { digest, hashFunction, size } = getBytes32FromMultiash(manifestJSON.IPFSHash.toString());

//console.log(" d: "+ digest+ " h: "+hashFunction+ " s: "+size);
deployContract.send({from:web3.eth.coinbase, data:byteCode, gas: 2000000},function(error, transactionHash){ })
.on('error', function(error){  })
.on('transactionHash', function(transactionHash){ })
.on('receipt', function(receipt){
   console.log(receipt.contractAddress) // contains the new contract address
})
.on('confirmation', function(confirmationNumber, receipt){  })
.then(async function(newContractInstance){


  var rodigest = getBytes32FromMultiash(manifestJSON.IPFSHash.toString());
  var isPackLoaded;
  await newContractInstance.methods.isRoLoaded(rodigest).call({from: addr}).then(async function(receipt){console.log("isRscLoaded receipt: "+receipt); isPackLoaded = receipt;});
  if(isPackLoaded){
    throw "Package is already uploaded!!";
  }
  for (i=0; i< manifestJSON.aggregates.length;i++){
    var rscdigest = getBytes32FromMultiash(manifestJSON.aggregates[i].IPFSHash.toString());
    // Validate the owner of the aggregated resource
    await newContractInstance.methods.validateResource(rscdigest,manifestJSON.aggregates[i].owner).call({from: addr}).then(async function(receipt){ if(receipt ==1 ) throw "this resource "+manifestJSON.aggregates[i].IPFSHash +" is not cited properly!!";});

  }

  //Adding resources .....
  var i;
  for (i=0; i< manifestJSON.aggregates.length;i++){
  var rscdigest = getBytes32FromMultiash(manifestJSON.aggregates[i].IPFSHash.toString());

  var isLoaded;
  await newContractInstance.methods.isRscLoaded(rscdigest).call({from: addr}).
  then(async function(receipt){console.log("isRscLoaded receipt: "+receipt); isLoaded = receipt;});
  if(!isLoaded){

  console.log("adding new Resource" + manifestJSON.aggregates[i].IPFSHash);
  await newContractInstance.methods.addNewRsc(rscdigest, manifestJSON.aggregates[i].ResourceCategory).send({from: addr}, function(error, result){
      //console.log("result:" + result);
    //  console.log("addScietistRO adding:" +rscdigest);
  });
  await newContractInstance.methods.addScietistRsc(manifestJSON.aggregates[i].owner, rscdigest).send({from: addr}, function(error, result){
      //console.log("result:" + result);
    //  console.log("addScietistRO adding:" +rscdigest);
  }).then(async function(){
    //  console.log('reacall function');
//  await newContractInstance.methods.getNumberofScientistRcs(manifestJSON.aggregates[0].owner).call({from: addr}).then(async function(receipt){console.log("getNumberofScientistRcs receipt: "+receipt);});
  });
  }

  await newContractInstance.methods.addRoRsc(rodigest, rscdigest).send({from: addr}, function(error, result){
      //console.log("result:" + result);
      // console.log("addScietistRO adding:" +rscdigest);
  }).then(async function(){
    //  console.log('reacall function');
  //await newContractInstance.methods.getNumberofRcsPerPac(rodigest).call({from: addr}).then(async function(receipt){console.log("getNumberofRcsPerPac receipt: "+receipt);});
  });
}
  //Adding Ro Pack
  //console.log(newContractInstance.options.address) // instance with the new contract address
  await newContractInstance.methods.addScietistRO(rodigest).send({from: addr}, function(error, result){
    //console.log("result:" + result);
    //  console.log("addScietistRO adding:" +digest);
  }).then(async function(){
    //  console.log('reacall function');
  //await newContractInstance.methods.getNumberofPacs(addr).call({from: addr}).then(function(receipt){console.log("getNumberofPacs receipt: "+receipt);});
  });
  var prePacdigest;

  prePacdigest = getBytes32FromMultiash(manifestJSON.previousRO);

  await newContractInstance.methods.uploadRo(rodigest, prePacdigest).send({from: addr}, function(error, result){}).then(async function(){

    if(prePacdigest=="0x"){
      console.log(manifestJSON.previousRO + "New Package");
    }else{
      await newContractInstance.methods.getROPurpose( prePacdigest, rodigest).call({from: addr}).then(function(receipt){console.log("getROPurpose receipt: "+receipt);});

    }

  });

  var prePacdigest;

prePacdigest = getBytes32FromMultiash(manifestJSON.previousRO);


});
}

function getBytes32FromMultiash(multihash) {

  const decoded = bs58.decode(multihash);
  if(multihash === ""){
    return `0x`;
  }
  return  `0x${decoded.slice(2).toString('hex')}`;
}
