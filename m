From: Kenny Ho <y2kenny@gmail.com>
Subject: Re: [RFC PATCH v2 4/5] drm,
 cgroup: Add total GEM buffer allocation limit
Date: Thu, 16 May 2019 10:28:23 -0400
Message-ID: <CAOWid-d=RwJ3_x1emhH_hh6TcfZPLyDYiPtv1-4Fa_y13v+Jbg@mail.gmail.com>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20190509210410.5471-1-Kenny.Ho@amd.com>
 <20190509210410.5471-5-Kenny.Ho@amd.com>
 <d81e8f55-9602-818e-0f9c-1d9d150133b1@intel.com>
 <CAOWid-ftUrVVWPu9KuS8xpWKNQT6_FtxB8gEyEAn9nLD6qxb5Q@mail.gmail.com>
 <7db2caae-7eab-7c6a-fe90-89cb9cae30b4@amd.com>
 <6e124f5e-f83f-5ca1-4616-92538f202653@gmail.com>
 <CAOWid-fQgah16ycz-V-ymsm7yKUnFTeTSBaW4MK=2mqUHhCcmw@mail.gmail.com>
 <1c50433e-442b-cada-7928-b00ed0f6f9d2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1c50433e-442b-cada-7928-b00ed0f6f9d2@gmail.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "sunnanyong@huawei.com" <sunnanyong@huawei.com>, "Ho,
 Kenny" <Kenny.Ho@amd.com>, "Welty, Brian" <brian.welty@intel.com>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "Deucher,
 Alexander" <Alexander.Deucher@amd.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

T24gVGh1LCBNYXkgMTYsIDIwMTkgYXQgMTA6MTIgQU0gQ2hyaXN0aWFuIEvDtm5pZwo8Y2tvZW5p
Zy5sZWljaHR6dW1lcmtlbkBnbWFpbC5jb20+IHdyb3RlOgo+IEFtIDE2LjA1LjE5IHVtIDE2OjAz
IHNjaHJpZWIgS2VubnkgSG86Cj4gPiBPbiBUaHUsIE1heSAxNiwgMjAxOSBhdCAzOjI1IEFNIENo
cmlzdGlhbiBLw7ZuaWcKPiA+IDxja29lbmlnLmxlaWNodHp1bWVya2VuQGdtYWlsLmNvbT4gd3Jv
dGU6Cj4gPj4gQW0gMTYuMDUuMTkgdW0gMDk6MTYgc2NocmllYiBLb2VuaWcsIENocmlzdGlhbjoK
PiA+PiBXZSBuZWVkIHNvbWV0aGluZyBsaWtlIHRoZSBMaW51eCBzeXNmcyBsb2NhdGlvbiBvciBz
aW1pbGFyIHRvIGhhdmUgYQo+ID4+IHN0YWJsZSBpbXBsZW1lbnRhdGlvbi4KPiA+IEkgZ2V0IHRo
YXQsIHdoaWNoIGlzIHdoeSBJIGRvbid0IHVzZSBtaW5vciB0byBpZGVudGlmeSBjYXJkcyBpbiB1
c2VyCj4gPiBzcGFjZSBhcHBzIEkgd3JvdGU6Cj4gPiBodHRwczovL2dpdGh1Yi5jb20vUmFkZW9u
T3BlbkNvbXB1dGUvazhzLWRldmljZS1wbHVnaW4vYmxvYi9jMjY1OWM5ZDFkMDcxM2NhZDM2ZmI1
MjU2NjgxMTI1MTIxZTZlMzJmL2ludGVybmFsL3BrZy9hbWRncHUvYW1kZ3B1LmdvI0w4NQo+Cj4g
WWVhaCwgdGhhdCBpcyBjZXJ0YWlubHkgYSBwb3NzaWJpbGl0eS4KPgo+ID4gQnV0IHdpdGhpbiB0
aGUga2VybmVsLCBJIHRoaW5rIG15IHVzZSBvZiBtaW5vciBpcyBjb25zaXN0ZW50IHdpdGggdGhl
Cj4gPiByZXN0IG9mIHRoZSBkcm0gc3Vic3lzdGVtLiAgSSBob3BlIEkgZG9uJ3QgbmVlZCB0byBy
ZWZvcm0gdGhlIHdheSB0aGUKPiA+IGRybSBzdWJzeXN0ZW0gdXNlIG1pbm9yIGluIG9yZGVyIHRv
IGludHJvZHVjZSBhIGNncm91cCBjb250cm9sbGVyLgo+Cj4gV2VsbCBJIHdvdWxkIHRyeSB0byBh
dm9pZCB1c2luZyB0aGUgbWlub3IgYW5kIGF0IGxlYXN0IGxvb2sgZm9yCj4gYWx0ZXJuYXRpdmVz
LiBFLmcuIHdoYXQgZG9lcyB1ZGV2IHVzZXMgdG8gaWRlbnRpZnkgdGhlIGRldmljZXMgZm9yCj4g
ZXhhbXBsZT8gQW5kIElJUkMgd2UgaGF2ZSBzb21ldGhpbmcgbGlrZSBhICJkZXZpY2UtbmFtZSIg
aW4gdGhlIGtlcm5lbAo+IGFzIHdlbGwgKHdoYXQncyBwcmludGVkIGluIHRoZSBsb2dzKS4KPgo+
IFRoZSBtaW5pbXVtIHdlIG5lZWQgdG8gZG8gaXMgZ2V0IGF3YXkgZnJvbSB0aGUgbWlub3I9bGlu
ZW51bSBhcHByb2FjaCwKPiBjYXVzZSBhcyBEYW5pZWwgcG9pbnRlZCBvdXQgdGhlIG1pbm9yIGFs
bG9jYXRpb24gaXMgcXVpdGUgYSBtZXNzIGFuZCBub3QKPiBuZWNlc3NhcnkgY29udGlndW91cy4K
Ckkgbm90aWNlZCA6KSBidXQgbG9va3MgbGlrZSB0aGVyZSBpc24ndCBtdWNoIG9mIGEgY2hvaWNl
IGZyb20gd2hhdApUZWp1bi9jZ3JvdXAgcmVwbGllZCBhYm91dCBjb252ZW50aW9uLgoKUmVnYXJk
cywKS2VubnkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
ZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0
dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
