From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 09/11] docs: Fix some broken references
Date: Wed, 9 May 2018 16:41:53 -0300
Message-ID: <20180509164153.5b9ab9db@vento.lan>
References: <20180509152045.722f0c51@vento.lan>
 <Pine.LNX.4.44L0.1805091509100.1391-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
 From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=jvRoYswcAvH6Qky7saWZp6Q/iF5eFMk5xuQmKgy5NIc=; b=PNIfnQGucYLIhHAA3oRzFeOcs
 HPlEEv0lFqpitzkSU+oyUolI40RF6Fs0UfzrGd61wQhcSuAVz+cGycrUUWfsp0VRDdQmcUEBNsUSW
 jQ0gGZiHHp7z47wwF4x6FzeUS6aiAmBGRBDHxijPoAVTzkqc0FkocjAAgXZNg3oBjjHEriGg1GncH
 Vqh7ljUK5z1KLoiswUoPt9LhQwKiAKsrTIoWGiJu89v94lq9KepT9QGlVVHQj/Ro+0o4EiF0yS9o/
 WyR8OblbIVaz+p4pn2DKC/cYnSI1aGZtdoL+bCMhOiENfa+g2yrDmf9KkRzEI4snrnyYyuuqjrMS/
 ODYuJGb8A==;
In-Reply-To: <Pine.LNX.4.44L0.1805091509100.1391-100000@iolanthe.rowland.org>
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
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, Eric Paris <eparis@parisplace.org>, linux-clk@vger.kernel.org, James Morris <jmorris@namei.org>, xen-devel@lists.xenproject.org, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Antoine Jacquet <royale@zerezo.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, linux-crypto@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, alsa-devel@alsa-project.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, David Airlie <airlied@linux.ie>, Max Filippov <jcmvbkbc@gmail.com>, Harry Wei <harryxiyou@gmail.com>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Anil

RW0gV2VkLCA5IE1heSAyMDE4IDE1OjExOjA3IC0wNDAwIChFRFQpCkFsYW4gU3Rlcm4gPHN0ZXJu
QHJvd2xhbmQuaGFydmFyZC5lZHU+IGVzY3JldmV1OgoKPiBPbiBXZWQsIDkgTWF5IDIwMTgsIE1h
dXJvIENhcnZhbGhvIENoZWhhYiB3cm90ZToKPiAKPiA+IEVtIFdlZCwgOSBNYXkgMjAxOCAxOTox
NTowMSArMDIwMAo+ID4gQW5kcmVhIFBhcnJpIDxwYXJyaS5hbmRyZWFAZ21haWwuY29tPiBlc2Ny
ZXZldTogIAo+IAo+ID4gPiA+ICB0b29scy9tZW1vcnktbW9kZWwvUkVBRE1FICAgICAgICAgICAg
ICAgICAgICAgfCAxMCArKysrKy0tLS0tICAgIAo+ID4gPiAKPiA+ID4gQXMgbWVudGlvbmVkIGlu
IHRoZSBwcmV2aW91cyB0aHJlYWQsIEkgYW0gZm9yIGtlZXBpbmcgdGhlIGN1cnJlbnQKPiA+ID4g
cmVmZXJlbmNlczogdGhlIFJFQU1ERSBpcyBsaXN0aW5nIHRoZSBkb2MgZmlsZXMsIGFzIHdlbGwg
YXMgb3RoZXIKPiA+ID4gZmlsZXMgaW4gdG9vbHMvbWVtb3J5LW1vZGVsLywgcmVsYXRpdmVseSB0
byB0aGF0IGRpcmVjdG9yeS4gIAo+ID4gCj4gPiBZZWFoLCBhdCBsZWFzdCB0aGlzIGh1bmsgZGVz
ZXJ2ZXMgc29tZSByZXdvcmssIGFzIG5vdyBzb21lCj4gPiByZWZlcmVuY2VzIGFyZSBEb2N1bWVu
dGF0aW9uLy4uLi9mb28sIHdoaWxlIG90aGVycyBhcmUganVzdAo+ID4gYmFyLgo+ID4gCj4gPiBB
cyBvbiAoYWxtb3N0KSBhbGwgb3RoZXIgcGxhY2VzIChleGNlcHQgZm9yIHRvb2xzL21lbW9yeS1t
b2RlbC9SRUFETUUpLAo+ID4gdGhlIHJlZmVyZW5jZXMgYXJlIGFsd2F5cyBmcm9tIHRoZSBtYWlu
IGRpcmVjdG9yeSwgSSB3b3VsZCBtYWtlIGFsbAo+ID4gcGF0Y2hlcyB0aGVyZSBhbHNvIHJlbGF0
aXZlIHRvIG1haW4gZGlyLiBJZiB5b3UncmUgYWZyYWlkIG9mCj4gPiBub3QgYmVpbmcgdG9vIGNs
ZWFyZXIsIHdlIGNvdWxkIHByZWZpeCBhbGwgb2YgdGhlbSB3aXRoIHNvbWV0aGluZwo+ID4gbGlr
ZToKPiA+IAo+ID4gCSR7TElOVVh9L3Rvb2xzL21lbW9yeS1tb2RlbC8uLi4KPiA+IAo+ID4ganVz
dCBsaWtlIHNvbWUgRFQgYmluZGluZyBmaWxlcyBkbzoKPiA+IAo+ID4gCURvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9zb3VuZC9hdWRpby1ncmFwaC1jYXJkLnR4dDpzZWUgJHtMSU5V
WH0vRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2dyYXBoLnR4dAo+ID4gCj4gPiBB
IGJvbnVzIG9mIGRvaW5nIHRoYXQgaXMgdGhhdCB0aGUgYnJva2VuIHJlZmVyZW5jZSBkZXRlY3Qg
c2NyaXB0IGNhbgo+ID4ga2VlcCBwYXJzaW5nIGl0IHdpdGhvdXQgY2hhbmdlcyAod2VsbCwgaXQg
d291bGRuJ3QgYmUgaGFyZCB0byBtYWtlCj4gPiBpdCBhbHNvIGFjY2VwdCBhIHJlbGF0aXZlIGZp
bGUsIGJ1dCBkb2luZyB0aGF0IGp1c3QgZHVlIHRvIAo+ID4gdG9vbHMvbWVtb3J5LW1vZGVsL1JF
QURNRSBzZWVtcyBvdmVya2lsbCkuCj4gPiAKPiA+IEFub3RoZXIgYWR2YW50YWdlIGlzIHRoYXQg
aXQgd291bGQgYWxsb3cgdG8gZWFzaWx5IGFkZCByZWZlcmVuY2VzCj4gPiB0aGVyZSBmcm9tIHRo
ZSBtYWluIGtlcm5lbCBEb2N1bWVudGF0aW9uLCBpZiBuZWVkZWQgaW4gdGhlIGZ1dHVyZSwKPiA+
IHdpdGhvdXQgbWVzc2luZyB3aXRoIGxvY2FsIHggbm9uLWxvY2FsIHJlbGF0aXZlIG5hbWVzcGFj
ZS4gIAo+IAo+IEhvdyBhYm91dCBjaGFuZ2luZyB0aGUgcmVsYXRpdmUgcmVmZXJlbmNlcyBzbyB0
aGF0IHNvbWV0aGluZyBsaWtlCj4gRG9jdW1lbnRhdGlvbi9yZWNpcGVzLnR4dCBiZWNvbWVzIC4v
RG9jdW1lbnRhdGlvbi9yZWNpcGVzLnR4dD8KClNvdW5kcyBhIGdvb2QgaWRlYSB0byBtZS4gQW5k
cmVhPwoKVGhhbmtzLApNYXVybwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9k
cmktZGV2ZWwK
