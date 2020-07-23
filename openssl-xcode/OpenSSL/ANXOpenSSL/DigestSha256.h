#pragma once
#include<string>
#include "FlashRuntimeExtensions.h"


class DigestSha256
{
public:
	FREObject computeSHA256(FREObject fobject);
private:
	FREObject computeSHA256(char *str, int len, char *out);
};

