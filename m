From: Shinichiro Kawasaki <shinichiro.kawasaki-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Tue, 24 Jan 2023 00:09:25 +0000
Message-ID: <20230124000925.pfosl6pfuhjyggbp@shindev>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674518969; x=1706054969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HuWMV4ZQUcsxiaasaJMrNYOD8MZEWm7fDBH40ZxIv4k=;
  b=h03QDIQpRg4kLrdy/I+q/mjP3BcsIM1siUuaj8vzOSacwkO+QbJkKyEX
   r0F8MTfGzUOVfbn0k+niqNKbMl4zRuDyiFdkWFU95nTMwZsQXJmX3lRYw
   Sr9Z2P+4lMiaKMQ3clfIdLK0A9lST1y/iWWls+WYnZQWRFf0WiFcHRJek
   KG/vYbnQ2BXkYWPSKUPz8joDF7fTLyA+zKZe45LWeOVzEQ1gIpdauRBN2
   DqtkOK8lLwqh2lOeLy+jSFHdnUNqF0KIVDjeYqwJyiWitZJAxMkaX8cSu
   rxfPXSQ6M2UocopkNv3YzmPcCod6qArb9fEGL0wYBJXznGnHLqpz4+XJ6
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/tipZoAlpuQrHapEU0k7KITm6Ygr1oWSQQAtecTwt4=;
 b=klr5Ncqs6zEnEurci1Dqz6UK8xcVoAQlVba3rQktVE9jBYtlGtAj4o+3Kjc3x2d1GM7ZV5Vtnecq3n3923ZPlpWNuX6bbzyLkc+W9YbcgQvq+LlcnIRKzhHVu8yQi7kXY7V0/TmjQujVbegl79JRszsRFP2W6fJ49NXZ6+G04f8=
In-Reply-To: <20230113094410.2907223-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <6C91E2F8801FB64D86D91C3DA08A2915-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org" <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org" <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, "yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Jan 13, 2023 / 17:44, Yu Kuai wrote:
> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"=
),
> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
> bic->bfqq will be freed first, and bic_set_bfqq() is called with the free=
d
> bic->bfqq.
>=20
> Fix the problem by always freeing bfqq after bic_set_bfqq().
>=20
> Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
> Reported-and-tested-by: Shinichiro Kawasaki <shinichiro.kawasaki-Sjgp3cTcYWE@public.gmane.org>
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/bfq-cgroup.c  | 2 +-
>  block/bfq-iosched.c | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index a6e8da5f5cfd..feb13ac25557 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -749,8 +749,8 @@ static void bfq_sync_bfqq_move(struct bfq_data *bfqd,
>  		 * old cgroup.
>  		 */
>  		bfq_put_cooperator(sync_bfqq);
> -		bfq_release_process_ref(bfqd, sync_bfqq);
>  		bic_set_bfqq(bic, NULL, true, act_idx);
> +		bfq_release_process_ref(bfqd, sync_bfqq);
>  	}
>  }
> =20

Yu, thanks for posting this fix, but it can not be applied to v6.2-rc5. The
hunk above looks different from the patch I tested. Could you take a look?

--=20
Shin'ichiro Kawasaki=
