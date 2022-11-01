From: "Accardi, Kristen C" <kristen.c.accardi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: clarification about misc controller and capacity vs. max
Date: Tue, 1 Nov 2022 16:40:22 +0000
Message-ID: <2f7b7d6b10bdcbc9a73ea449d3636575124afa25.camel@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667320825; x=1698856825;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=sM0CAe0h1xIfZR6B5nhj2Lu5/wz/p1dk+jzqRAKMtFE=;
  b=YkHKdVSUk0Zjlaag1XxHYNNaZJcbwd624HgHZlB4U2Z0DSHgfKXZwYHm
   FQldaPbhdlM6ZG6pEwSSwMGCVYLckl7bZfTvYiSoQwBJZxAdqsCiGEvX0
   bHWIxmYBWMYLojlL45FhTCqB92P6xvHc9nVTkVm1epWS09Hn0JIp61KHS
   u6Cp+oozAx0bCJDUYhCEh4tX6GcM3CbT2PGNNdC90wWUBaLXa3WgNY3oH
   oz+OozAidJjHI66sDBWt8puIs6eNFVeuZmgsc9/m2cfTJaRsZl5IIAWTW
   ytF529svrNkoc2D7K9wOAV08JgfonJjnQMVldIkezTF5fSdmkxeY2Lmpk
   g==;
Content-Language: en-US
Content-ID: <64FF881EB77A744184D02C8D12B917E7-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

SGkgdGhlcmUsDQpJIG5vdGljZSBpbiB0aGUgY29tbWVudHMgZm9yIHRoZSBtaXNjIGNvbnRyb2xs
ZXIgaXQgaXMgc3RhdGVkIHRoYXQgdGhlDQptYXggbGltaXQgY2FuIGJlIG1vcmUgdGhhbiBhY3R1
YWwgdG90YWwgY2FwYWNpdHksIG1lYW5pbmcgdGhhdCB3ZSBjYW4NCm92ZXJjb21taXQgd2l0aCB0
aGUgcmVzb3VyY2UgY29udHJvbGxlZCBieSB0aGUgbWlzYyBjb250cm9sbGVyLg0KSG93ZXZlciwg
aW4gdGhlIG1pc2NfY2dfdHJ5X2NoYXJnZSgpIGNvZGUsIHRoZSBmdW5jdGlvbiB3aWxsIHJldHVy
biAtDQpFQlVTWSBpZiBtYXggbGltaXQgd2lsbCBiZSBjcm9zc2VkIG9yIHRvdGFsIHVzYWdlIHdp
bGwgYmUgbW9yZSB0aGFuIHRoZQ0KY2FwYWNpdHksIHdoaWNoIHdvdWxkIHNlZW0gdG8gZW5mb3Jj
ZSB0b3RhbCBjYXBhY2l0eSBhcyBhbiB1cHBlciBsaW1pdA0KaW4gYWRkaXRpb24gdG8gbWF4IGFu
ZCBub3QgYWxsb3cgZm9yIG92ZXJjb21taXQuIENhbiB5b3UgcHJvdmlkZSBzb21lDQpjbGFyaXR5
IG9uIHdoZXRoZXIgdGhlIHJlc291cmNlIGNvbnN1bXB0aW9uIG1vZGVsIGZvciB0aGUgbWlzYw0K
Y29udHJvbGxlciBzaG91bGQgYWxsb3cgZm9yIG92ZXJjb21taXQ/DQoNClRoYW5rcywNCktyaXN0
ZW4gQWNjYXJkaQ0KDQo=
