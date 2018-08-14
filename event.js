contractInstance.allEvents({}, { fromBlock: 0, toBlock: 'latest' }).get(function(error, eventResult) {
  if (error)
    console.log('Error in myEvent event handler: ' + error);
  else
    console.log('Event: ' + JSON.stringify(eventResult.args));
});
