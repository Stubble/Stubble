#import "SBLHelpers.h"

BOOL SBLIsObjectType(const char *type) {
	return (strchr("@#", type[0]) != NULL);
}
