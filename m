From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/15] blk-wbt: pass a gendisk to
 wbt_{enable,disable}_default
Date: Fri, 27 Jan 2023 08:04:36 +0100
Message-ID: <14d2f5a5-f410-925d-6c14-beb5f7248766@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-7-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5oYcuFZCrWqLYXOkKHCS4tL28AtAXslMRk6rt2qsGvQ=;
        b=tPkqpDcMu1PgiSWLVHKEiV35oRW9/vIrsp1kFWvioL2bx6nAHQsXU3i6OJbjjfnwLiHpu4
        bXqdESw32MV7QHXr5zGglJ4mt6b4KP5LYY+EyZzg7TyDErDQrLUSlbuP1W5Wqn/kqnLkG7
        g0YNgoDZ4q+Lk6cGaUoVg2nidSgEI1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803076;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5oYcuFZCrWqLYXOkKHCS4tL28AtAXslMRk6rt2qsGvQ=;
        b=drYhQOFcWCUd//t8MqNY8IR9s3VwhTlcbaE1DWK7TywSuP1Dl1r3H7RxFjDqD9UIWQvYCw
        1fEuzfMP6RupbKAg==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-7-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gUGFzcyBhIGdlbmRp
c2sgdG8gd2J0X2VuYWJsZV9kZWZhdWx0IGFuZCB3YnRfZGlzYWJsZV9kZWZhdWx0IHRvCj4gcHJl
cGFyZSBmb3IgcGhhc2luZyBvdXQgdXNhZ2Ugb2YgdGhlIHJlcXVlc3RfcXVldWUgaW4gdGhlIGJs
ay1jZ3JvdXAKPiBjb2RlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svYmZxLWlvc2NoZWQuYyB8IDQgKystLQo+ICAgYmxv
Y2svYmxrLWlvY29zdC5jICB8IDQgKystLQo+ICAgYmxvY2svYmxrLXN5c2ZzLmMgICB8IDIgKy0K
PiAgIGJsb2NrL2Jsay13YnQuYyAgICAgfCA3ICsrKystLS0KPiAgIGJsb2NrL2Jsay13YnQuaCAg
ICAgfCA4ICsrKystLS0tCj4gICA1IGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEy
IGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2Uu
ZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAg
ICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdt
YkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVy
ZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1j
RG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgo=
