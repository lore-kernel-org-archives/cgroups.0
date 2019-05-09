From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup support for GPU devices
Date: Thu, 9 May 2019 09:52:32 -0700
Message-ID: <20190509165232.GW374014@devbig004.ftw2.facebook.com>
References: <20190501140438.9506-1-brian.welty@intel.com>
 <20190506152643.GL374014@devbig004.ftw2.facebook.com>
 <cf58b047-d678-ad89-c9b6-96fc6b01c1d7@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <cf58b047-d678-ad89-c9b6-96fc6b01c1d7@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
To: "Welty, Brian" <brian.welty@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, David Airlie <airlied@linux.ie>, kenny.ho@amd.com, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Li Zefan <lizefan@huawei.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, RDMA mailing list <linux-rdma@vger.kernel.org>

SGVsbG8sCgpPbiBUdWUsIE1heSAwNywgMjAxOSBhdCAxMjo1MDo1MFBNIC0wNzAwLCBXZWx0eSwg
QnJpYW4gd3JvdGU6Cj4gVGhlcmUgbWlnaHQgc3RpbGwgYmUgbWVyaXQgaW4gaGF2aW5nIGEgJ2Rl
dmljZSBtZW0nIGNncm91cCBjb250cm9sbGVyLgo+IFRoZSByZXNvdXJjZSBtb2RlbCBhdCBsZWFz
dCBpcyB0aGVuIG5vIGxvbmdlciBtaXhlZCB1cCB3aXRoIGhvc3QgbWVtb3J5Lgo+IFJETUEgY29t
bXVuaXR5IHNlZW1lZCB0byBoYXZlIHNvbWUgaW50ZXJlc3QgaW4gYSBjb21tb24gY29udHJvbGxl
ciBhdAo+IGxlYXN0IGZvciBkZXZpY2UgbWVtb3J5IGFzcGVjdHMuCj4gVGhvdWdodHMgb24gdGhp
cz8gICBJIGJlbGlldmUgY291bGQgc3RpbGwgcmV1c2UgdGhlICdzdHJ1Y3QgbWVtX2Nncm91cCcg
ZGF0YQo+IHN0cnVjdHVyZS4gIFRoZXJlIHNob3VsZCBiZSBzb21lIG9wcG9ydHVuaXR5IHRvIHJl
dXNlIGNoYXJnaW5nIEFQSXMgYW5kCj4gaGF2ZSBzb21lIG5pY2UgaW50ZWdyYXRpb24gd2l0aCBI
TU0gZm9yIGNoYXJnaW5nIHRvIGRldmljZSBtZW1vcnksIGRlcGVuZGluZwo+IG9uIGJhY2tpbmcg
c3RvcmUuCgpMaWJyYXJ5LWlzaCBzaGFyaW5nIGlzIGZpbmUgYnV0IGluIHRlcm1zIG9mIGludGVy
ZmFjZSwgSSB0aGluayBpdCdkIGJlCmJldHRlciB0byBrZWVwIHRoZW0gc2VwYXJhdGUgYXQgbGVh
c3QgZm9yIG5vdy4gIERvd24gdGhlIGxpbmUgbWF5YmUKdGhlc2UgcmVzb3VyY2VzIHdpbGwgaW50
ZXJhY3Qgd2l0aCBlYWNoIG90aGVyIGluIGEgbW9yZSBpbnRlZ3JhdGVkIHdheQpidXQgSSBkb24n
dCB0aGluayBpdCdzIGEgZ29vZCBpZGVhIHRvIHRyeSB0byBkZXNpZ24gYW5kIGltcGxlbWVudApy
ZXNvdXJjZSBtb2RlbHMgZm9yIHNvbWV0aGluZyBsaWtlIHRoYXQgcHJlZW1wdGl2ZWx5LgoKVGhh
bmtzLgoKLS0gCnRlanVuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9w
Lm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1k
ZXZlbA==
