From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Sun, 29 Jan 2023 09:38:11 +0800
Message-ID: <4d3f6183-f9d4-b657-0205-fc240bc24c76@huaweicloud.com>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230113094410.2907223-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, shinichiro.kawasaki-Sjgp3cTcYWE@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Jens

=D4=DA 2023/01/13 17:44, Yu Kuai =D0=B4=B5=C0:
> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"=
),
> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
> bic->bfqq will be freed first, and bic_set_bfqq() is called with the freed
> bic->bfqq.
>=20
> Fix the problem by always freeing bfqq after bic_set_bfqq().
>=20

Sorry that I send this patch will wrong email, and you might missed this
patch.

Can you apply this patch? This patch can't be applied directly to lower
version due to Paolo's patchset, I'll send lts patch seperately.

Thanks,
Kuai
> Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
> Reported-and-tested-by: Shinichiro Kawasaki <shinichiro.kawasaki-Sjgp3cTc=
YWE@public.gmane.org>
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

