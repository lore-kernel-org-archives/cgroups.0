From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/15] blk-rq-qos: store a gendisk instead of
 request_queue in struct rq_qos
Date: Fri, 27 Jan 2023 08:09:32 +0100
Message-ID: <5a72b381-136f-9688-a9ff-55f864da97de@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-12-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2pRrd5k7g1uwTsHx9iU0ASkkFTR8jvngVE0eFg7IaBo=;
        b=K7OjMjaq1CxTCix10gs5KycsHqphwe5ku601It6EmmEF7NGYkSUBgjLQUMh3A3a9+1+MNd
        Pkz4gOQVXmX5GU8/15w7JW84v2k5O9b7ij9WYBJrYB77r4PtZAakA+Cv2wl+ZyUjC0asIB
        dvs18QAl1A7qoSznk04wtHe9BeUzvo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803373;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2pRrd5k7g1uwTsHx9iU0ASkkFTR8jvngVE0eFg7IaBo=;
        b=ngnPWpqJNqMmqb0Cb7hBqdqaKE8w2YK2MoTJUaszzupzv4bHHYDgcqZKidit1XfxLaqwHD
        cASLhxSRApNv1XDw==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-12-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVGhpcyBpcyB3aGF0
IGFib3V0IGhhbGYgb2YgdGhlIHVzZXJzIGFscmVhZHkgd2FudCwgYW5kIGl0J3Mgb25seSBnb2lu
ZyB0bwo+IGdyb3cgbW9yZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4KPiAtLS0KPiAgIGJsb2NrL2Jsay1pb2Nvc3QuYyAgICAgfCAxMiArKysrKyst
LS0tLS0KPiAgIGJsb2NrL2Jsay1pb2xhdGVuY3kuYyAgfCAxNCArKysrKysrLS0tLS0tLQo+ICAg
YmxvY2svYmxrLW1xLWRlYnVnZnMuYyB8IDEwICsrKystLS0tLS0KPiAgIGJsb2NrL2Jsay1ycS1x
b3MuYyAgICAgfCAgNCArKy0tCj4gICBibG9jay9ibGstcnEtcW9zLmggICAgIHwgIDIgKy0KPiAg
IGJsb2NrL2Jsay13YnQuYyAgICAgICAgfCAxNiArKysrKysrLS0tLS0tLS0tCj4gICA2IGZpbGVz
IGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQo+IFJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIu
IEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QK
aGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2
ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8
cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBU
b3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJt
YW4KCg==
