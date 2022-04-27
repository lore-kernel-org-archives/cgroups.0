From: Vasily Averin <vvs@openvz.org>
Subject: Re: [PATCH] memcg: accounting for objects allocated for new netdevice
Date: Thu, 28 Apr 2022 01:35:54 +0300
Message-ID: <53613f02-75f2-0546-d84c-a5ed989327b6@openvz.org>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <CALvZod6Dz7iw=gyiQ2pDVe2RJxF-7PbVoptwFZCw=sWtxpBBGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zxjODgdLfXb5bMGzaUtB+izM+jyIRFXXBicqRczakdE=;
        b=kOgHkvcXiKDHcf0FPKISXEY5HqGfG/C3VTxC3r+qCyDNb58YQ2Ffm1EN+ZlnNbcklN
         3xuHlw7dI5IAdFE/+iGt8WZvjfO7q6k8VKBoPN743YhsElb89sF9gZKHOWTWzA2c3Rwd
         54YF4aIVaLRZWzwG0KTZKcgCLNVNHLGg3rCWfTKevXQPCDYDJ2IZuZKHtRmaqsYwSR5p
         XpJhcPiWYNEZefwnTjp4pe/ygtOPWtd5Talc9/MypxxDHY+1wSUIaXiRzkx85TXRbhgt
         S+SnpKe5BVSbjw/sLPVHQ/cE9dacC5fnJ8dVd88zXJ4RowaAf8I5IZSkR41CoM++9DjB
         nvZw==
Content-Language: en-US
In-Reply-To: <CALvZod6Dz7iw=gyiQ2pDVe2RJxF-7PbVoptwFZCw=sWtxpBBGQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Shakeel Butt <shakeelb@google.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, kernel@openvz.org, Florian Westphal <fw@strlen.de>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

T24gNC8yNy8yMiAxOTo1MiwgU2hha2VlbCBCdXR0IHdyb3RlOgo+IE9uIFdlZCwgQXByIDI3LCAy
MDIyIGF0IDc6MDEgQU0gTWljaGFsIEtvdXRuw70gPG1rb3V0bnlAc3VzZS5jb20+IHdyb3RlOgo+
Pgo+PiBIZWxsbyBWYXNpbHkuCj4+Cj4+IE9uIFdlZCwgQXByIDI3LCAyMDIyIGF0IDAxOjM3OjUw
UE0gKzAzMDAsIFZhc2lseSBBdmVyaW4gPHZ2c0BvcGVudnoub3JnPiB3cm90ZToKPj4+IGRpZmYg
LS1naXQgYS9mcy9rZXJuZnMvbW91bnQuYyBiL2ZzL2tlcm5mcy9tb3VudC5jCj4+PiBpbmRleCBj
ZmE3OTcxNWZjMWEuLjI4ODFhZWVhYTg4MCAxMDA2NDQKPj4+IC0tLSBhL2ZzL2tlcm5mcy9tb3Vu
dC5jCj4+PiArKysgYi9mcy9rZXJuZnMvbW91bnQuYwo+Pj4gQEAgLTM5MSw3ICszOTEsNyBAQCB2
b2lkIF9faW5pdCBrZXJuZnNfaW5pdCh2b2lkKQo+Pj4gIHsKPj4+ICAgICAgIGtlcm5mc19ub2Rl
X2NhY2hlID0ga21lbV9jYWNoZV9jcmVhdGUoImtlcm5mc19ub2RlX2NhY2hlIiwKPj4+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKHN0cnVjdCBrZXJu
ZnNfbm9kZSksCj4+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IDAsIFNMQUJfUEFOSUMsIE5VTEwpOwo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAwLCBTTEFCX1BBTklDIHwgU0xBQl9BQ0NPVU5ULCBOVUxMKTsKPj4KPj4g
a2VybmZzIGFjY291bnRpbmcgeW91IHNheT8KPj4ga2VybmZzIGJhY2tzIHVwIGFsc28gY2dyb3Vw
cywgc28gdGhlIHBhcmVudC1jaGlsZCBhY2NvdW50aW5nIGNvbWVzIHRvIG15Cj4+IG1pbmQuCj4+
IFNlZSB0aGUgdGVtcG9yYXJ5IHN3aXRjaCB0byBwYXJlbnQgbWVtY2cgaW4gbWVtX2Nncm91cF9j
c3NfYWxsb2MoKS4KPj4KPj4gKEkgbWVhbiB0aGlzIG1ha2VzIHNvbWUgc2Vuc2UgYnV0IEknZCBz
dWdnZXN0IHVubHVtcGluZyB0aGUga2VybmZzIGludG8KPj4gYSBzZXBhcmF0ZSBwYXRoIGZvciBw
b3NzaWJsZSBkaXNjdXNzaW9uIGFuZCBpdHMgbm90LW9ubHktbmV0ZGV2aWNlCj4+IGVmZmVjdHMu
KQo+IAo+IEkgYWdyZWUgd2l0aCBNaWNoYWwgdGhhdCBrZXJuZnMgYWNjb3VudGluZyBzaG91bGQg
YmUgaXRzIG93biBwYXRjaC4KPiBJbnRlcm5hbGx5IGF0IEdvb2dsZSwgd2UgYWN0dWFsbHkgaGF2
ZSBlbmFibGVkIHRoZSBtZW1jZyBhY2NvdW50aW5nIG9mCj4ga2VybmZzIG5vZGVzLiBXZSBoYXZl
IHdvcmtsb2FkcyB3aGljaCBjcmVhdGUgMTAwcyBvZiBzdWJjb250YWluZXJzIGFuZAo+IHdpdGhv
dXQgbWVtY2cgYWNjb3VudGluZyBvZiBrZXJuZnMgd2Ugc2VlIGhpZ2ggc3lzdGVtIG92ZXJoZWFk
LgoKSSBoYWQgdGhpcyBpZGVhIChpLmUuIG1vdmUga2VybmZzIGFjY291bnRpbmcgaW50byBzZXBh
cmF0ZSBwYXRjaCkgdG9vLCAKYnV0IGZpbmFsbHkgZGVjaWRlZCB0byBpbmNsdWRlIGl0IGludG8g
Y3VycmVudCBwYXRjaC4KCktlcm5mcyBhY2NvdW50aW5nIGlzIGNyaXRpY2FsIGZvciBkZXNjcmli
ZWQgc2NlbmFyaW8uIFdpdGhvdXQgaXQgdHlwaWNhbApuZXRkZXZpY2UgY3JlYXRpbmcgd2lsbCBj
aGFyZ2Ugb25seSB+NTAlIG9mIGFsbG9jYXRlZCBtZW1vcnksIGFuZCB0aGUgcmVzdApvZiBwYXRj
aCBkb2VzIG5vdCBhbGxvdyB0byBwcm90ZWN0IHRoZSBob3N0IHByb3Blcmx5LgoKTm93IEknbSBn
b2luZyB0byBmb2xsb3cgeW91ciByZWNvbW1lbmRhdGlvbiBhbmQgc3BsaXQgdGhlIHBhdGNoLgoK
VGhhbmsgeW91LAoJVmFzaWx5IEF2ZXJpbgo=
