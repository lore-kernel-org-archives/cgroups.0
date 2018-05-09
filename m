From: Andrea Parri <parri.andrea@gmail.com>
Subject: Re: [PATCH v2 09/11] docs: Fix some broken references
Date: Wed, 9 May 2018 23:27:28 +0200
Message-ID: <20180509212728.GA4178@andrea>
References: <20180509152045.722f0c51@vento.lan>
 <Pine.LNX.4.44L0.1805091509100.1391-100000@iolanthe.rowland.org>
 <20180509164153.5b9ab9db@vento.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=l0JvjXNDoFEvAS1HHbq0IQeq6hyEO9taiaSHHg2zf8M=;
 b=XiRnI7xqkourYYjl//OXYySJt9ZcR9RTinH54hbmLy0bNRQuqq96bfVyrn7MbgB14B
 JcvtAQOBZydwYj5cnGZPk0Oy3KWT3xdAn+cfIW78aGBkC0eVX4xlJZuXBQhrlTQPtCTy
 3ux103iAR9mIajGXNQ/IMWN0YndyBe40EoKBBIcg3v98hBC0gZLjDDIA6nq5YWKh18uz
 ZvdlMO6w1j6Agg87KfZgO7XcDQ/32RwlXdQTvUVCI3tH7OutrKMwgMgATvs/IMCA68el
 wCiAvzPTLyj8xjHL2GEVdi2S4wza5BHwO6cHrGCWDTMgDxv71oXIMZrTFG6MDfuSiTv+
 NLxQ==
Content-Disposition: inline
In-Reply-To: <20180509164153.5b9ab9db@vento.lan>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
Content-Type: text/plain; charset="us-ascii"
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, Eric Paris <eparis@parisplace.org>, linux-clk@vger.kernel.org, James Morris <jmorris@namei.org>, Alan Stern <stern@rowland.harvard.edu>, xen-devel@lists.xenproject.org, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, Sean Paul <seanpaul@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Antoine Jacquet <royale@zerezo.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, linux-crypto@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, alsa-devel@alsa-project.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, David Airlie <airlied@linux.ie>, Gustavo Padovan <gustavo@pa>

T24gV2VkLCBNYXkgMDksIDIwMTggYXQgMDQ6NDE6NTNQTSAtMDMwMCwgTWF1cm8gQ2FydmFsaG8g
Q2hlaGFiIHdyb3RlOgo+IEVtIFdlZCwgOSBNYXkgMjAxOCAxNToxMTowNyAtMDQwMCAoRURUKQo+
IEFsYW4gU3Rlcm4gPHN0ZXJuQHJvd2xhbmQuaGFydmFyZC5lZHU+IGVzY3JldmV1Ogo+IAo+ID4g
T24gV2VkLCA5IE1heSAyMDE4LCBNYXVybyBDYXJ2YWxobyBDaGVoYWIgd3JvdGU6Cj4gPiAKPiA+
ID4gRW0gV2VkLCA5IE1heSAyMDE4IDE5OjE1OjAxICswMjAwCj4gPiA+IEFuZHJlYSBQYXJyaSA8
cGFycmkuYW5kcmVhQGdtYWlsLmNvbT4gZXNjcmV2ZXU6ICAKPiA+IAo+ID4gPiA+ID4gIHRvb2xz
L21lbW9yeS1tb2RlbC9SRUFETUUgICAgICAgICAgICAgICAgICAgICB8IDEwICsrKysrLS0tLS0g
ICAgCj4gPiA+ID4gCj4gPiA+ID4gQXMgbWVudGlvbmVkIGluIHRoZSBwcmV2aW91cyB0aHJlYWQs
IEkgYW0gZm9yIGtlZXBpbmcgdGhlIGN1cnJlbnQKPiA+ID4gPiByZWZlcmVuY2VzOiB0aGUgUkVB
TURFIGlzIGxpc3RpbmcgdGhlIGRvYyBmaWxlcywgYXMgd2VsbCBhcyBvdGhlcgo+ID4gPiA+IGZp
bGVzIGluIHRvb2xzL21lbW9yeS1tb2RlbC8sIHJlbGF0aXZlbHkgdG8gdGhhdCBkaXJlY3Rvcnku
ICAKPiA+ID4gCj4gPiA+IFllYWgsIGF0IGxlYXN0IHRoaXMgaHVuayBkZXNlcnZlcyBzb21lIHJl
d29yaywgYXMgbm93IHNvbWUKPiA+ID4gcmVmZXJlbmNlcyBhcmUgRG9jdW1lbnRhdGlvbi8uLi4v
Zm9vLCB3aGlsZSBvdGhlcnMgYXJlIGp1c3QKPiA+ID4gYmFyLgo+ID4gPiAKPiA+ID4gQXMgb24g
KGFsbW9zdCkgYWxsIG90aGVyIHBsYWNlcyAoZXhjZXB0IGZvciB0b29scy9tZW1vcnktbW9kZWwv
UkVBRE1FKSwKPiA+ID4gdGhlIHJlZmVyZW5jZXMgYXJlIGFsd2F5cyBmcm9tIHRoZSBtYWluIGRp
cmVjdG9yeSwgSSB3b3VsZCBtYWtlIGFsbAo+ID4gPiBwYXRjaGVzIHRoZXJlIGFsc28gcmVsYXRp
dmUgdG8gbWFpbiBkaXIuIElmIHlvdSdyZSBhZnJhaWQgb2YKPiA+ID4gbm90IGJlaW5nIHRvbyBj
bGVhcmVyLCB3ZSBjb3VsZCBwcmVmaXggYWxsIG9mIHRoZW0gd2l0aCBzb21ldGhpbmcKPiA+ID4g
bGlrZToKPiA+ID4gCj4gPiA+IAkke0xJTlVYfS90b29scy9tZW1vcnktbW9kZWwvLi4uCj4gPiA+
IAo+ID4gPiBqdXN0IGxpa2Ugc29tZSBEVCBiaW5kaW5nIGZpbGVzIGRvOgo+ID4gPiAKPiA+ID4g
CURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9zb3VuZC9hdWRpby1ncmFwaC1jYXJk
LnR4dDpzZWUgJHtMSU5VWH0vRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2dyYXBo
LnR4dAo+ID4gPiAKPiA+ID4gQSBib251cyBvZiBkb2luZyB0aGF0IGlzIHRoYXQgdGhlIGJyb2tl
biByZWZlcmVuY2UgZGV0ZWN0IHNjcmlwdCBjYW4KPiA+ID4ga2VlcCBwYXJzaW5nIGl0IHdpdGhv
dXQgY2hhbmdlcyAod2VsbCwgaXQgd291bGRuJ3QgYmUgaGFyZCB0byBtYWtlCj4gPiA+IGl0IGFs
c28gYWNjZXB0IGEgcmVsYXRpdmUgZmlsZSwgYnV0IGRvaW5nIHRoYXQganVzdCBkdWUgdG8gCj4g
PiA+IHRvb2xzL21lbW9yeS1tb2RlbC9SRUFETUUgc2VlbXMgb3ZlcmtpbGwpLgo+ID4gPiAKPiA+
ID4gQW5vdGhlciBhZHZhbnRhZ2UgaXMgdGhhdCBpdCB3b3VsZCBhbGxvdyB0byBlYXNpbHkgYWRk
IHJlZmVyZW5jZXMKPiA+ID4gdGhlcmUgZnJvbSB0aGUgbWFpbiBrZXJuZWwgRG9jdW1lbnRhdGlv
biwgaWYgbmVlZGVkIGluIHRoZSBmdXR1cmUsCj4gPiA+IHdpdGhvdXQgbWVzc2luZyB3aXRoIGxv
Y2FsIHggbm9uLWxvY2FsIHJlbGF0aXZlIG5hbWVzcGFjZS4gIAo+ID4gCj4gPiBIb3cgYWJvdXQg
Y2hhbmdpbmcgdGhlIHJlbGF0aXZlIHJlZmVyZW5jZXMgc28gdGhhdCBzb21ldGhpbmcgbGlrZQo+
ID4gRG9jdW1lbnRhdGlvbi9yZWNpcGVzLnR4dCBiZWNvbWVzIC4vRG9jdW1lbnRhdGlvbi9yZWNp
cGVzLnR4dD8KPiAKPiBTb3VuZHMgYSBnb29kIGlkZWEgdG8gbWUuIEFuZHJlYT8KCkNvdW50ZXJp
bnR1aXRpdmUgOy0pICBEb2N1bWVudGF0aW9uL2FiYy50eHQgdnMuIC4vRG9jdW1lbnRhdGlvbi9h
YmMudHh0CkJ1dCBsZXQgbWUgc2xlZXAgb3ZlciB0aGlzIDstKSAgZm9yIHRoZSB0aW1lIGJlaW5n
LCBJIHJlbmV3IG15IHZvdGUgZm9yCiJqdXN0IGRvbid0IGNvbW1pdCB0aGVzZSBjaGFuZ2VzIChh
bmQga2VlcCBjaGVja2luZyBhdXRvbWF0ZWQgY2hhbmdlcykiLgoKICBBbmRyZWEKCgo+IAo+IFRo
YW5rcywKPiBNYXVybwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5v
cmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZl
bA==
