From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Fri, 27 Jan 2023 07:59:23 +0100
Message-ID: <b4622942-67e7-969b-4439-0aea7c5bd165@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674802763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLT9CjpwUzvWOcEZLv9zytJzCJGpAe8NLiJP8y0cIzA=;
        b=Loka0f/lOTAOKetC36RiUPXf8LKkgEV8RKNWurxl8EXsFRV+1STEi8WnNo2DYHGcDq1B/P
        lZfypDW21xT+8FiHpkr79HVWbdB/O0L3R3iPskcQa9blJ5HWipqZZr/fhEpkeI0JnW2CK/
        Huy2VSWEi1oMETy5kQh0OPK7B2BJScQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674802763;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLT9CjpwUzvWOcEZLv9zytJzCJGpAe8NLiJP8y0cIzA=;
        b=Jkf/KBwpbKNvyVKMeIIKyN5EinnlU/ebIN6HYt5eOZHu0aC2vhBvuAKdv2mdpPJo/mskWm
        o+P/iBouYlF34gDQ==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gTm93IHRoYXQgYmxr
X3B1dF9xdWV1ZSBjYW4gYmUgY2FsbGVkIGZyb20gcHJvY2VzcyBjb250ZXh0LCB0aGVyIGlzIG5v
Cj4gbmVlZCBmb3IgdGhlIGFzeW5jaHJvbm91cyBleGVjdXRpb24uCj4gCkNhbiB5b3UgY2xhcmlm
eSAnbm93Jz8KSUUgcG9pbnQgdG8gdGhlIGNvbW1pdCBpbnRyb2R1Y2luZyB0aGUgY2hhbmdlPwoK
PiBUaGlzIGVmZmVjdGl2ZWx5IHJldmVydHMgY29tbWl0IGQ1NzhjNzcwYzg1MjMzYWY1OTJlNTQ1
MzdmOTNmMzgzMWJkZTdlOWEuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBibG9jay9ibGstY2dyb3VwLmMgfCAzMiArKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgYmxvY2svYmxrLWNncm91cC5oIHwgIDUgKy0tLS0K
PiAgIDIgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pCj4g
ClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhh
bm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFn
ZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5
IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4g
NSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bD
vGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBC
b3VkaWVuIE1vZXJtYW4KCg==
