From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup support for GPU devices
Date: Mon, 6 May 2019 08:26:43 -0700
Message-ID: <20190506152643.GL374014@devbig004.ftw2.facebook.com>
References: <20190501140438.9506-1-brian.welty@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190501140438.9506-1-brian.welty@intel.com>
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
To: Brian Welty <brian.welty@intel.com>
Cc: ChunMing Zhou <David1.Zhou@amd.com>, David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Alex Deucher <alexander.deucher@amd.com>, cgroups@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>

SGVsbG8sCgpPbiBXZWQsIE1heSAwMSwgMjAxOSBhdCAxMDowNDozM0FNIC0wNDAwLCBCcmlhbiBX
ZWx0eSB3cm90ZToKPiBUaGUgcGF0Y2ggc2VyaWVzIGVuYWJsZXMgZGV2aWNlIGRyaXZlcnMgdG8g
dXNlIGNncm91cHMgdG8gY29udHJvbCB0aGUKPiBmb2xsb3dpbmcgcmVzb3VyY2VzIHdpdGhpbiBh
IEdQVSAob3Igb3RoZXIgYWNjZWxlcmF0b3IgZGV2aWNlKToKPiAqICBjb250cm9sIGFsbG9jYXRp
b24gb2YgZGV2aWNlIG1lbW9yeSAocmV1c2Ugb2YgbWVtY2cpCj4gYW5kIHdpdGggZnV0dXJlIHdv
cmssIHdlIGNvdWxkIGV4dGVuZCB0bzoKPiAqICB0cmFjayBhbmQgY29udHJvbCBzaGFyZSBvZiBH
UFUgdGltZSAocmV1c2Ugb2YgY3B1L2NwdWFjY3QpCj4gKiAgYXBwbHkgbWFzayBvZiBhbGxvd2Vk
IGV4ZWN1dGlvbiBlbmdpbmVzIChyZXVzZSBvZiBjcHVzZXRzKQo+IAo+IEluc3RlYWQgb2YgaW50
cm9kdWNpbmcgYSBuZXcgY2dyb3VwIHN1YnN5c3RlbSBmb3IgR1BVIGRldmljZXMsIGEgbmV3Cj4g
ZnJhbWV3b3JrIGlzIHByb3Bvc2VkIHRvIGFsbG93IGRldmljZXMgdG8gcmVnaXN0ZXIgd2l0aCBl
eGlzdGluZyBjZ3JvdXAKPiBjb250cm9sbGVycywgd2hpY2ggY3JlYXRlcyBwZXItZGV2aWNlIGNn
cm91cF9zdWJzeXNfc3RhdGUgd2l0aGluIHRoZQo+IGNncm91cC4gIFRoaXMgZ2l2ZXMgZGV2aWNl
IGRyaXZlcnMgdGhlaXIgb3duIHByaXZhdGUgY2dyb3VwIGNvbnRyb2xzCj4gKHN1Y2ggYXMgbWVt
b3J5IGxpbWl0cyBvciBvdGhlciBwYXJhbWV0ZXJzKSB0byBiZSBhcHBsaWVkIHRvIGRldmljZQo+
IHJlc291cmNlcyBpbnN0ZWFkIG9mIGhvc3Qgc3lzdGVtIHJlc291cmNlcy4KPiBEZXZpY2UgZHJp
dmVycyAoR1BVIG9yIG90aGVyKSBhcmUgdGhlbiBhYmxlIHRvIHJldXNlIHRoZSBleGlzdGluZyBj
Z3JvdXAKPiBjb250cm9scywgaW5zdGVhZCBvZiBpbnZlbnRpbmcgc2ltaWxhciBvbmVzLgoKSSdt
IHJlYWxseSBza2VwdGljYWwgYWJvdXQgdGhpcyBhcHByb2FjaC4gIFdoZW4gY3JlYXRpbmcgcmVz
b3VyY2UKY29udHJvbGxlcnMsIEkgdGhpbmsgd2hhdCdzIHRoZSBtb3N0IGltcG9ydGFudCBhbmQg
Y2hhbGxlbmdpbmcgaXMKZXN0YWJsaXNoaW5nIHJlc291cmNlIG1vZGVsIC0gd2hhdCByZXNvdXJj
ZXMgYXJlIGFuZCBob3cgdGhleSBjYW4gYmUKZGlzdHJpYnV0ZWQuICBUaGlzIHBhdGNoc2V0IGlz
IGdvaW5nIHRoZSBvdGhlciB3YXkgYXJvdW5kIC0gYnVpbGRpbmcKb3V0IGNvcmUgaW5mcmFzdHJ1
Y3R1cmUgZm9yIGJvbGllcnBsYXRlcyBhdCBhIHNpZ25pZmljYW50IHJpc2sgb2YKbWl4aW5nIHVw
IHJlc291cmNlIG1vZGVscyBhY3Jvc3MgZGlmZmVyZW50IHR5cGVzIG9mIHJlc291cmNlcy4KCklP
IGNvbnRyb2xsZXJzIGFscmVhZHkgaW1wbGVtZW50IHBlci1kZXZpY2UgY29udHJvbHMuICBJJ2Qg
c3VnZ2VzdApmb2xsb3dpbmcgdGhlIHNhbWUgaW50ZXJmYWNlIGNvbnZlbnRpb25zIGFuZCBpbXBs
ZW1lbnRpbmcgYSBkZWRpY2F0ZWQKY29udHJvbGxlciBmb3IgdGhlIHN1YnN5c3RlbS4KClRoYW5r
cy4KCi0tIAp0ZWp1bgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1n
Zng=
