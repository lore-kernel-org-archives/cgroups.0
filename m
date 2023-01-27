From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/15] blk-cgroup: store a gendisk to throttle in struct
 task_struct
Date: Fri, 27 Jan 2023 08:03:50 +0100
Message-ID: <71e9dc41-58d9-eca8-bfec-d9a2e1395c73@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-6-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzQjW4PPGp55LC9UPKshgKBQV8sYzIFxItt8Fd90xAQ=;
        b=gITBh/+G94e9A/k75E6f0QgHkdm1iK5jJMqpCtSw4uKOb/eDO+HpCKfKhXf/79C9AQo8E+
        NC3CHmThECsbMOlHbHV1ZShUNlC1leMcUt3U0a/93LjcosCvO7n0F13mTpXur/RNLpeZSZ
        /5uAs0AJzJ1s+LNM/Vn2SVn4yhEj674=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803030;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzQjW4PPGp55LC9UPKshgKBQV8sYzIFxItt8Fd90xAQ=;
        b=oYxBxAfbtNwan5mN4iER7PdyA/JZDMP6fqCOGmRZbXTe6Tg+Qj29zRwM9kQKaqNOMP6bMD
        VXdRvG1uiZSpu0Cg==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-6-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gU3dpdGNoIGZyb20g
YSByZXF1ZXN0X3F1ZXVlIHBvaW50ZXIgYW5kIHJlZmVyZW5jZSB0byBhIGdlbmRpc2sgb25jZQo+
IGZvciB0aGUgdGhyb3R0bGUgaW5mb3JtYXRpb24gaW4gc3RydWN0IHRhc2tfc3RydWN0Lgo+IAo+
IE1vdmUgdGhlIGNoZWNrIGZvciB0aGUgZGVhZCBkaXNrIHRvIHRoZSBsYXRlc3QgcGxhY2Ugbm93
IHRoYXQgaXMgaXMKPiB1bmJvdW5kbGVkIGZyb20gdGhlIHJlZmVyZW5jZSBncmFiLgo+IAo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxv
Y2svYmxrLWNncm91cC5jICAgIHwgMzcgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0t
LS0tLQo+ICAgaW5jbHVkZS9saW51eC9zY2hlZC5oIHwgIDIgKy0KPiAgIGtlcm5lbC9mb3JrLmMg
ICAgICAgICB8ICAyICstCj4gICBtbS9zd2FwZmlsZS5jICAgICAgICAgfCAgMiArLQo+ICAgNCBm
aWxlcyBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkKPiAKUmV2aWV3
ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0t
IApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hp
dGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0
MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQw
OSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjog
SXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJldyBNY0RvbmFsZCwgTWFydGplIEJvdWRpZW4g
TW9lcm1hbgoK
