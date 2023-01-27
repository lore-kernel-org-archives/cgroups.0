From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/15] blk-cgroup: pass a gendisk to blkg_lookup
Date: Fri, 27 Jan 2023 08:11:32 +0100
Message-ID: <51040b52-d33d-0862-0603-89862355d836@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-15-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0T0w5O/tlM1UgpvGtrWg0UhYzZIb1MgPzuh3ztNM15Q=;
        b=sS8Q3aGqBCtL+Es50ueHJC9DVgUkHsp0L+hA2P4MBuV2qDPzz7kNPwO12F57gS4S4v36Ba
        OA4JAxefIe1XwbM2ymEvztz2cfwCAUUm91tPfWllEdrkEd2ZECEFyj3KhnSHNv270/Sz5f
        nj59CdX1PMcVUBbIoliaS4ZKgDZy9Gk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803493;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0T0w5O/tlM1UgpvGtrWg0UhYzZIb1MgPzuh3ztNM15Q=;
        b=+yK/U3HdnwQu/xmnHjZxVNci7sERd19CVwkpL1b7GzBIEctisqAxSWDwF/c+TYYBwHoo7j
        xpYDGsm+1IU8iLAw==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-15-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gUGFzcyBhIGdlbmRp
c2sgdG8gYmxrZ19sb29rdXAgYW5kIHVzZSB0aGF0IHRvIGZpbmQgdGhlIG1hdGNoIGFzIHBhcnQK
PiBvZiBwaGFzaW5nIG91dCB1c2FnZSBvZiB0aGUgcmVxdWVzdF9xdWV1ZSBpbiB0aGUgYmxrLWNn
cm91cCBjb2RlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPgo+IC0tLQo+ICAgYmxvY2svYmxrLWNncm91cC5jIHwgMTYgKysrKysrKystLS0tLS0tLQo+
ICAgYmxvY2svYmxrLWNncm91cC5oIHwgMjAgKysrKysrKysrKy0tLS0tLS0tLS0KPiAgIDIgZmls
ZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCj4gClJldmlld2Vk
LWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAK
RHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRl
Y3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1
MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkg
TsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2
byBUb3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1v
ZXJtYW4KCg==
