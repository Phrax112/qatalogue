
//*******************
// GLOBAL VARIABLES
//*******************

.ld.PATH,:`:/home/gmoy/workspace/qatalogue/
.ld.getOnce"schemas/services.q";

//*******************
// FUNCTIONS
//*******************

incrementServiceNode:{[svc]
	`int$exec 1|1+first desc node from SERVICES where project=svc[0],cluster=svc[1],service=svc[2]
	}

addService:{[svc;host;port;encrypt]
	.log.info("Adding service";svc;"located on";host;port;"requires encryption:";encrypt);
	if[not type[svc]=-11h;'"Service should be a symbol!"];
	if[not 3=count svcBkdwn:` vs svc;'"Service should be in format PROJECT.CLUSTER.SERVICE"];
	node:incrementServiceNode[svcBkdwn];
	svc:` sv (svc;`$string node);
	.log.info("Service name:";svc);
	`SERVICES upsert svc,svcBkdwn,node,host,port,encrypt,1b,0b,.z.p;
	}

removeService:{[svc]
	.log.info("Removing service:";svc);
	svc:` vs svc;
	removeNode each exec name from SERVICES where project=svc[0],cluster=svc[1],service=svc[2];
	}

removeNode:{[svc]
	.log.info("Removing node:";svc);
	.[`SERVICES;();_;svc];
	}
