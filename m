From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CGroup Namespaces (v8)
Date: Sat, 2 Jan 2016 06:52:57 -0500
Message-ID: <20160102115257.GD3660@htj.duckdns.org>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
 <CAA9_cmcNeg4vR7Ft8YcPGZtacftDWjC=5mHs2ZRzu9yXoOAJiA@mail.gmail.com>
 <20160101085911.GA28407@mail.hallyn.com>
 <CAPcyv4iig_sujK=p0TbNjTmtv39N7a0HSqpVe8mLnfX9Es7zNA@mail.gmail.com>
 <20160101180633.GA30941@mail.hallyn.com>
 <CAPcyv4iEdP+jMVSFquqCgMiXFgzOSaW40NdG6y2tHRgSKxaOcQ@mail.gmail.com>
Reply-To: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-type:content-disposition:in-reply-to:user-agent;
 bh=4PzFqajwDxbusWoXCnWkfsyRdSo4Zc1hb3EyxB+KdsE=;
 b=UoCqgSTJvUhBo84LPkrBH+NVQE9zEB4TQ4P1x5llxfleTXyYPJg0rjNrn4lSmBfY2+
 1OEdoFFo0omuYPq2Nc91avDLIUXNP4KkBnYCt3/sq0T019nNBy4Q3CRiYmARxctkGeo9
 4uYZy9tFeZnc/a7PjWpOVt3/DQuvYIKYzyVREfaXkvytmlX5jzgLcK63ccV7Yr7aT6t1
 sH2LzELglnaU01qD1KU1pHB1qZLX2s5QjKGHrxj6yctX80S4obwUgIflFJzacDtVdA8j
 UJeaL3dCQUsJvIpm6czdsepsrbpl5tHT2VtptVZiVoR52IDE/LQxes/g3W4zwYxd7mdg
 zYiA==
Content-Disposition: inline
In-Reply-To: <CAPcyv4iEdP+jMVSFquqCgMiXFgzOSaW40NdG6y2tHRgSKxaOcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.linuxcontainers.org/options/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxcontainers.org/pipermail/lxc-devel/>
List-Post: <mailto:lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
List-Help: <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linuxcontainers.org/listinfo/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org
Sender: "lxc-devel" <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

T24gRnJpLCBKYW4gMDEsIDIwMTYgYXQgMTE6MTQ6MTRBTSAtMDgwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+IE9uIEZyaSwgSmFuIDEsIDIwMTYgYXQgMTA6MDYgQU0sIFNlcmdlIEUuIEhhbGx5bgo+
IDxzZXJnZS5oYWxseW5AdWJ1bnR1LmNvbT4gd3JvdGU6Cj4gPiBPbiBGcmksIEphbiAwMSwgMjAx
NiBhdCAwMTo0Mjo1N0FNIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4gPj4gQ29tbWl0IDU0
YjM5ZDI2MzcwNCAiY2dyb3VwOiBjZ3JvdXAgbmFtZXNwYWNlIHNldG5zIHN1cHBvcnQiIG5vdAo+
ID4+IGJvb3RpbmcgaXMgYSBzZXBhcmF0ZSBpc3N1ZS4KPiA+Cj4gPiBPaCAtIGJlZW4gdGhlcmUg
c2luY2UgbXkgZmlyc3QgdmVyc2lvbiBvZiB0aGUgc2V0ICh2NCkuICBPZGQsIEkKPiA+IHRob3Vn
aHQgdGhhdCB0aGUgYXV0b21hdGVkIGtvcmcgdGVzdGluZyBjYXVnaHQgdGhvc2UuCj4gPgo+ID4g
V2hhdCBpcyB0aGUgc2ltcGxlc3Qgd2F5IHRvIGZpeCB0aGlzPyAgRG8gSSBzZW5kIG5ldyB2ZXJz
aW9ucyBvZgo+ID4gcGF0Y2hlcyB2MyBhbmQgdjQ/ICBEb2VzIFRlanVuIG9yIFN0ZXBoZW4ganVz
dCBkbyBpdCBpbmxpbmUgaW4gdGhlCj4gPiBnaXQgdHJlZT8gIERvIHdlIGxlYXZlIGl0IGJlPwo+
IAo+IEknbSBhc3N1bWluZyBpdCBjYW4gYmUgZml4ZWQgdXAgd2hlbiB5b3UgcmUtc3BpbiB0aGUg
cGF0Y2hlcyB0byBmaXgKPiB0aGUgYm9vdCBmYWlsdXJlLgoKSSByZXZlcnRlZCB0aGUgY2dyb3Vw
IG5hbWVzcGFjZSBwYXRjaHNldCBmb3IgdGhlIHRpbWUgYmVpbmcuCgpUaGFua3MuCgotLSAKdGVq
dW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbHhjLWRl
dmVsIG1haWxpbmcgbGlzdApseGMtZGV2ZWxAbGlzdHMubGludXhjb250YWluZXJzLm9yZwpodHRw
Oi8vbGlzdHMubGludXhjb250YWluZXJzLm9yZy9saXN0aW5mby9seGMtZGV2ZWwK
