


var manifestJSON = JSON.parse(fs.readFileSync('test cases/Case 1 /manifest.json', 'utf8'));



var deployContract = myContract.deploy({data:byteCode});
const { digest, hashFunction, size } = getBytes32FromMultiash(manifestJSON.IPFSHash.toString());

console.log(digest+ hashFunction+ size);


function getBytes32FromMultiash(multihash) {
  const decoded = bs58.decode(multihash);

  return {
    digest: `0x${decoded.slice(2).toString('hex')}`,
    hashFunction: decoded[0],
    size: decoded[1],
  };
}
