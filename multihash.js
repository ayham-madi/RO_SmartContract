import bs58 from 'bs58';


export function getBytes32FromMultiash(multihash) {
  const decoded = bs58.decode(multihash);

  return {
    digest: `0x${decoded.slice(2).toString('hex')}`,
    hashFunction: decoded[0],
    size: decoded[1],
  };
}


export function getMultihashFromBytes32(multihash) {
  const { digest, hashFunction, size } = multihash;
  if (size === 0) return null;

  // cut off leading "0x"
  const hashBytes = Buffer.from(digest.slice(2), 'hex');

  // prepend hashFunction and digest size
  const multihashBytes = new (hashBytes.constructor)(2 + hashBytes.length);
  multihashBytes[0] = hashFunction;
  multihashBytes[1] = size;
  multihashBytes.set(hashBytes, 2);

  return bs58.encode(multihashBytes);
}


export function parseContractResponse(response) {
  const [digest, hashFunction, size] = response;
  return {
    digest,
    hashFunction: hashFunction.toNumber(),
    size: size.toNumber(),
  };
}


export function getMultihashFromContractResponse(response) {
  return getMultihashFromBytes32(parseContractResponse(response));
}
