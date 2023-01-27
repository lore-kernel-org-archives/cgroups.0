From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Fri, 27 Jan 2023 08:43:18 +0100
Message-ID: <df9c772c-6fb5-1ebe-6b9a-7d052d9f05f0@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-2-hch@lst.de>
 <b4622942-67e7-969b-4439-0aea7c5bd165@suse.de> <20230127070754.GB4180@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674805399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JI/wpxgIv1o0sTmnkxzVSGkE+8mTK7sPuU0QG23TKI=;
        b=EqIDPXJijHRpJFC0wlMxMNVbRlqW2RwIS8I1Lqz9jGoxXM7jFvfzghk13Grp77m1uFVnV8
        0KDjgbR+/TI8SY5RIb/Bd2ltnat8wZ7zyvXGhGVSgzg7yZv+ZeDD6CDKa8FAcUSu1euLsj
        JHx9EI5fDMCuR5gvKu+XrvSaFggUC5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674805399;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JI/wpxgIv1o0sTmnkxzVSGkE+8mTK7sPuU0QG23TKI=;
        b=/twYLq2i4LDG1Ix54DAMhGZf7aVUb/GyfOdsvaMgkiHhWCxxpyHc+eCrPChILIYvin406D
        zv8pa6Mqh0Ai25Aw==
Content-Language: en-US
In-Reply-To: <20230127070754.GB4180@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8yNy8yMyAwODowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gT24gRnJpLCBKYW4g
MjcsIDIwMjMgYXQgMDc6NTk6MjNBTSArMDEwMCwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+PiBP
biAxLzE3LzIzIDA5OjEyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPj4+IE5vdyB0aGF0IGJs
a19wdXRfcXVldWUgY2FuIGJlIGNhbGxlZCBmcm9tIHByb2Nlc3MgY29udGV4dCwgdGhlciBpcyBu
bwo+Pj4gbmVlZCBmb3IgdGhlIGFzeW5jaHJvbm91cyBleGVjdXRpb24uCj4+Pgo+PiBDYW4geW91
IGNsYXJpZnkgJ25vdyc/Cj4+IElFIHBvaW50IHRvIHRoZSBjb21taXQgaW50cm9kdWNpbmcgdGhl
IGNoYW5nZT8KPiAKPiA0OWU0ZDA0ZjA0ODYxMTdhYzU3YTk3ODkwZWIxZGI2ZDUyYmY4MmIzCj4g
QXV0aG9yOiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+Cj4gRGF0ZTogICBGcmkgSmFuIDYgMTA6
MzQ6MTAgMjAyMyAtMTAwMAo+IAo+ICAgICAgYmxvY2s6IERyb3Agc3B1cmlvdXMgbWlnaHRfc2xl
ZXAoKSBmcm9tIGJsa19wdXRfcXVldWUoKQo+IApDYW4gd2UgcGxlYXNlIGhhdmUgaXQgaW4gdGhl
IHBhdGNoIGNvbW1lbnQ/ClRvIGNsYXJpZnkgdGhhdCB0aGlzIGlzIGEgcHJlLXJlcXVpc2l0ZSBm
b3IgdGhpcyBwYXRjaD8KClRoYW5rcy4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBS
ZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNl
LmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBT
b2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhS
QiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5k
cmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCg==
