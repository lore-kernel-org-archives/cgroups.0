From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v6 1/3] block, bfq: record how many queues are busy
 in bfq_group
Date: Sat, 28 May 2022 10:18:11 +0200
Message-ID: <8D29A46A-4B8A-4F05-BCE3-D9D0F0D2DD5A@linaro.org>
References: <20220523131818.2798712-1-yukuai3@huawei.com>
 <20220523131818.2798712-2-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zKQyiSCqOmFTXYg1oyMhrbRM1Y8cO4uyy6QdrPFWc8E=;
        b=Frk0CGa66mdgvvN98mA9x6NKT/Z+nOGLGMG5bYj54sZE8Lhp9JhuJvuNY8yJL6EsZI
         J3KIhCqyxlqhcg12/bSe/job0NO779KynECC8rcca8uR6CiSMYGeq+csLaG62ntXqacJ
         dES90AYO7hHJd/EBXB70EazwxzZAxQ/XqUC68IfGd/viKP5tX3k5dd7+J3dFugplJ0ZL
         HCtaNmUK65p5QGjx9s99ZizndE/FKgUz8a6LdwkrXWbXo8MBz6hq33pm7UTq4M7V0Qgp
         HStjHM0DBPi2iLS3eYgBuKVtopPlt2JeDZsqhPmHs5vRh2cFRTyoyDGf+vcfRFuYNDFQ
         jvNw==
In-Reply-To: <20220523131818.2798712-2-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 23 mag 2022, alle ore 15:18, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha =
scritto:
>=20
> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
>=20
> Add a counter 'busy_queues' in bfq_group, and update it in
> bfq_add/del_bfqq_busy().
>=20
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
> block/bfq-cgroup.c  |  1 +
> block/bfq-iosched.h |  2 ++
> block/bfq-wf2q.c    | 20 ++++++++++++++++++++
> 3 files changed, 23 insertions(+)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 09574af83566..4d516879d9fa 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data =
*pd)
> 				   */
> 	bfqg->bfqd =3D bfqd;
> 	bfqg->active_entities =3D 0;
> +	bfqg->busy_queues =3D 0;
> 	bfqg->online =3D true;
> 	bfqg->rq_pos_tree =3D RB_ROOT;
> }
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 978ef5d6fe6a..3847f4ab77ac 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -906,6 +906,7 @@ struct bfq_group_data {
>  *                   are groups with more than one active @bfq_entity
>  *                   (see the comments to the function
>  *                   bfq_bfqq_may_idle()).
> + * @busy_queues: number of busy bfqqs.
>  * @rq_pos_tree: rbtree sorted by next_request position, used when
>  *               determining if two or more queues have interleaving
>  *               requests (see bfq_find_close_cooperator()).
> @@ -942,6 +943,7 @@ struct bfq_group {
> 	struct bfq_entity *my_entity;
>=20
> 	int active_entities;
> +	int busy_queues;
>=20
> 	struct rb_root rq_pos_tree;
>=20
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index f8eb340381cf..d9ff33e0be38 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -218,6 +218,16 @@ static bool bfq_no_longer_next_in_service(struct =
bfq_entity *entity)
> 	return false;
> }
>=20
> +static void bfq_inc_busy_queues(struct bfq_queue *bfqq)
> +{
> +	bfqq_group(bfqq)->busy_queues++;
> +}
> +
> +static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
> +{
> +	bfqq_group(bfqq)->busy_queues--;
> +}
> +
> #else /* CONFIG_BFQ_GROUP_IOSCHED */
>=20
> static bool bfq_update_parent_budget(struct bfq_entity =
*next_in_service)
> @@ -230,6 +240,14 @@ static bool bfq_no_longer_next_in_service(struct =
bfq_entity *entity)
> 	return true;
> }
>=20
> +static void bfq_inc_busy_queues(struct bfq_queue *bfqq)
> +{
> +}
> +
> +static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
> +{
> +}
> +
> #endif /* CONFIG_BFQ_GROUP_IOSCHED */
>=20
> /*
> @@ -1660,6 +1678,7 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, =
struct bfq_queue *bfqq,
> 	bfq_clear_bfqq_busy(bfqq);
>=20
> 	bfqd->busy_queues[bfqq->ioprio_class - 1]--;
> +	bfq_inc_busy_queues(bfqq);
>=20

Why do you increment the number of busy queues for the group on a
del_bfqq_busy, instead of an add_bfqq_busy?

Besides, the name of the function bfq_inc_busy_queues does not mention
the target of the update, namely the group.  This creates a little
confusion at a first sight, as one sees this function invoked right
after the update of a field with the same name: bfqd->busy_queues.

> 	if (bfqq->wr_coeff > 1)
> 		bfqd->wr_busy_queues--;
> @@ -1683,6 +1702,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, =
struct bfq_queue *bfqq)
>=20
> 	bfq_mark_bfqq_busy(bfqq);
> 	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
> +	bfq_dec_busy_queues(bfqq);

Same pair of comments as above.

Thanks,
Paolo

>=20
> 	if (!bfqq->dispatched)
> 		if (bfqq->wr_coeff =3D=3D 1)
> --=20
> 2.31.1
>=20

