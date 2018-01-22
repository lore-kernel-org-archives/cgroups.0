From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 6/9] drm: Add cgroup helper library
Date: Mon, 22 Jan 2018 08:24:47 -0800
Message-ID: <20180122162447.GD1096857@devbig577.frc2.facebook.com>
References: <20180120015141.10118-1-matthew.d.roper@intel.com>
 <20180120015141.10118-7-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=kzLityCEp6fiKQedSK2NjCQRz8sE9m4TBc50R03d7sI=;
 b=F9OE7LJemRd7BsTIhn7jI4AJmYLom3cwrt/yBg0YHX/S4TS8x0ivgnzWkfG/RnZp6o
 VMQroWA5n6Px0ieW0Glp3HbBC4alaSClPrv1qRvzL8QJQAbdPFUB3Zts5mT6eU5MrmxW
 Jw8tytHTjT8o+K6nWX3q2JfGHH7XF40/kW+kSH3XKrGC3//bAjzzc6YYojKDxNOCt7HF
 oeLZ8DT+FV87BUQ4/9n09edECa4OzMQ0ti8s3GQB4oTP6MfQWRnuD5wanTducpsnRKuc
 SrszbhfM8JksrmrNf4O09BmxS6Kiguebd97sQJ/lthEPYsRVGlQPLGSWz12PfNaD4n0O
 C2qw==
Content-Disposition: inline
In-Reply-To: <20180120015141.10118-7-matthew.d.roper@intel.com>
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

SGVsbG8sIE1hdHQuCgpPbiBGcmksIEphbiAxOSwgMjAxOCBhdCAwNTo1MTozOFBNIC0wODAwLCBN
YXR0IFJvcGVyIHdyb3RlOgo+IE1vc3QgRFJNIGRyaXZlcnMgd2lsbCB3YW50IHRvIGhhbmRsZSB0
aGUgQ0dST1VQX1NFVFBBUkFNIGlvY3RsIGJ5IGxvb2tpbmcgdXAgYQo+IGRyaXZlci1zcGVjaWZp
YyBwZXItY2dyb3VwIGRhdGEgc3RydWN0dXJlIChvciBhbGxvY2F0aW5nIGEgbmV3IG9uZSkgYW5k
IHN0b3JpbmcKPiB0aGUgc3VwcGxpZWQgcGFyYW1ldGVyIHZhbHVlIGludG8gdGhlIGRhdGEgc3Ry
dWN0dXJlIChwb3NzaWJseSBhZnRlciBkb2luZyBzb21lCj4gY2hlY2tpbmcgYW5kIHNhbml0aXph
dGlvbiBvbiB0aGUgcHJvdmlkZWQgdmFsdWUpLiAgTGV0J3MgcHJvdmlkZSBhIGhlbHBlcgo+IGxp
YnJhcnkgZm9yIGRyaXZlcnMgdGhhdCB3aWxsIHRha2UgY2FyZSBvZiB0aGUgZGV0YWlscyBvZiBz
dG9yaW5nIHBlci1jZ3JvdXAKPiBkYXRhIHN0cnVjdHVyZXMgaW4gYSBoYXNodGFibGUgYW5kIGRl
c3Ryb3lpbmcgdGhvc2Ugc3RydWN0dXJlcyBpZi93aGVuIHRoZQo+IGNncm91cCBpdHNlbGYgaXMg
cmVtb3ZlZC4KCldvdWxkIGl0IGJlIHBvc3NpYmxlIHRvIG1ha2UgdGhlIGNvcmUgb2YgdGhpcyBh
IGJ1aWx0LWluIHBhcnQgb2YKY2dyb3VwIGxpa2UgY2dyb3VwLWJwZiBkb2VzPyAgTXkgZ3V0IGZl
ZWxpbmcgaXMgdGhhdCB0aGF0IGlzbid0IGdvbm5hCmJlIG11Y2ggY29kZSBhbnl3YXkgYW5kIGxp
a2VseSB0byBiZSBjbGVhbmVyIHRvIGltcGxlbWVudCBhbmQgdXNlLgoKQmVpbmcgYSBmdWxsLWZs
ZWRnZWQgY29udHJvbGxlciBjb21lcyB3aXRoIHF1aXRlIGEgYml0IG9mIGNvbXBsZXhpdHkKaW4g
dGVybXMgb2Ygc3luYyBydWxlcyBhbmQgZXZlcnl0aGluZywgYW5kIHdlIG1heSBidWlsZCBhIHNp
bXBsZXIKbW9kdWxhciBpbmZyYXN0cnVjdHVyZSBpZiB1c2FnZXMgbGlrZSB0aGlzIHByb2xpZmVy
YXRlIGJ1dCBmb3Igbm93CmV4dGVuZGluZyBmcm9tIHRoZSBjb3JlIHNlZW1zIHRoZSBtb3N0IHN0
cmFpZ2h0IGZvcndhcmQuCgpUaGFua3MuCgotLSAKdGVqdW4KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1n
ZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21h
aWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
