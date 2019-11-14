From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH v2] sched/topology, cpuset: Account for housekeeping CPUs
 to avoid empty cpumasks
Date: Thu, 14 Nov 2019 16:03:50 +0000
Message-ID: <d7ed40aa-1ac1-a42d-51eb-b1bd9f839fb1@arm.com>
References: <20191104003906.31476-1-valentin.schneider@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191104003906.31476-1-valentin.schneider@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

T24gMDQvMTEvMjAxOSAwMDozOSwgVmFsZW50aW4gU2NobmVpZGVyIHdyb3RlOgo+IE1pY2hhbCBu
b3RlZCB0aGF0IGEgY3B1c2V0J3MgZWZmZWN0aXZlX2NwdXMgY2FuIGJlIGEgbm9uLWVtcHkgbWFz
aywgYnV0Cj4gYmVjYXVzZSBvZiB0aGUgbWFza2luZyBkb25lIHdpdGggaG91c2VrZWVwaW5nX2Nw
dW1hc2soSEtfRkxBR19ET01BSU4pCj4gZnVydGhlciBkb3duIHRoZSBsaW5lLCB3ZSBjYW4gc3Rp
bGwgZW5kIHVwIHdpdGggYW4gZW1wdHkgY3B1bWFzayBiZWluZwo+IHBhc3NlZCBkb3duIHRvIHBh
cnRpdGlvbl9zY2hlZF9kb21haW5zX2xvY2tlZCgpLgo+IAo+IERvIHRoZSBwcm9wZXIgdGhpbmcg
YW5kIGRvbid0IGp1c3QgY2hlY2sgdGhlIG1hc2sgaXMgbm9uLWVtcHR5IC0gY2hlY2sKPiB0aGF0
IGl0cyBpbnRlcnNlY3Rpb24gd2l0aCBob3VzZWtlZXBpbmdfY3B1bWFzayhIS19GTEFHX0RPTUFJ
TikgaXMKPiBub24tZW1wdHkuCj4gCj4gRml4ZXM6IGNkMWNiMzM1MDU2MSAoInNjaGVkL3RvcG9s
b2d5OiBEb24ndCB0cnkgdG8gYnVpbGQgZW1wdHkgc2NoZWQgZG9tYWlucyIpCj4gUmVwb3J0ZWQt
Ynk6IE1pY2hhbCBLb3V0bsO9IDxta291dG55QHN1c2UuY29tPgoKTWljaGFsLCBjb3VsZCBJIG5h
ZyB5b3UgZm9yIGEgcmV2aWV3ZWQtYnk/IEknZCBmZWVsIGEgYml0IG1vcmUgY29uZmlkZW50Cndp
dGggYW55IHNvcnQgb2YgYXBwcm92YWwgZnJvbSBmb2xrcyB3aG8gYWN0dWFsbHkgZG8gdXNlIGNw
dXNldHMuCgo+IFNpZ25lZC1vZmYtYnk6IFZhbGVudGluIFNjaG5laWRlciA8dmFsZW50aW4uc2No
bmVpZGVyQGFybS5jb20+Cg==
