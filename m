From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] blk-iocost: random patches to improve
 configuration
Date: Sat, 12 Nov 2022 14:13:52 +0800
Message-ID: <87cec928-84ac-8362-a92f-ff80d5bd28e3@huaweicloud.com>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221104023938.2346986-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Jens

Can you apply this patchset?

Thanks!
Kuai

=D4=DA 2022/11/04 10:39, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Changes in v2:
>   - add review tag from Christoph for patch 1-3
>   - add a mutex to fix warnning as suggested by Christoph
>   - add patch 5
>=20
> Yu Kuai (5):
>    blk-iocost: cleanup ioc_qos_write() and ioc_cost_model_write()
>    blk-iocost: improve hanlder of match_u64()
>    blk-iocost: don't allow to configure bio based device
>    blk-iocost: fix sleeping in atomic context warnning
>    blk-iocost: read params inside lock in sysfs apis
>=20
>   block/blk-iocost.c | 116 +++++++++++++++++++++++++++++----------------
>   1 file changed, 74 insertions(+), 42 deletions(-)
>=20

