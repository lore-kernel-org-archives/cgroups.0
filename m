From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while activating
 policy
Date: Tue, 17 Jan 2023 09:01:58 +0800
Message-ID: <1d490092-09b2-d1ec-ebfe-195113cef0a3@huaweicloud.com>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230103112833.2013432-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Jens

=D4=DA 2023/01/03 19:28, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> If the policy defines pd_online_fn(), it should be called after
> pd_init_fn(), like blkg_create().
>=20
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Can you apply this patch?

Thanks,
Kuai
> ---
>   block/blk-cgroup.c | 4 ++++
>   1 file changed, 4 insertions(+)
>=20
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index ce6a2b7d3dfb..4c94a6560f62 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1455,6 +1455,10 @@ int blkcg_activate_policy(struct request_queue *q,
>   		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
>   			pol->pd_init_fn(blkg->pd[pol->plid]);
>  =20
> +	if (pol->pd_online_fn)
> +		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
> +			pol->pd_online_fn(blkg->pd[pol->plid]);
> +
>   	__set_bit(pol->plid, q->blkcg_pols);
>   	ret =3D 0;
>  =20
>=20

