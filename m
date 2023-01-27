From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/15] block: don't call blk_throtl_stat_add for
 non-READ/WRITE commands
Date: Fri, 27 Jan 2023 08:00:30 +0100
Message-ID: <b7335ffe-9230-3791-5de5-4f98c8414789@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-3-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674802830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/kg5AS6XYWWstGUf7pEtDuX/nvVku38MMV3LB6qGdE=;
        b=PqtEAMhUDo4Cv2ao3GZl9fsH1VoKurVnAmgnUK9Nx1pqAlMQhRlMy4AuadG4FirggtT5Qh
        XX88OGjVGeBrHjBK69n9HyTRyD4UBMysLIFv6SoAF/fNlwoWiGc6rXbSISjr5LD+DLif9u
        p0+4jACKtAsOp7D51wl84Zpej3H4lsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674802830;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/kg5AS6XYWWstGUf7pEtDuX/nvVku38MMV3LB6qGdE=;
        b=9Jrff9C5cwNap80CFNbaVK9nxoVT2m1hYtjlv94BjVoFDPuNUtwt7rlxWu0yqKwrUzRZwa
        aARTfRVOMETot9Cg==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-3-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gYmxrX3Rocm90bF9z
dGF0X2FkZCBpcyBjYWxsZWQgZnJvbSBibGtfc3RhdF9hZGQgZXhwbGljaXRseSwgdW5saWtlIHRo
ZQo+IG90aGVyIHN0YXRzIHRoYXQgZ28gdGhyb3VnaCBxLT5zdGF0cy0+Y2FsbGJhY2tzLiAgVG8g
cHJlcGFyZSBmb3IgY2dyb3VwCj4gZGF0YSBtb3ZpbmcgdG8gdGhlIGdlbmRpc2ssIGVuc3VyZSBi
bGtfdGhyb3RsX3N0YXRfYWRkIGlzIG9ubHkgY2FsbGVkCj4gZm9yIHRoZSBwbGFpbiBSRUFEIGFu
ZCBXUklURSBjb21tYW5kcyB0aGF0IGl0IGFjdHVhbGx5IGhhbmRsZXMgaW50ZXJuYWxseSwKPiBh
cyBibGtfc3RhdF9hZGQgY2FuIGFsc28gYmUgY2FsbGVkIGZvciBwYXNzdGhyb3VnaCBjb21tYW5k
cyBvbiBxdWV1ZXMgdGhhdAo+IGRvIG5vdCBoYXZlIGEgZ2VuaXNrIGFzc29jaWF0ZWQgd2l0aCB0
aGVtLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+
IC0tLQo+ICAgYmxvY2svYmxrLXN0YXQuYyB8IDMgKystCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVj
a2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNr
ZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2Fy
ZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgw
OSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15
ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCg==
