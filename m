From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: Re: [PATCH] cgroup:cgroup_mount: Fix uninitialized warning
Date: Fri, 20 Jun 2014 08:57:56 -0700
Message-ID: <CABq-xd3o2rjwKMa2HR9GvDwOHFr-9i1kwjauc0KzeYZNf02scA@mail.gmail.com>
References: <CABYERD89BtTTJh8j0d0kvCU-xNEy8YJhFaPFr+hjuy5gWQoVNg@mail.gmail.com>
	<20140419125706.GA3277@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:sender:in-reply-to:references:date:message-id:subject
	:from:to:cc:content-type;
	bh=9Pn2uQS4GUi7Mbx3/cpkpfeNz3DaoZGtfnaT572p25c=;
	b=Sau6Q4VSudG2iCBNQaySCcVdTuwSi+mQxHyIkFjk3ReuiP1TLCxXdWuMEmunt17ghq
	BA0dsH352cAMI15dq3y+3boT+AkGoaCk9+rQqPoOQNPPxrIKtmntVVLLgRXEjbAw09qb
	RAidEAbCl/L9JKTYqEZbElfHKbfgzYR90AYZm16pr3C7rdnGsMN0KcU5/BWaV6QkwuC4
	xQ+k9HXD0/CITZWjXw2EqHEt3V/H+tHK71hj7JtCmI/AeEHX9QJLddylV8wpQOseYSS8
	4VCLKEp37CT9Rbs+ip4lHI1ONJQEZfnlMSazs7p2ddOPrFdstODjqrgma9MWMzlyNJG8
	Juaw==
In-Reply-To: <20140419125706.GA3277-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Takeshi Misawa <jeantsuru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

SSdtIHNlZWluZyB0aGlzIHRvbyBpbiBMaW51cydzIGN1cnJlbnQgdHJlZSAodjMuMTYtcmMxLTEx
Mi1nODk0ZTU1Mikgd2l0aDoKCmdjYyB2ZXJzaW9uIDQuNi4zIDIwMTIwMzA2IChSZWQgSGF0IDQu
Ni4zLTIpIChHQ0MpCgoKCk9uIFNhdCwgQXByIDE5LCAyMDE0IGF0IDU6NTcgQU0sIFRlanVuIEhl
byA8dGpAa2VybmVsLm9yZz4gd3JvdGU6Cgo+IE9uIFNhdCwgQXByIDE5LCAyMDE0IGF0IDA5OjUy
OjE0UE0gKzA5MDAsIFRha2VzaGkgTWlzYXdhIHdyb3RlOgo+ID4gVGhpcyBwYXRjaCBmaXhlcyB0
aGUgZm9sbG93aW5nIHdhcm5pbmcuCj4gPgo+ID4ga2VybmVsL2Nncm91cC5jOiBJbiBmdW5jdGlv
biDigJhjZ3JvdXBfbW91bnTigJk6Cj4gPiBrZXJuZWwvY2dyb3VwLmM6MTYwOToxMzogd2Fybmlu
Zzog4oCYcm9vdOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluCj4gdGhpcwo+ID4gZnVu
Y3Rpb24KPgo+IFdoaWNoIGNvbXBpbGVyIGFyZSB5b3UgdXNpbmc/ICBUaGlzIGlzIGEgc3B1cmlv
dXMgd2FybmluZyB3aGljaCB0aGUKPiBjb21waWxlciBzaG91bGQgYmUgYWJsZSB0byBhdm9pZCBw
cmV0dHkgZWFzaWx5Lgo+Cj4gVGhhbmtzLgo+Cj4gLS0KPiB0ZWp1bgo+IC0tCj4gVG8gdW5zdWJz
Y3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJlIGxpbnV4LWtl
cm5lbCIgaW4KPiB0aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVs
Lm9yZwo+IE1vcmUgbWFqb3Jkb21vIGluZm8gYXQgIGh0dHA6Ly92Z2VyLmtlcm5lbC5vcmcvbWFq
b3Jkb21vLWluZm8uaHRtbAo+IFBsZWFzZSByZWFkIHRoZSBGQVEgYXQgIGh0dHA6Ly93d3cudHV4
Lm9yZy9sa21sLwo+CgoKCi0tIApEYXZlCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkNvbnRhaW5lcnMgbWFpbGluZyBsaXN0CkNvbnRhaW5lcnNAbGlzdHMu
bGludXgtZm91bmRhdGlvbi5vcmcKaHR0cHM6Ly9saXN0cy5saW51eGZvdW5kYXRpb24ub3JnL21h
aWxtYW4vbGlzdGluZm8vY29udGFpbmVycw==
