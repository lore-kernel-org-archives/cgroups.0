From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Date: Sun, 1 May 2022 16:44:26 +0300
Message-ID: <78b556f9-e57b-325d-89ce-7a482ef4ea21@openvz.org>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
 <20220427122232.GA9823@blackbody.suse.cz>
 <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
 <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
 <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BV3tGIJv7cFXsfQYEsVnmGBSG8UYA5OrP4bIavH19vc=;
        b=5C9vsM9JO0foLVFVwJQY+KCxjm5dt4gLiPBDX6BnoNNpHVRiQkEzJIa/51wfrSRbQy
         zImlHIe4w97QCzLHQnZHKqs80dxh3Fr7WRTQif3OsfAwLgxMGjL2+TfT4ZFhJd/8WXCY
         mZYhAi9H4JF9aWNw9AkV1WsPThXQjbqr0xP1x7K42o5UGAFFrObxDVBAu+er2DHAVZYJ
         cSemtxMIU52D3NZiVwjNzkmb+yMqiWRGUzNLj6QMK57z5Q0pwk8JG6Oou0H+jo7PraJH
         ql1XCa+FKj7YhCfHy5WoKK8blBlojg4hJ4CN6JXmYcrE5g5Soaelo6wlUm7Ux+9CaR8D
         pV9g==
Content-Language: en-US
In-Reply-To: <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

T24gNC8yOC8yMiAwMTo0NywgU2hha2VlbCBCdXR0IHdyb3RlOgo+IE9uIFdlZCwgQXByIDI3LCAy
MDIyIGF0IDM6NDMgUE0gVmFzaWx5IEF2ZXJpbiA8dnZzLUdFRkFRelpYN3I4ZG5tK3lST2ZFMEFA
cHVibGljLmdtYW5lLm9yZz4gd3JvdGU6Cj4+Cj4+IE9uIDQvMjcvMjIgMTg6MDYsIFNoYWtlZWwg
QnV0dCB3cm90ZToKPj4+IE9uIFdlZCwgQXByIDI3LCAyMDIyIGF0IDU6MjIgQU0gTWljaGFsIEtv
dXRuw70gPG1rb3V0bnktSUJpOVJHL2I2N2tAcHVibGljLmdtYW5lLm9yZz4gd3JvdGU6Cj4+Pj4K
Pj4+PiBPbiBUdWUsIEFwciAyNiwgMjAyMiBhdCAxMDoyMzozMlBNIC0wNzAwLCBTaGFrZWVsIEJ1
dHQgPHNoYWtlZWxiLWhwSXFzRDRBS2xmUVQwZFpSK0FsZkFAcHVibGljLmdtYW5lLm9yZz4gd3Jv
dGU6Cj4+Pj4+IFsuLi5dCj4+Pj4+Pgo+Pj4+Pj4gK3N0YXRpYyBpbmxpbmUgc3RydWN0IG1lbV9j
Z3JvdXAgKmdldF9tZW1fY2dyb3VwX2Zyb21fb2JqKHZvaWQgKnApCj4+Pj4+PiArewo+Pj4+Pj4g
KyAgICAgICBzdHJ1Y3QgbWVtX2Nncm91cCAqbWVtY2c7Cj4+Pj4+PiArCj4+Pj4+Cj4+Pj4+IERv
IHdlIG5lZWQgbWVtY2dfa21lbV9lbmFibGVkKCkgY2hlY2sgaGVyZSBvciBtYXliZQo+Pj4+PiBt
ZW1fY2dyb3VwX2Zyb21fb2JqKCkgc2hvdWxkIGJlIGRvaW5nIG1lbWNnX2ttZW1fZW5hYmxlZCgp
IGluc3RlYWQgb2YKPj4+Pj4gbWVtX2Nncm91cF9kaXNhYmxlZCgpIGFzIHdlIGNhbiBoYXZlICJj
Z3JvdXAubWVtb3J5PW5va21lbSIgYm9vdAo+Pj4+PiBwYXJhbS4KPj4KPj4gU2hha2VlbCwgdW5m
b3J0dW5hdGVseSBJJ20gbm90IHJlYWR5IHRvIGFuc3dlciB0aGlzIHF1ZXN0aW9uIHJpZ2h0IG5v
dy4KPj4gSSBldmVuIGRpZCBub3Qgbm90aWNlZCB0aGF0IG1lbWNnX2ttZW1fZW5hYmxlZCgpIGFu
ZCBtZW1fY2dyb3VwX2Rpc2FibGVkKCkKPj4gaGF2ZSBhIGRpZmZlcmVudCBuYXR1cmUuCj4+IElm
IHlvdSBoYXZlIG5vIG9iamVjdGlvbnMgSSdtIGdvaW5nIHRvIGtlZXAgdGhpcyBwbGFjZSBhcyBp
cyBhbmQgaW52ZXN0aWdhdGUKPj4gdGhpcyBxdWVzdGlvbiBsYXRlci4KPj4KPiAKPiBQYXRjaCBp
cyBnb29kIGFzIGlzLiBKdXN0IGFkZCB0aGUgZG9jdW1lbnRhdGlvbiB0byB0aGUgZnVuY3Rpb25z
IGluCj4gdGhlIG5leHQgdmVyc2lvbiBhbmQgeW91IGNhbiBrZWVwIHRoZSBBQ0tzLgoKSSBub3Rp
Y2VkIHRoYXQgdGhlIGtlcm5lbCBhbHJlYWR5IGhhcyBhIGZ1bmN0aW9uIGdldF9tZW1fY2dyb3Vw
X2Zyb21fb2JqY2coKSwKdGhlIG5hbWUgb2Ygd2hpY2ggaXMgdmVyeSBzaW1pbGFyIHRvIG15IG5l
dyBmdW5jdGlvbiBnZXRfbWVtX2Nncm91cF9mcm9tX29iaigpLgpNYXliZSBpdCdzIGJldHRlciB0
byByZW5hbWUgbXkgZnVuY3Rpb24gdG8gZ2V0X21lbV9jZ3JvdXBfZnJvbV9wdHIoKT8KClRoYW5r
IHlvdSwKCVZhc2lseSBBdmVyaW4K
