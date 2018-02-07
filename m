From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC v2 3/7] cgroup: Add interface to allow
 drivers to lookup process cgroup membership
Date: Wed, 7 Feb 2018 14:42:52 -0800
Message-ID: <20180207224252.GK695913@devbig577.frc2.facebook.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-4-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=c7ktxRxp+D39Bi3gII790+ft+lKeTA/OjogqMjWUzLM=;
 b=N1dr9OEMX5MOoyI7ZXRzWgKpBQRILFoLVLFC/bn60BlMoNjBpktgiBYV49tsfQMg5/
 GC2tCv/MEofzR3X59JnVf5j2G+0LWvHwsGmq6hy0qxotSBvn8KDeDs2Be33lt9mZEnTO
 8QDxId7WFwDycLvuFBr4OzfRG6U5/guLNnoIBDUzZ3Lfoh7YIoOTEpctkDdRi6yIhc4W
 9P45u1rFb4sFkvKLNnZkqqKfQAbE4B7uwiZCoatXgw3BbeIzUPta/uitYm1jDxHzVQIg
 n5frpvcNflQN5PRlMadi/+XWYXmIB1h9h7E5zzc7MtrE1xpKkwptDqUi+Yy93gurImyb
 YpIQ==
Content-Disposition: inline
In-Reply-To: <20180201195315.4956-4-matthew.d.roper@intel.com>
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
To: Matt Roper <matthew.d.roper@intel.com>
Cc: cgroups@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org

SGVsbG8sCgpPbiBUaHUsIEZlYiAwMSwgMjAxOCBhdCAxMTo1MzoxMUFNIC0wODAwLCBNYXR0IFJv
cGVyIHdyb3RlOgo+ICsvKioKPiArICogY2dyb3VwX2Zvcl9kcml2ZXJfcHJvY2VzcyAtIHJldHVy
biB0aGUgY2dyb3VwIGZvciBhIHByb2Nlc3MKPiArICogQHBpZDogcHJvY2VzcyB0byBsb29rdXAg
Y2dyb3VwIGZvcgo+ICsgKgo+ICsgKiBSZXR1cm5zIHRoZSBjZ3JvdXAgZnJvbSB0aGUgdjIgaGll
cmFyY2h5IHRoYXQgYSBwcm9jZXNzIGJlbG9uZ3MgdG8uCj4gKyAqIFRoaXMgZnVuY3Rpb24gaXMg
aW50ZW5kZWQgdG8gYmUgY2FsbGVkIGZyb20gZHJpdmVycyBhbmQgd2lsbCBvYnRhaW4KPiArICog
dGhlIG5lY2Vzc2FyeSBjZ3JvdXAgbG9ja3MuCj4gKyAqCj4gKyAqIFJFVFVSTlM6Cj4gKyAqIFBy
b2Nlc3MnIGNncm91cCBpbiB0aGUgZGVmYXVsdCAodjIpIGhpZXJhcmNoeQo+ICsgKi8KPiArc3Ry
dWN0IGNncm91cCAqCj4gK2Nncm91cF9mb3JfZHJpdmVyX3Byb2Nlc3Moc3RydWN0IHBpZCAqcGlk
KQoKSSB0aGluayB5b3UgcHJvYmFibHkgd2FudCB0byB1c2UgdGFza19kZmxfY2dyb3VwKCkuICBX
ZSBjYW4gYWRkCnRhc2tfZ2V0X2RmbF9jZ3JvdXAoKSBpbiBhIHNpbWlsYXIgZmFzaGlvbiB0byB0
YXNrX2dldF9jc3MoKSBpZgpuZWNlc3NhcnkuCgpUaGFua3MuCgotLSAKdGVqdW4KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcg
bGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRl
c2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
