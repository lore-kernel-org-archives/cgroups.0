From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC PATCH 0/5] cgroup support for GPU devices
Date: Sun, 5 May 2019 12:46:19 -0400
Message-ID: <20190505164619.GA59027@chrisdown.name>
References: <20190501140438.9506-1-brian.welty@intel.com>
 <20190502083433.GP7676@mtr-leonro.mtl.com>
 <CAOWid-cYknxeTQvP9vQf3-i3Cpux+bs7uBs7_o-YMFjVCo19bg@mail.gmail.com>
 <bb001de0-e4e5-6b3f-7ced-9d0fb329635b@intel.com>
 <20190505071436.GD6938@mtr-leonro.mtl.com>
 <CAOWid-di8kcC2bYKq1KJo+rWfVjwQ13mcVRjaBjhFRzTO=c16Q@mail.gmail.com>
 <20190505160506.GF6938@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190505160506.GF6938@mtr-leonro.mtl.com>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Leon Romanovsky <leon@kernel.org>
Cc: Parav Pandit <parav@mellanox.com>, David Airlie <airlied@linux.ie>, kenny.ho@amd.com, intel-gfx@lists.freedesktop.org, "Welty,
 Brian" <brian.welty@intel.com>, Harish.Kasiviswanathan@amd.com, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, J??r??me Glisse <jglisse@redhat.com>, Li Zefan <lizefan@huawei.com>, Kenny Ho <y2kenny@gmail.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Alex Deucher <alexander.deucher@amd.com>, Tejun Heo <tj@kernel.org>, Christian K??nig <christian.koenig@amd.com>, RDMA mailing list <linux-rdma@vger.kernel.org>

TGVvbiBSb21hbm92c2t5IHdyaXRlczoKPkZpcnN0IGdyb3VwIChwcm9ncmFtbWVycykgaXMgdXNp
bmcgc3BlY2lhbCBBUEkgWzFdIHRocm91Z2ggbGliaWJ2ZXJicyBbMl0KPndpdGhvdXQgYW55IG5v
dGlvbiBvZiBjZ3JvdXBzIG9yIGFueSBsaW1pdGF0aW9ucy4gU2Vjb25kIGdyb3VwIChzeXNhZG1p
bnMpCj5pcyBsZXNzIGludGVyZXN0ZWQgaW4gYXBwbGljYXRpb24gc3BlY2lmaWNzIGFuZCBmb3Ig
dGhlbSAiZGV2aWNlIG1lbW9yeSIgbWVhbnMKPiJtZW1vcnkiIGFuZCBub3QgInJkbWEsIG5pYyBz
cGVjaWZpYywgaW50ZXJuYWwgbWVtb3J5Ii4KCkknZCBzdWdnZXN0IG90aGVyd2lzZSwgYmFzZWQg
b24gaGlzdG9yaWMgcHJlY2VkZW50IC0tIHN5c2FkbWlucyBhcmUgdHlwaWNhbGx5IAp2ZXJ5IG9w
aW5pb25hdGVkIGFib3V0IG9wZXJhdGlvbiBvZiB0aGUgbWVtb3J5IHN1YnN5c3RlbSAoaGVuY2Ug
dGhlIGVuZGxlc3MgCmRpc2N1c3Npb25zIGFib3V0IHN3YXAsIGNhY2hpbmcgYmVoYXZpb3VyLCBl
dGMpLgoKRXNwZWNpYWxseSBpbiB0aGlzIGNhc2UsIHRoZXNlIHR5cGVzIG9mIG1lbW9yeSBvcGVy
YXRlIGZ1bmRhbWVudGFsbHkgCmRpZmZlcmVudGx5IGFuZCBoYXZlIHNpZ25pZmljYW50bHkgZGlm
ZmVyZW50IHBlcmZvcm1hbmNlIGFuZCBhdmFpbGFiaWxpdHkgCmNoYXJhY3RlcmlzdGljcy4gVGhh
dCdzIG5vdCBzb21ldGhpbmcgdGhhdCBjYW4gYmUgdHJpdmlhbGx5IGFic3RyYWN0ZWQgb3ZlciAK
d2l0aG91dCBub24tdHJpdmlhbCBkcmF3YmFja3MuCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxp
c3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2RyaS1kZXZlbA==
