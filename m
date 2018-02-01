From: Matt Roper <matthew.d.roper@intel.com>
Subject: Re: [PATCH RFC v2 3/7] cgroup: Add interface to allow
 drivers to lookup process cgroup membership
Date: Thu, 1 Feb 2018 13:25:26 -0800
Message-ID: <20180201212526.GI31510@mdroper-desk.amr.corp.intel.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-4-matthew.d.roper@intel.com>
 <151751817231.28099.3778306702580372716@mail.alporthouse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <151751817231.28099.3778306702580372716@mail.alporthouse.com>
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
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org

T24gVGh1LCBGZWIgMDEsIDIwMTggYXQgMDg6NDk6MzJQTSArMDAwMCwgQ2hyaXMgV2lsc29uIHdy
b3RlOgo+IFF1b3RpbmcgTWF0dCBSb3BlciAoMjAxOC0wMi0wMSAxOTo1MzoxMSkKLi4uCj4gPiAr
c3RydWN0IGNncm91cCAqCj4gPiArY2dyb3VwX2Zvcl9kcml2ZXJfcHJvY2VzcyhzdHJ1Y3QgcGlk
ICpwaWQpCj4gPiArewo+ID4gKyAgICAgICBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2sgPSBwaWRf
dGFzayhwaWQsIFBJRFRZUEVfUElEKTsKPiA+ICsKPiA+ICsgICAgICAgbXV0ZXhfbG9jaygmY2dy
b3VwX211dGV4KTsKPiA+ICsgICAgICAgc3Bpbl9sb2NrX2lycSgmY3NzX3NldF9sb2NrKTsKPiA+
ICsgICAgICAgdGFza19jZ3JvdXBfZnJvbV9yb290KHRhc2ssICZjZ3JwX2RmbF9yb290KTsKPiA+
ICsgICAgICAgc3Bpbl91bmxvY2tfaXJxKCZjc3Nfc2V0X2xvY2spOwo+ID4gKyAgICAgICBtdXRl
eF91bmxvY2soJmNncm91cF9tdXRleCk7Cj4gCj4gR3V0IGZlZWxpbmcgc2F5cyB1c2UgdGFzayA9
IGdldF9waWRfdGFzaygpOyBpZiAoIXRhc2spIHJldHVybiBOVUxMIGFuZAo+IHB1dF90YXNrX3N0
cnVjdCh0YXNrKTsgZm9yIHNhZmV0eS4KPiAKPiBTaG91bGRuJ3QgdGhlcmUgYmUgYSByZXR1cm4g
aGVyZT8KCldvb3BzLCBsb29rcyBsaWtlIEkgbWlzLXNxdWFzaGVkIHNvbWUgb2YgbXkgZml4ZXMg
Zm9yIHRoaXMgcGF0Y2ggaW4gdG8KcGF0Y2ggIzQgaW5zdGVhZC4gIEJ1dCB5ZWFoLCBnZXRfcGlk
X3Rhc2soKSBpcyBiZXR0ZXIgaW4gZ2VuZXJhbC4KCgpNYXR0Cgo+ID4gK30KPiAtQ2hyaXMKPiAt
LQo+IFRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNj
cmliZSBjZ3JvdXBzIiBpbgo+IHRoZSBib2R5IG9mIGEgbWVzc2FnZSB0byBtYWpvcmRvbW9Admdl
ci5rZXJuZWwub3JnCj4gTW9yZSBtYWpvcmRvbW8gaW5mbyBhdCAgaHR0cDovL3ZnZXIua2VybmVs
Lm9yZy9tYWpvcmRvbW8taW5mby5odG1sCgotLSAKTWF0dCBSb3BlcgpHcmFwaGljcyBTb2Z0d2Fy
ZSBFbmdpbmVlcgpJb1RHIFBsYXRmb3JtIEVuYWJsaW5nICYgRGV2ZWxvcG1lbnQKSW50ZWwgQ29y
cG9yYXRpb24KKDkxNikgMzU2LTI3OTUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGlu
Zm8vaW50ZWwtZ2Z4Cg==
