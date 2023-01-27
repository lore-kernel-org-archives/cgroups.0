From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/15] blk-cgroup: pass a gendisk to
 blkcg_{de,}activate_policy
Date: Fri, 27 Jan 2023 08:10:07 +0100
Message-ID: <e406314e-a653-e740-07a4-459b7d268f55@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-13-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c2h1EfogbrH617NU2DIxPJq9dSZ3YCB/X2AcnKU9uTk=;
        b=OUHgXlZXD/78sKFFeqh806P5pUXzeXYnZ8xWRa6bEoEgtePs7mT1dTrKc9ETTOzBXp4pi+
        0Q4dkNU6Zfryal0bmep1oO5QrDfeCEYRjdo9uqKFKTEXy8Mqu2jjyvBiXucC+yViRI2/F1
        DFywYjyP7AI9BgrCW4yzpjTUBmE5y8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803407;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c2h1EfogbrH617NU2DIxPJq9dSZ3YCB/X2AcnKU9uTk=;
        b=jGYDJopwY3eX0Y2osrjRzXNAUHsUI2J1bD52ry22k8JzlFEovcwbME0L3aVmywgMpB/uo/
        Dstm/mW9IDOklwDg==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-13-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gUHJlcGFyZSBmb3Ig
c3RvcmluZyB0aGUgYmxrY2cgaW5mb3JtYXRpb24gaW4gdGhlIGdlbmRpc2sgaW5zdGVhZCBvZgo+
IHRoZSByZXF1ZXN0X3F1ZXVlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2ln
IDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svYmZxLWNncm91cC5jICAgIHwgIDIgKy0KPiAg
IGJsb2NrL2JmcS1pb3NjaGVkLmMgICB8ICAyICstCj4gICBibG9jay9ibGstY2dyb3VwLmMgICAg
fCAxOSArKysrKysrKysrLS0tLS0tLS0tCj4gICBibG9jay9ibGstY2dyb3VwLmggICAgfCAgOSAr
KysrLS0tLS0KPiAgIGJsb2NrL2Jsay1pb2Nvc3QuYyAgICB8ICA0ICsrLS0KPiAgIGJsb2NrL2Js
ay1pb2xhdGVuY3kuYyB8ICA0ICsrLS0KPiAgIGJsb2NrL2Jsay1pb3ByaW8uYyAgICB8ICA0ICsr
LS0KPiAgIGJsb2NrL2Jsay10aHJvdHRsZS5jICB8ICA0ICsrLS0KPiAgIDggZmlsZXMgY2hhbmdl
ZCwgMjQgaW5zZXJ0aW9ucygrKSwgMjQgZGVsZXRpb25zKC0pCj4gUmV2aWV3ZWQtYnk6IEhhbm5l
cyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVz
IFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1
c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNF
IFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcK
SFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBB
bmRyZXcKTXllcnMsIEFuZHJldyBNY0RvbmFsZCwgTWFydGplIEJvdWRpZW4gTW9lcm1hbgoK
