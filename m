From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 9/9] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Fri, 10 Dec 2021 11:21:23 +0100
Message-ID: <AA66019E-FD14-4821-B53D-0C56EEC38828@linaro.org>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <20211127101132.486806-10-yukuai3@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9sCOFfVXKOb72pzCs42FTZ/cd5XaBleh+IQy0MaKkyI=;
        b=RZvN1zdXgjnJPYh2pBxHDRdgCKI0D7oHr0yrYysET1rY8G/67b/coHgj3VZndRUJTm
         c8xYdIaYYrgAszVsTSJ/RkVS5thuseN83YYdINUG04wOsTrjyN3nG3rI8BBhrbAKqMdL
         /fZILYMCwFN4Cf1m7eOWOO48m50vYsGaMHmb2uVTCowLNgRkfBr3k76bZvzNoi5MwH3B
         YkyLpSqBFONu3YRZRsCYAOz0u/lFQzw7ciAQlkuAVD5RqKZIceM5Wy88DJDP2WNW1R1h
         7af3OmbHmDrCt/Wg9nwmq59t0CfBZllRzeYVWDMBcgFftpsS+OHU9ci4ypVjqciWundh
         QuEQ==
In-Reply-To: <20211127101132.486806-10-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha =
scritto:
>=20
> Currently 'num_groups_with_pending_reqs' won't be decreased when
> the group doesn't have any pending requests, while any child group
> have any pending requests. The decrement is delayed to when all the
> child groups doesn't have any pending requests.
>=20
> For example:
> 1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
> child group. num_groups_with_pending_reqs is 2 now.
> 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
> t3 still can't be handled concurrently.
>=20
> Fix the problem by decreasing 'num_groups_with_pending_reqs'
> immediately upon the deactivation of last entity of the group.
>=20

I don't understand this patch clearly.

I understand your proposal not to count a group as with pending =
requests, in case no child process of the group has IO, but only its =
child groups have pending requests.

So, entities here are only queues for this patch?

If they are only queues, I think it is still incorrect to remove the =
group from the count of groups with pending IO when all its child queues =
are deactivated, because there may still be unfinished IO for those =
queues.

Am I missing something?

Thanks,
Paolo

> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> block/bfq-iosched.c | 58 ++++++++++++++++-----------------------------
> block/bfq-iosched.h | 16 ++++++-------
> 2 files changed, 29 insertions(+), 45 deletions(-)
>=20
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 4239b3996e23..55925e1ee85d 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -873,6 +873,26 @@ void __bfq_weights_tree_remove(struct bfq_data =
*bfqd,
> 	bfq_put_queue(bfqq);
> }
>=20
> +static void decrease_groups_with_pending_reqs(struct bfq_data *bfqd,
> +					      struct bfq_queue *bfqq)
> +{
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +	struct bfq_entity *entity =3D bfqq->entity.parent;
> +	struct bfq_group *bfqg =3D container_of(entity, struct =
bfq_group, entity);
> +
> +	/*
> +	 * The decrement of num_groups_with_pending_reqs is performed
> +	 * immediately upon the deactivation of last entity that have =
pending
> +	 * requests
> +	 */
> +	if (!bfqg->num_entities_with_pending_reqs &&
> +	    entity->in_groups_with_pending_reqs) {
> +		entity->in_groups_with_pending_reqs =3D false;
> +		bfqd->num_groups_with_pending_reqs--;
> +	}
> +#endif
> +}
> +
> /*
>  * Invoke __bfq_weights_tree_remove on bfqq and decrement the number
>  * of active groups for each queue's inactive parent entity.
> @@ -880,46 +900,10 @@ void __bfq_weights_tree_remove(struct bfq_data =
*bfqd,
> void bfq_weights_tree_remove(struct bfq_data *bfqd,
> 			     struct bfq_queue *bfqq)
> {
> -	struct bfq_entity *entity =3D bfqq->entity.parent;
> -
> 	bfqq->ref++;
> 	__bfq_weights_tree_remove(bfqd, bfqq,
> 				  &bfqd->queue_weights_tree);
> -
> -	for_each_entity(entity) {
> -		struct bfq_sched_data *sd =3D entity->my_sched_data;
> -
> -		if (sd && (sd->next_in_service || =
sd->in_service_entity)) {
> -			/*
> -			 * entity is still active, because either
> -			 * next_in_service or in_service_entity is not
> -			 * NULL (see the comments on the definition of
> -			 * next_in_service for details on why
> -			 * in_service_entity must be checked too).
> -			 *
> -			 * As a consequence, its parent entities are
> -			 * active as well, and thus this loop must
> -			 * stop here.
> -			 */
> -			break;
> -		}
> -
> -		/*
> -		 * The decrement of num_groups_with_pending_reqs is
> -		 * not performed immediately upon the deactivation of
> -		 * entity, but it is delayed to when it also happens
> -		 * that the first leaf descendant bfqq of entity gets
> -		 * all its pending requests completed. The following
> -		 * instructions perform this delayed decrement, if
> -		 * needed. See the comments on
> -		 * num_groups_with_pending_reqs for details.
> -		 */
> -		if (entity->in_groups_with_pending_reqs) {
> -			entity->in_groups_with_pending_reqs =3D false;
> -			bfqd->num_groups_with_pending_reqs--;
> -		}
> -	}
> -
> +	decrease_groups_with_pending_reqs(bfqd, bfqq);
> 	bfq_put_queue(bfqq);
> }
>=20
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index df08bff89a70..7ae11f62900b 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -493,7 +493,7 @@ struct bfq_data {
> 	struct rb_root_cached queue_weights_tree;
>=20
> 	/*
> -	 * Number of groups with at least one descendant process that
> +	 * Number of groups with at least one process that
> 	 * has at least one request waiting for completion. Note that
> 	 * this accounts for also requests already dispatched, but not
> 	 * yet completed. Therefore this number of groups may differ
> @@ -506,14 +506,14 @@ struct bfq_data {
> 	 * bfq_better_to_idle().
> 	 *
> 	 * However, it is hard to compute this number exactly, for
> -	 * groups with multiple descendant processes. Consider a group
> -	 * that is inactive, i.e., that has no descendant process with
> +	 * groups with multiple processes. Consider a group
> +	 * that is inactive, i.e., that has no process with
> 	 * pending I/O inside BFQ queues. Then suppose that
> 	 * num_groups_with_pending_reqs is still accounting for this
> -	 * group, because the group has descendant processes with some
> +	 * group, because the group has processes with some
> 	 * I/O request still in flight. num_groups_with_pending_reqs
> 	 * should be decremented when the in-flight request of the
> -	 * last descendant process is finally completed (assuming that
> +	 * last process is finally completed (assuming that
> 	 * nothing else has changed for the group in the meantime, in
> 	 * terms of composition of the group and active/inactive state =
of child
> 	 * groups and processes). To accomplish this, an additional
> @@ -522,7 +522,7 @@ struct bfq_data {
> 	 * we resort to the following tradeoff between simplicity and
> 	 * accuracy: for an inactive group that is still counted in
> 	 * num_groups_with_pending_reqs, we decrement
> -	 * num_groups_with_pending_reqs when the first descendant
> +	 * num_groups_with_pending_reqs when the last
> 	 * process of the group remains with no request waiting for
> 	 * completion.
> 	 *
> @@ -530,12 +530,12 @@ struct bfq_data {
> 	 * carefulness: to avoid multiple decrements, we flag a group,
> 	 * more precisely an entity representing a group, as still
> 	 * counted in num_groups_with_pending_reqs when it becomes
> -	 * inactive. Then, when the first descendant queue of the
> +	 * inactive. Then, when the last queue of the
> 	 * entity remains with no request waiting for completion,
> 	 * num_groups_with_pending_reqs is decremented, and this flag
> 	 * is reset. After this flag is reset for the entity,
> 	 * num_groups_with_pending_reqs won't be decremented any
> -	 * longer in case a new descendant queue of the entity remains
> +	 * longer in case a new queue of the entity remains
> 	 * with no request waiting for completion.
> 	 */
> 	unsigned int num_groups_with_pending_reqs;
> --=20
> 2.31.1
>=20

