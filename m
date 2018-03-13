From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 1/6] cgroup: Allow registration and
 lookup of cgroup private data
Date: Tue, 13 Mar 2018 22:52:21 +0000
Message-ID: <20180313225214.GA14441@castle>
References: <20180306234700.6562-1-matthew.d.roper@intel.com>
 <20180306234700.6562-2-matthew.d.roper@intel.com>
 <20180313205035.GN2943022@devbig577.frc2.facebook.com>
 <4bc02913-7250-ed88-fac0-6b19957ca07b@fb.com>
 <20180313213658.GA12498@castle>
 <36e459e1-dd65-8153-7ac4-1629550cce92@fb.com>
 <20180313221314.GR2943022@devbig577.frc2.facebook.com>
 <d0314e4c-b1cb-8270-b39f-14a66eeedfd3@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com;
 h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=RRyR3uTeUJOHK1vvPAX1Piu3bJvqvCUMvxSGy52k/p8=;
 b=D2gdyff7dLHrc2EqwDYepWt9WcMEv8WMLDEhTWogy5RjcM+uwMgAY9AERLsWFe6TV+3F
 A50HNnyJwfS5XA06LaopaeS5m2ZqiTGppjxFafC4OGS7t4pnu0qbV4V9NtWiRwWqgJtS
 SLY7XOmmjOW/S2MkLwghHAiXXtziFoa6PRs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
 bh=RRyR3uTeUJOHK1vvPAX1Piu3bJvqvCUMvxSGy52k/p8=;
 b=KVjJ79PAV4qhLsVU8GG6iu+iAptH1Vj80OG8F06i3yyHBGB8qFC+Sm8ccGBM7CYpWYbFwEqMvtyDP4DPadd9fACXv2NHGNcKZ/CoOSxSC3zTvbAWHDUpUOrxWrzp9xahIK/sJlBX/fx487+tvzkfSpqyJcHpicKMdqdDFahAvFE=
Content-Disposition: inline
In-Reply-To: <d0314e4c-b1cb-8270-b39f-14a66eeedfd3@fb.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexei Starovoitov <ast@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, intel-gfx@lists.freedesktop.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, kernel-team@fb.com, Alexei Starovoitov <alexei.starovoitov@gmail.com>

T24gVHVlLCBNYXIgMTMsIDIwMTggYXQgMDM6NDI6MjBQTSAtMDcwMCwgQWxleGVpIFN0YXJvdm9p
dG92IHdyb3RlOgo+IE9uIDMvMTMvMTggMzoxMyBQTSwgVGVqdW4gSGVvIHdyb3RlOgo+ID4gSGVs
bG8sCj4gPiAKPiA+IE9uIFR1ZSwgTWFyIDEzLCAyMDE4IGF0IDAyOjQ3OjQ1UE0gLTA3MDAsIEFs
ZXhlaSBTdGFyb3ZvaXRvdiB3cm90ZToKPiA+ID4gaXQgaGFzIHRvIGJlIHplcm8gbG9va3Vwcy4g
SWYgaWRyIGxvb2t1cCBpcyBpbnZvbHZlZCwgaXQncyBjbGVhbmVyCj4gPiA+IHRvIGFkZCBpZHIg
YXMgbmV3IGJwZiBtYXAgdHlwZSBhbmQgdXNlIGNncm91cCBpbm8gYXMgYW4gaWQuCj4gPiAKPiA+
IE9oLCBpZHIgKG9yIHJhdGhlciBpZGEpIGlzIGp1c3QgdG8gYWxsb2NhdGUgdGhlIGtleSwgb25j
ZSB0aGUga2V5IGlzCj4gPiB0aGVyZSBpdCBwcmV0dHkgbXVjaCBzaG91bGQgYm9pbCBkb3duIHRv
IHN0aCBsaWtlCj4gPiAKPiA+IAlyY3VfcmVhZF9sb2NrKCk7Cj4gPiAJdGFibGUgPSByY3VfZGVy
ZWYoY2dycC0+dGFibGUpOwo+ID4gCWlmIChrZXkgPCB0YWJsZS0+bGVuKQo+ID4gCQlyZXQgPSB0
YWJsZVtrZXldOwo+ID4gCWVsc2UKPiA+IAkJcmV0ID0gTlVMTDsKPiA+IAlyY3VfcmVhZF91bmxv
Y2soKTsKPiA+IAo+ID4gRGVwZW5kaW5nIG9uIHRoZSByZXF1aXJlbWVudHMsIHdlIGNhbiBnZXQg
cmlkIG9mIHRoZSB0YWJsZS0+bGVuIGNoZWNrCj4gPiBieSBtYWtpbmcga2V5IGFsbG9jIHBhdGgg
bW9yZSBleHBlbnNpdmUgKGllLiBnaXZlIG91dCBrZXkgb25seSBhZnRlcgo+ID4gdGFibGUgZXh0
ZW5zaW9uIGlzIGZ1bGx5IGRvbmUgYW5kIHByb3BhZ2F0ZWQpLgo+IAo+IGp1c3QgbGlrZSB0d28g
YnBmIHByb2dzIGNhbiBiZSBhdHRhY2hlZCB0byB0aGUgc2FtZSBjZ3JvdXAKPiB0aGUgc2FtZSBi
cGYgcHJvZyBjYW4gYmUgYXR0YWNoZWQgdG8gbXVsdGlwbGUgY2dyb3Vwcy4KPiBJZiB3ZSB1c2Ug
aWRhIHRvIGFsbG9jYXRlIGFuIGlkIGFuZCBzdG9yZSBpdCBicGYtPmF1eC0+Y2dyb3VwX3RhYmxl
X2tleQo+IHRvIGxhdGVyIGRvOiBjZ3JwLT50YWJsZVticGYtPmF1eC0+Y2dyb3VwX3RhYmxlX2tl
eV0KPiB0aGlzIGlkPT1rZXkgd291bGQgbmVlZCB0byB2YWxpZCBhY3Jvc3MgbXVsdGlwbGUgY2dy
b3VwcyB3aGljaAo+IGNvbXBsaWNhdGVzIHRoaW5ncyBhIGxvdC4KPiAKPiBJdCBmZWVscyB0aGF0
IHdlIG5lZWQgc29tZXRoaW5nIHNpbWlsYXIgdG8gY29tcHV0ZV9lZmZlY3RpdmVfcHJvZ3MoKQo+
IGJ1dCBmb3IgdGhpcyBzY3JhdGNoIGJ1ZmZlcnMuCj4gVGhlbiBhdCB0aGUgdGltZSBvZiBCUEZf
UFJPR19SVU5fQVJSQVkgc3VwcGx5IGNvcnJlc3BvbmRpbmcKPiBzY3JhdGNoIGJ1ZmZlciBmb3Ig
ZXZlcnkgcHJvZ3JhbS4KPiBOZXh0IHRvIGNncnAtPmJwZi5lZmZlY3RpdmVbdHlwZV0gaGF2ZSBz
aW1pbGFyIGFycmF5IG9mIHBvaW50ZXJzCj4gdG8gc2NyYXRjaCBidWZmZXJzLgoKU29ycnksIGlm
IEkgd2Fzbid0IGNsZWFyLCB0aGlzIGlzIGV4YWN0bHkgd2hhdCBJIG1lYW4gaW4gbXkgcHJldiBs
ZXR0ZXI6Cm1ha2UgYSBwb2ludGVyIHRvIGEgc2NyYXRjaCBidWZmZXIgdW5pcXVlIHBlciAoY2dy
b3VwLCBhdHRhY2hlZCBwcm9ncmFtKQpwYWlyLgoKVGhlbiB3ZSdsbCBoYXZlIHplcm8gbG9va3Vw
cyBvbiBhIGhvdCBwYXRoLCBidXQga2VlcCB0aGUgZmxleGliaWxpdHkuLgoKU291bmRzIHZlcnkg
Z29vZCB0byBtZS4KClRoYW5rcyEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRl
c2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8v
aW50ZWwtZ2Z4Cg==
