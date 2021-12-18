From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC] block, bfq: update pos_root for idle bfq_queue in
 bfq_bfqq_move()
Date: Sat, 18 Dec 2021 17:09:22 +0800
Message-ID: <680073dc-cdaf-8634-e536-7f07997c5d93@huawei.com>
References: <20211210081641.3025060-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211210081641.3025060-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2021/12/10 16:16, Yu Kuai =D0=B4=B5=C0:
> During code review, we found that if bfqq is not busy in
> bfq_bfqq_move(), bfq_pos_tree_add_move() won't be called for the bfqq,
> thus bfqq->pos_root still points to the old bfqg. However, the ref
> that bfqq hold for the old bfqg will be released, so it's possible
> that the old bfqg can be freed. This is problematic because the freed
> bfqg can still be accessed by bfqq->pos_root.
>=20
> Fix the problem by calling bfq_pos_tree_add_move() for idle bfqq
> as well.
>=20
Friendly ping ...
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/bfq-cgroup.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 24a5c5329bcd..85f34c29b909 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -645,6 +645,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_=
queue *bfqq,
>   		   struct bfq_group *bfqg)
>   {
>   	struct bfq_entity *entity =3D &bfqq->entity;
> +	struct bfq_group *old_parent =3D bfqq_group(bfqq);
>  =20
>   	/*
>   	 * Get extra reference to prevent bfqq from being freed in
> @@ -666,7 +667,6 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_=
queue *bfqq,
>   		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
>   	else if (entity->on_st_or_in_serv)
>   		bfq_put_idle_entity(bfq_entity_service_tree(entity), entity);
> -	bfqg_and_blkg_put(bfqq_group(bfqq));
>  =20
>   	if (entity->parent &&
>   	    entity->parent->last_bfqq_created =3D=3D bfqq)
> @@ -679,11 +679,16 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bf=
q_queue *bfqq,
>   	/* pin down bfqg and its associated blkg  */
>   	bfqg_and_blkg_get(bfqg);
>  =20
> -	if (bfq_bfqq_busy(bfqq)) {
> -		if (unlikely(!bfqd->nonrot_with_queueing))
> -			bfq_pos_tree_add_move(bfqd, bfqq);
> +	/*
> +	 * Don't leave the pos_root to old bfqg, since the ref to old bfqg will
> +	 * be released and the bfqg might be freed.
> +	 */
> +	if (unlikely(!bfqd->nonrot_with_queueing))
> +		bfq_pos_tree_add_move(bfqd, bfqq);
> +	bfqg_and_blkg_put(old_parent);
> +
> +	if (bfq_bfqq_busy(bfqq))
>   		bfq_activate_bfqq(bfqd, bfqq);
> -	}
>  =20
>   	if (!bfqd->in_service_queue && !bfqd->rq_in_driver)
>   		bfq_schedule_dispatch(bfqd);
>=20
