From: "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [PATCH v3 03/28] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Mon, 24 Jul 2023 23:31:58 +0000
Message-ID: <9ffb02a3344807f2c173fe8c7cb000cd6c7843b6.camel@intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
         <20230712230202.47929-4-haitao.huang@linux.intel.com>
         <CU4GHCJTRKLZ.1RK23NWPHJGNI@seitikki>
         <op.17794m01wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <4f5496d2e0ea8edba430e7de7304bdd840616146.camel@intel.com>
         <op.18lc2zw6wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690241522; x=1721777522;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8mzYeu1oXjOeMtK7JMoF4OO5xewYr2FHumnDfLdYh8M=;
  b=Fa72rxthJZEeL3kKWiqVYh5EXdZUN7C3wZnDt53fsZEttJg1N5MeUkNR
   B2hcl4cBV+0pJRkjY2rkTyJs6X2064lUySbioeoF36Hc7aceZiU1bC8fu
   DuvwcMp59o1n8NTpptJZRdFa8KTfwbBWGPcLpmiF5fVVJF+EYvMYvczzc
   alhlh7Z6PZQqWIpWuVc3SoSAtK+EI+BclHg9/iLXtA3unexM9V7cHNxcD
   IxIahQX7z0kiBPLpu4iqPeT+36BwtwqPBO6JFAu6GPcRn83haiLRQkuQ8
   zMrfPqJTOuyW836HtTN6NfgNxZBQ77cILS2cRwwA3qhM9MH/u+pHZvTyG
   Q==;
In-Reply-To: <op.18lc2zw6wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <6A25B34C2634EC49960625C2E4C6404C@namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "mingo@redhat.com" <mingo@redhat.com>, "jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>, "tj@kernel.org" <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>
Cc: "kristen@linux.intel.com" <kristen@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Christopherson,, Sean" <seanjc@google.com>

T24gTW9uLCAyMDIzLTA3LTI0IGF0IDA5OjU1IC0wNTAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IEhpIEthaQ0KPiBPbiBNb24sIDI0IEp1bCAyMDIzIDA1OjA0OjQ4IC0wNTAwLCBIdWFuZywgS2Fp
IDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gTW9uLCAyMDIzLTA3LTE3
IGF0IDA4OjIzIC0wNTAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+ID4gPiBPbiBNb24sIDE3IEp1
bCAyMDIzIDA3OjQ1OjM2IC0wNTAwLCBKYXJra28gU2Fra2luZW4gPGphcmtrb0BrZXJuZWwub3Jn
Pg0KPiA+ID4gd3JvdGU6DQo+ID4gPiANCj4gPiA+ID4gT24gV2VkIEp1bCAxMiwgMjAyMyBhdCAx
MTowMSBQTSBVVEMsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4gPiA+ID4gPiBGcm9tOiBLcmlzdGVu
IENhcmxzb24gQWNjYXJkaSA8a3Jpc3RlbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gSW50cm9kdWNlIGEgZGF0YSBzdHJ1Y3R1cmUgdG8gd3JhcCB0aGUgZXhpc3Rpbmcg
cmVjbGFpbWFibGUgbGlzdA0KPiA+ID4gPiA+IGFuZCBpdHMgc3BpbmxvY2sgaW4gYSBzdHJ1Y3Qg
dG8gbWluaW1pemUgdGhlIGNvZGUgY2hhbmdlcyBuZWVkZWQNCj4gPiA+ID4gPiB0byBoYW5kbGUg
bXVsdGlwbGUgTFJVcyBhcyB3ZWxsIGFzIHJlY2xhaW1hYmxlIGFuZCBub24tcmVjbGFpbWFibGUN
Cj4gPiA+ID4gPiBsaXN0cy4gVGhlIG5ldyBzdHJ1Y3R1cmUgd2lsbCBiZSB1c2VkIGluIGEgZm9s
bG93aW5nIHNldCBvZiBwYXRjaGVzICANCj4gPiA+IHRvDQo+ID4gPiA+ID4gaW1wbGVtZW50IFNH
WCBFUEMgY2dyb3Vwcy4NCj4gPiANCj4gPiBBbHRob3VnaCBicmllZmx5IG1lbnRpb25lZCBpbiB0
aGUgZmlyc3QgcGF0Y2gsIGl0IHdvdWxkIGJlIGJldHRlciB0byBwdXQgIA0KPiA+IG1vcmUNCj4g
PiBiYWNrZ3JvdW5kIGFib3V0IHRoZSAicmVjbGFpbWFibGUiIGFuZCAibm9uLXJlY2xhaW1hYmxl
IiB0aGluZyBoZXJlLCAgDQo+ID4gZm9jdXNpbmcgb24NCj4gPiBfd2h5XyB3ZSBuZWVkIG11bHRp
cGxlIExSVXMgKHByZXN1bWFibHkgeW91IG1lYW4gdHdvIGxpc3RzOiByZWNsYWltYWJsZSAgDQo+
ID4gYW5kIG5vbi0NCj4gPiByZWNsYWltYWJsZSkuDQo+ID4gDQo+IFN1cmUgSSBjYW4gYWRkIGEg
bGl0dGxlIG1vcmUgYmFja2dyb3VuZCB0byBpbnRyb2R1Y2UgdGhlICANCj4gcmVjbGFpbWFibGUv
dW5yZWNsYWltYWJsZSBjb25jZXB0LiBCdXQgd2h5IHdlIG5lZWQgbXVsdGlwbGUgTFJVcyB3b3Vs
ZCBiZSAgDQo+IHNlbGYtZXZpZGVudCBpbiBsYXRlciBwYXRjaGVzLCBub3Qgc3VyZSBJIHdpbGwg
YWRkIGRldGFpbHMgaGVyZS4NCg0KSW4gdGhpcyBjYXNlIHBlb3BsZSB3aWxsIG5lZWQgdG8gZ28g
dG8gdGhhdCBwYXRjaCB0byBnZXQgc29tZSBpZGVhIGZpcnN0LiAgSXQNCmRvZXNuJ3Qgc2VlbSBo
dXJ0IGlmIHlvdSBjYW4gZXhwbGFpbiB3aHkgeW91IG5lZWQgbXVsdGlwbGUgTFJVcyBoZXJlIGZp
cnN0Lg0KDQpbLi4uXQ0KDQo+ID4gPiA+ID4gK3N0cnVjdCBzZ3hfZXBjX2xydV9saXN0cyB7DQo+
ID4gPiA+ID4gKwkvKiBNdXN0IGFjcXVpcmUgdGhpcyBsb2NrIHRvIGFjY2VzcyAqLw0KPiA+ID4g
PiA+ICsJc3BpbmxvY2tfdCBsb2NrOw0KPiA+ID4gPiANCj4gPiA+ID4gSXNuJ3QgdGhpcyBzZWxm
LWV4cGxhbmF0b3J5LCB3aHkgdGhlIGlubGluZSBjb21tZW50Pw0KPiA+ID4gDQo+ID4gPiBJIGdv
dCBhIHdhcm5pbmcgZnJvbSB0aGUgY2hlY2twYXRjaCBzY3JpcHQgY29tcGxhaW5pbmcgdGhpcyBs
b2NrIG5lZWRzDQo+ID4gPiBjb21tZW50cy4NCj4gPiANCj4gPiBJIHN1c3BlY3RlZCB0aGlzLCBz
byBJIGFwcGxpZWQgdGhpcyBwYXRjaCwgcmVtb3ZlZCB0aGUgY29tbWVudCwgIA0KPiA+IGdlbmVy
YXRlZCBhIG5ldw0KPiA+IHBhdGNoLCBhbmQgcnVuIGNoZWNrcGF0Y2gucGwgZm9yIGl0LiAgSXQg
ZGlkbid0IHJlcG9ydCBhbnkgd2FybmluZy9lcnJvciAgDQo+ID4gaW4gbXkNCj4gPiB0ZXN0aW5n
Lg0KPiA+IA0KPiA+IEFyZSB5b3Ugc3VyZSB5b3UgZ290IGEgd2FybmluZz8NCj4gDQo+IEkgZGlk
IGEgcmVyYW4gYW5kIGl0J3MgYWN0dWFsbHkgYSAiQ0hFQ0siIEkgZ290Og0KPiANCj4gJCAuL3Nj
cmlwdHMvY2hlY2twYXRjaC5wbCAtLXN0cmljdCAgDQo+IDAwMDEteDg2LXNneC1BZGQtc3RydWN0
LXNneF9lcGNfbHJ1X2xpc3RzLXRvLWVuY2Fwc3VsYXRlLS5wYXRjaA0KPiBDSEVDSzogc3Bpbmxv
Y2tfdCBkZWZpbml0aW9uIHdpdGhvdXQgY29tbWVudA0KPiAjNDE6IEZJTEU6IGFyY2gveDg2L2tl
cm5lbC9jcHUvc2d4L3NneC5oOjEwMToNCj4gKyAgICAgICBzcGlubG9ja190IGxvY2s7DQo+IA0K
PiB0b3RhbDogMCBlcnJvcnMsIDAgd2FybmluZ3MsIDEgY2hlY2tzLCAyMiBsaW5lcyBjaGVja2Vk
DQo+IA0KDQpJIGRpZG4ndCBnZXQgdGhlIENIRUNLIGluIG15IHRlc3RpbmcuICBOb3Qgc3VyZSB3
aHkuDQoNCkFueXdheSwgSSBndWVzcyB0aGUgY29tbWVudCBjYW4gYmUgdXNlZnVsIGlmIGl0IGlz
IHRvIGV4cGxhaW4gd2h5IHdlIG5lZWQgdG8gdXNlDQpzcGlubG9jayBvciB3aGF0ZXZlciBsb2Nr
LiAgQnV0DQoNCgkvKiBNdXN0IGFjcXVpcmUgdGhpcyBsb2NrIHRvIGFjY2VzcyAqLw0KDQpkb2Vz
bid0IGV4cGxhaW4gd2h5IGF0IGFsbCwgdGh1cyBkb2Vzbid0IGxvb2sgaGVscGZ1bCB0byBtZS4N
Cg0KSSBndWVzcyB5b3UgZWl0aGVyIG5lZWQgYSBiZXR0ZXIgY29tbWVudCwgb3IganVzdCByZW1v
dmUgaXQgKGl0J3Mgb2J2aW91cyB0aGF0IGENCmxvdCBvZiBrZXJuZWwgY29kZSBkb2Vzbid0IGhh
dmUgYSBjb21tZW50IGFyb3VuZCBzcGlubG9ja190KS4NCg0K
