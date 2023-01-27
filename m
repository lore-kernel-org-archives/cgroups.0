From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 07/15] blk-wbt: pass a gendisk to wbt_init
Date: Fri, 27 Jan 2023 08:05:17 +0100
Message-ID: <6c05179a-62fc-f041-da08-8c95a61be742@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-8-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wd8xgRRUTIVdNOaI3TqxJ7HbVqeTrKQd21CSSsNgKKM=;
        b=QmLaQlaDO9eRneRVTIPn5P2pU9jHr2A27cy22etuTPuXdPERraoKajj6mEjftJfyISQNgb
        GZCIZJ8U0taBjD2Yd1UY2ir4qqBw8XVHEOPPR+IlylGT9PF7xb7/zqIguHqxQvOQGX2HUs
        ac1gnX4Nd9W7HQfzICXcsFzelvpk7hc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wd8xgRRUTIVdNOaI3TqxJ7HbVqeTrKQd21CSSsNgKKM=;
        b=SlwZhIU10HwzyMQeZWpkPlhSURgBBrgYWNa078sqDiPDFdHqBJRuUeFEMXxlGB/ez3FpHz
        9EdrFl4l2IRvKXCA==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-8-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gUGFzcyBhIGdlbmRp
c2sgdG8gd2J0X2luaXQgdG8gcHJlcGFyZSBmb3IgcGhhc2luZyBvdXQgdXNhZ2Ugb2YgdGhlCj4g
cmVxdWVzdF9xdWV1ZSBpbiB0aGUgYmxrLWNncm91cCBjb2RlLgo+IAo+IFNpZ25lZC1vZmYtYnk6
IENocmlzdG9waCBIZWxsd2lnIDxoY2gtamNzd0doTVVWOWdAcHVibGljLmdtYW5lLm9yZz4KPiAt
LS0KPiAgIGJsb2NrL2Jsay1zeXNmcy5jIHwgMiArLQo+ICAgYmxvY2svYmxrLXdidC5jICAgfCA1
ICsrKy0tCj4gICBibG9jay9ibGstd2J0LmggICB8IDQgKystLQo+ICAgMyBmaWxlcyBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4gUmV2aWV3ZWQtYnk6IEhhbm5lcyBS
ZWluZWNrZSA8aGFyZS1sM0E1Qms3d2FHTUBwdWJsaWMuZ21hbmUub3JnPgoKQ2hlZXJzLAoKSGFu
bmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdl
IEFyY2hpdGVjdApoYXJlLWwzQTVCazd3YUdNQHB1YmxpYy5nbWFuZS5vcmcgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9u
cyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xy
bmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJl
dyBNY0RvbmFsZCwgTWFydGplIEJvdWRpZW4gTW9lcm1hbgoK
