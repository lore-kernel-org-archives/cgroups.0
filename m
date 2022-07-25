From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Mon, 25 Jul 2022 16:16:49 +0200
Message-ID: <20220725141649.ou7tsntv4xnqtbmc@wittgenstein>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
 <YtwFjPnCtw8ySnuv@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658758614;
        bh=p9/gFb1902RLnmreUeNFAHcbKgrOvbu9N0D0jG7+uBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AkOKY3UMzdkfecaitmz6IXmVhF5eNwiBrQE/mS4uiWu2IL70SzLVLCisC10ETcVtI
         enMoVGVUa76JLUafYZ7b+snwHVt6YHktjb+0COvfAyK44Jc/bmBGa0ivJ5KLrmz4jY
         RuCK5I8BIFEWanDSM1IHJImxMAj3y5K+Z1ulenmactWnPMMG2huJGlONVz0agoXahA
         /KtXIk8smhLeMBRh2brDlTf56bx9iirwtnFhOOkLn/Crgy7zEFiAxUXXQuzv62r3z3
         mJRjANXJft/74cvd9pymtRgZBano2iJxOsLU02p72Ymcsgjc3Bewp86Gs2F1WP+dEi
         m2LhCzQRgnEOQ==
Content-Disposition: inline
In-Reply-To: <YtwFjPnCtw8ySnuv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gU2F0LCBKdWwgMjMsIDIwMjIgYXQgMDQ6Mjg6MjhBTSAtMTAwMCwgVGVqdW4gSGVvIHdyb3Rl
Ogo+IDM5NDJhOWJkN2I1OCAoImxvY2tpbmcsIHJjdSwgY2dyb3VwOiBBdm9pZCBzeW5jaHJvbml6
ZV9zY2hlZCgpIGluCj4gX19jZ3JvdXBfcHJvY3Nfd3JpdGUoKSIpIGRpc2FibGVkIHBlcmNwdSBv
cGVyYXRpb25zIG9uIHRocmVhZGdyb3VwX3J3c2VtCj4gYmVjYXVzZSB0aGUgaW1waWxlZCBzeW5j
aHJvbml6ZV9yY3UoKSBvbiB3cml0ZSBsb2NraW5nIHdhcyBwdXNoaW5nIHVwIHRoZQo+IGxhdGVu
Y2llcyB0b28gbXVjaCBmb3IgYW5kcm9pZCB3aGljaCBjb25zdGFudGx5IG1vdmVzIHByb2Nlc3Nl
cyBiZXR3ZWVuCj4gY2dyb3Vwcy4KPiAKPiBUaGlzIG1ha2VzIHRoZSBob3R0ZXIgcGF0aHMgLSBm
b3JrIGFuZCBleGl0IC0gc2xvd2VyIGFzIHRoZXkncmUgYWx3YXlzCj4gZm9yY2VkIGludG8gdGhl
IHNsb3cgcGF0aC4gVGhlcmUgaXMgbm8gcmVhc29uIHRvIGZvcmNlIHRoaXMgb24gZXZlcnlvbmUK
PiBlc3BlY2lhbGx5IGdpdmVuIHRoYXQgbW9yZSBjb21tb24gc3RhdGljIHVzYWdlIHBhdHRlcm4g
Y2FuIG5vdyBjb21wbGV0ZWx5Cj4gYXZvaWQgd3JpdGUtbG9ja2luZyB0aGUgcndzZW0uIFdyaXRl
LWxvY2tpbmcgaXMgZWxpZGVkIHdoZW4gdHVybmluZyBvbiBhbmQKPiBvZmYgY29udHJvbGxlcnMg
b24gZW1wdHkgc3ViLXRyZWVzIGFuZCBDTE9ORV9JTlRPX0NHUk9VUCBlbmFibGVzIHNlZWRpbmcg
YQo+IGNncm91cCB3aXRob3V0IGdyYWJiaW5nIHRoZSByd3NlbS4KPiAKPiBSZXN0b3JlIHRoZSBk
ZWZhdWx0IHBlcmNwdSBvcGVyYXRpb25zIGFuZCBpbnRyb2R1Y2UgdGhlIG1vdW50IG9wdGlvbgo+
ICJmYXZvcmR5bm1vZHMiIGFuZCBjb25maWcgb3B0aW9uIENHUk9VUF9GQVZPUl9EWU5NT0RTIGZv
ciB1c2VycyB3aG8gbmVlZAo+IGxvd2VyIGxhdGVuY2llcyBmb3IgdGhlIGR5bmFtaWMgb3BlcmF0
aW9ucy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBUZWp1biBIZW8gPHRqLURnRWpUK0FpMnlnZG5tK3lS
T2ZFMEFAcHVibGljLmdtYW5lLm9yZz4KPiBDYzogQ2hyaXN0aWFuIEJyYXVuZXIgPGJyYXVuZXIt
RGdFalQrQWkyeWdkbm0reVJPZkUwQUBwdWJsaWMuZ21hbmUub3JnPgo+IENjOiBNaWNoYWwgS291
dG7DvSA8bWtvdXRueS1JQmk5UkcvYjY3a0BwdWJsaWMuZ21hbmUub3JnPgo+IENjOiBQZXRlciBa
aWpsc3RyYSA8cGV0ZXJ6LXdFR0NpS0hlMkxxV1ZmZUF3QTd4SFFAcHVibGljLmdtYW5lLm9yZz4K
PiBDYzogSm9obiBTdHVsdHogPGpvaG4uc3R1bHR6LVFTRWo1RllRaG00ZG5tK3lST2ZFMEFAcHVi
bGljLmdtYW5lLm9yZz4KPiBDYzogRG1pdHJ5IFNobWlkdCA8ZGltaXRyeXNoLWhwSXFzRDRBS2xm
UVQwZFpSK0FsZkFAcHVibGljLmdtYW5lLm9yZz4KPiBDYzogT2xlZyBOZXN0ZXJvdiA8b2xlZy1I
K3dYYUh4ZjdhTFFUMGRaUitBbGZBQHB1YmxpYy5nbWFuZS5vcmc+Cj4gLS0tCgpTZWVtcyBzYW5l
LApBY2tlZC1ieTogQ2hyaXN0aWFuIEJyYXVuZXIgKE1pY3Jvc29mdCkgPGJyYXVuZXItRGdFalQr
QWkyeWdkbm0reVJPZkUwQUBwdWJsaWMuZ21hbmUub3JnPgo=
