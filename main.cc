/**
 * Links two or more already running job managers by retrieving their search
 * nodes and exchanging the respective accesspoints.
 *
 * All the job managers provided by the access strings on the command line are
 * registered to all others.
 *
 * Usage: pop-link access-string access-string [access-string ...]
 *
 * @author: Jonathan Stoppani <jonathan.stoppani@edu.hefr.ch>
 *
 */

#import "jobmgr.ph"

#define USAGE "Usage: %s access-string access-string [access-string ...]\n"

int main(int argc, char * argv[])
{
	JobMgr* jobmgrs[argc];
	paroc_accesspoint nodes[argc];
	
	if (argc < 3) {
		printf("Provide at least two access strings!\n");
		printf(USAGE, argv[0]);
	}
	
	// Construct the arrays of jobmanagers and respective node access points
	for (int i=1; i<argc; i++) {
		paroc_accesspoint ap;
		ap.SetAccessString(argv[i]);
		jobmgrs[i] = new JobMgr(ap);
		nodes[i] = jobmgrs[i]->GetNodeAccessPoint();
	}
	
	// Register each node to each other (excluded iself)
	// NOTE: We don't actually check if two access strings provided in the
	//       arguments point to the same remote object.
	for (int i=1; i<argc; i++) {
		for (int j=1; j<argc; j++) {
			if (i != j) {
				jobmgrs[i]->RegisterNode(nodes[j]);
			}
		}
	}
	
	// Be wise, free them up even if the program is going to terminate
	for (int i=1; i<argc; i++) {
		delete jobmgrs[i];
	}
	
	return 0;
}