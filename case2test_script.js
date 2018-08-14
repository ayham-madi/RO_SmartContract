var ROManifestTxt = '{ "@context": ["https://w3id.org/bundle/context"],'+
'  "id": "RO:1111111",'+
'  "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb2RORORORO",'+
'  "previousRO":"-",'+
'  "aggregates": ['+
'    { "uri": "http://dx.doi.org/10.5281/zenodo.18877",'+
'      "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb2t1111",'+
'      "ResourceCategory": "input",'+
'      "owner": "http://orcid.org/0000-0001-1212-XXXX",'+
'      "bundledAs": { "uri": "urn:uuid:aaf448d5-bcdb-42fd-abb3-28ed4ddc93c3"}'+
'    },'+
'    { "uri": "/process.py",'+
'      "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb212121",'+
'      "ResourceCategory": "process",'+
'      "owner": "http://orcid.org/0000-0001-1212-XXXX",'+
'      "bundledAs": { "uri": "urn:uuid:2562a70c-93a3-4834-9f40-dc0217ebb300"}'+
'    },'+
'    { "uri": "/result.csv",'+
'      "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb2t1231",'+
'      "ResourceCategory": "result",'+
'      "owner": "http://orcid.org/0000-0001-1212-XXXX",'+
'      "bundledAs": { "uri": "urn:uuid:81c94a59-df75-4e3d-939b-dbd366a38328"}'+
'    }'+
'  ],'+
'  "createdBy": {'+
'    "name": "Ayham Madi",'+
'    "orcid": "http://orcid.org/0000-0001-1212-XXXX",'+
'    "uri": "http://example.com/user/ayham"'+
'  }'+
'}';

var ROManifestTxt1 = '{ "@context": ["https://w3id.org/bundle/context"],'+
'  "@id": "RO:122222",'+
'  "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb2ROROIII",'+
'  "previousRO":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb2RORORORO",'+
'  "aggregates": ['+
'    { "uri": "http://dx.doi.org/10.5281/zenodo.18877",'+
'      "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb2t1111",'+
'      "ResourceCategory": "input",'+
'      "owner": "http://orcid.org/0000-0001-1212-XXXX",'+
'      "bundledAs": { "uri": "urn:uuid:aaf448d5-bcdb-42fd-abb3-28ed4ddc93c3"}'+
'    },'+
'    { "uri": "/process.py",'+
'      "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb212233",'+
'      "ResourceCategory": "process",'+
'      "owner": "http://orcid.org/0000-0001-1212-XXXX",'+
'      "bundledAs": { "uri": "urn:uuid:2562a70c-93a3-4834-9f40-dc0217ebb300"}'+
'    },'+
'    { "uri": "/result.csv",'+
'      "IPFSHash":"QmWWQSuPMS6aXCbZKpEjPHPUZN2NjB3YrhJTHsV4X3vb2t3344",'+
'      "ResourceCategory": "result",'+
'      "owner": "http://orcid.org/0000-0001-1212-XXXX",'+
'      "bundledAs": { "uri": "urn:uuid:81c94a59-df75-4e3d-939b-dbd366a38328"}'+
'    }'+
'  ],'+
'  "createdBy": {'+
'    "name": "Ahmad Madi",'+
'    "orcid": "http://orcid.org/0000-0001-1313-XXXX",'+
'    "uri": "http://example.com/user/ayham"'+
'  }'+
'}';

var ROManifest0 = JSON.parse(ROManifestTxt);
var ROManifest1 = JSON.parse(ROManifestTxt1);

var i ;
var validRsource = false;
for(i= 0 ;i< ROManifest0.aggregates.length;i++){
  console.log("validateResource("+ROManifest0.aggregates[i].IPFSHash+", "+ROManifest0.aggregates[i].owner+")");
  validRsource=contractInstance.validateResource(ROManifest0.aggregates[i].IPFSHash, ROManifest0.aggregates[i].owner);
  console.log(validRsource);
  if(!validRsource){
    throw new Error("Invalid resource");
  }
}


var j ;
var validRsource = false;
for(j= 0 ;j< ROManifest1.aggregates.length;j++){
  console.log("validateResource("+ROManifest1.aggregates[j].IPFSHash+", "+ROManifest1.aggregates[j].owner+")");
  validRsource=contractInstance.validateResource(ROManifest1.aggregates[j].IPFSHash, ROManifest1.aggregates[j].owner);
  console.log(validRsource);
  if(!validRsource){
    throw new Error("Invalid resource");
  }
}

console.log(contractInstance.loadRo(ROManifest1.IPFSHash, ROManifest1.previousRO));


for(i= 0 ;i< ROManifest1.aggregates.length;i++){

  console.log("adding resource ("+ROManifest1.IPFSHash, ROManifest1.aggregates[i].IPFSHash, ROManifest1.aggregates[i].owner, ROManifest1.aggregates[i].ResourceCategory);
  contractInstance.addRoRsc(ROManifest1.IPFSHash, ROManifest1.aggregates[i].IPFSHash, ROManifest1.aggregates[i].owner, ROManifest1.aggregates[i].ResourceCategory);
}


console.log(contractInstance.getRoPurpose(ROManifest1.previousRO, ROManifest1.IPFSHash));
