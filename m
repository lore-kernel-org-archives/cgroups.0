From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH 2/2] block: Make refcnt of bfq_group/bfq_queue atomic
Date: Mon, 17 Oct 2022 16:28:00 +0800
Message-ID: <6e6aa502-01d0-d5d8-9193-a3fee2a17335@huaweicloud.com>
References: <20221011145246.8656-1-set_pte_at@outlook.com>
 <TYCP286MB2323F5B27A24ABA2CD1A3F70CA239@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <TYCP286MB2323F5B27A24ABA2CD1A3F70CA239@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Dawei Li <set_pte_at@outlook.com>, axboe@kernel.dk, tj@kernel.org, paolo.valente@linaro.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2022/10/11 22:52, Dawei Li =D0=B4=B5=C0:
> For most implementations of reference count, atomic_t is preferred
> for their natural-born atomic ops capability.
> Change the reference count of bfq_group/bfq_queue, both data structures
> and related ops, into atomic.

I'm afraid that this is unnecessary, the modifications of reference
count are inside spin_lock() in bfq.

Thanks,
Kuai
>=20
> Signed-off-by: Dawei Li <set_pte_at@outlook.com>
> ---
>   block/bfq-cgroup.c  |  8 +++----
>   block/bfq-iosched.c | 54 +++++++++++++++++++++++----------------------
>   block/bfq-iosched.h |  6 ++---
>   block/bfq-wf2q.c    |  6 ++---
>   4 files changed, 37 insertions(+), 37 deletions(-)
>=20
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 144bca006463..714126ba21b6 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -316,14 +316,12 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
>  =20
>   static void bfqg_get(struct bfq_group *bfqg)
>   {
> -	bfqg->ref++;
> +	atomic_inc(&bfqg->ref);
>   }
>  =20
>   static void bfqg_put(struct bfq_group *bfqg)
>   {
> -	bfqg->ref--;
> -
> -	if (bfqg->ref =3D=3D 0)
> +	if (atomic_dec_and_test(&bfqg->ref))
>   		kfree(bfqg);
>   }
>  =20
> @@ -659,7 +657,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_=
queue *bfqq,
>   	 * Get extra reference to prevent bfqq from being freed in
>   	 * next possible expire or deactivate.
>   	 */
> -	bfqq->ref++;
> +	atomic_inc(&bfqq->ref);
>  =20
>   	/* If bfqq is empty, then bfq_bfqq_expire also invokes
>   	 * bfq_del_bfqq_busy, thereby removing bfqq and its entity
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 7ea427817f7f..fbe5624be71f 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -935,7 +935,7 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, stru=
ct bfq_queue *bfqq,
>  =20
>   inc_counter:
>   	bfqq->weight_counter->num_active++;
> -	bfqq->ref++;
> +	atomic_inc(&bfqq->ref);
>   }
>  =20
>   /*
> @@ -1224,9 +1224,10 @@ bfq_bfqq_resume_state(struct bfq_queue *bfqq, stru=
ct bfq_data *bfqd,
>  =20
>   static int bfqq_process_refs(struct bfq_queue *bfqq)
>   {
> -	return bfqq->ref - bfqq->entity.allocated -
> +	return atomic_read(&bfqq->ref) - bfqq->entity.allocated -
>   		bfqq->entity.on_st_or_in_serv -
> -		(bfqq->weight_counter !=3D NULL) - bfqq->stable_ref;
> +		(bfqq->weight_counter !=3D NULL) -
> +		atomic_read(&bfqq->stable_ref);
>   }
>  =20
>   /* Empty burst list and add just bfqq (see comments on bfq_handle_burst=
) */
> @@ -2818,7 +2819,7 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_=
queue *new_bfqq)
>   	 * expected to be associated with new_bfqq as they happen to
>   	 * issue I/O.
>   	 */
> -	new_bfqq->ref +=3D process_refs;
> +	atomic_add(process_refs, &new_bfqq->ref);
>   	return new_bfqq;
>   }
>  =20
> @@ -5255,10 +5256,10 @@ void bfq_put_queue(struct bfq_queue *bfqq)
>   	struct hlist_node *n;
>   	struct bfq_group *bfqg =3D bfqq_group(bfqq);
>  =20
> -	bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d", bfqq, bfqq->ref);
> +	bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d", bfqq,
> +		     atomic_read(&bfqq->ref));
>  =20
> -	bfqq->ref--;
> -	if (bfqq->ref)
> +	if (!atomic_dec_and_test(&bfqq->ref))
>   		return;
>  =20
>   	if (!hlist_unhashed(&bfqq->burst_list_node)) {
> @@ -5328,7 +5329,7 @@ void bfq_put_queue(struct bfq_queue *bfqq)
>  =20
>   static void bfq_put_stable_ref(struct bfq_queue *bfqq)
>   {
> -	bfqq->stable_ref--;
> +	atomic_dec(&bfqq->stable_ref);
>   	bfq_put_queue(bfqq);
>   }
>  =20
> @@ -5358,7 +5359,7 @@ static void bfq_exit_bfqq(struct bfq_data *bfqd, st=
ruct bfq_queue *bfqq)
>   		bfq_schedule_dispatch(bfqd);
>   	}
>  =20
> -	bfq_log_bfqq(bfqd, bfqq, "exit_bfqq: %p, %d", bfqq, bfqq->ref);
> +	bfq_log_bfqq(bfqd, bfqq, "exit_bfqq: %p, %d", bfqq, atomic_read(&bfqq->=
ref));
>  =20
>   	bfq_put_cooperator(bfqq);
>  =20
> @@ -5507,7 +5508,7 @@ static void bfq_init_bfqq(struct bfq_data *bfqd, st=
ruct bfq_queue *bfqq,
>   	INIT_HLIST_NODE(&bfqq->woken_list_node);
>   	INIT_HLIST_HEAD(&bfqq->woken_list);
>  =20
> -	bfqq->ref =3D 0;
> +	atomic_set(&bfqq->ref, 0);
>   	bfqq->bfqd =3D bfqd;
>  =20
>   	if (bic)
> @@ -5710,12 +5711,12 @@ static struct bfq_queue *bfq_do_or_sched_stable_m=
erge(struct bfq_data *bfqd,
>   			 * to prevent it from being freed,
>   			 * until we decide whether to merge
>   			 */
> -			last_bfqq_created->ref++;
> +			atomic_inc(&last_bfqq_created->ref);
>   			/*
>   			 * need to keep track of stable refs, to
>   			 * compute process refs correctly
>   			 */
> -			last_bfqq_created->stable_ref++;
> +			atomic_inc(&last_bfqq_created->stable_ref);
>   			/*
>   			 * Record the bfqq to merge to.
>   			 */
> @@ -5767,20 +5768,21 @@ static struct bfq_queue *bfq_get_queue(struct bfq=
_data *bfqd,
>   	 * prune it.
>   	 */
>   	if (async_bfqq) {
> -		bfqq->ref++; /*
> -			      * Extra group reference, w.r.t. sync
> -			      * queue. This extra reference is removed
> -			      * only if bfqq->bfqg disappears, to
> -			      * guarantee that this queue is not freed
> -			      * until its group goes away.
> -			      */
> +		atomic_inc(&bfqq->ref);
> +		/*
> +		 * Extra group reference, w.r.t. sync
> +		 * queue. This extra reference is removed
> +		 * only if bfqq->bfqg disappears, to
> +		 * guarantee that this queue is not freed
> +		 * until its group goes away.
> +		 */
>   		bfq_log_bfqq(bfqd, bfqq, "get_queue, bfqq not in async: %p, %d",
> -			     bfqq, bfqq->ref);
> +			     bfqq, atomic_read(&bfqq->ref));
>   		*async_bfqq =3D bfqq;
>   	}
>  =20
>   out:
> -	bfqq->ref++; /* get a process reference to this queue */
> +	atomic_inc(&bfqq->ref); /* get a process reference to this queue */
>  =20
>   	if (bfqq !=3D &bfqd->oom_bfqq && is_sync && !respawn)
>   		bfqq =3D bfq_do_or_sched_stable_merge(bfqd, bfqq, bic);
> @@ -6059,7 +6061,7 @@ static bool __bfq_insert_request(struct bfq_data *b=
fqd, struct request *rq)
>   		 */
>   		bfqq_request_allocated(new_bfqq);
>   		bfqq_request_freed(bfqq);
> -		new_bfqq->ref++;
> +		atomic_inc(&new_bfqq->ref);
>   		/*
>   		 * If the bic associated with the process
>   		 * issuing this request still points to bfqq
> @@ -6803,10 +6805,10 @@ static struct bfq_queue *bfq_init_rq(struct reque=
st *rq)
>   	}
>  =20
>   	bfqq_request_allocated(bfqq);
> -	bfqq->ref++;
> +	atomic_inc(&bfqq->ref);
>   	bic->requests++;
>   	bfq_log_bfqq(bfqd, bfqq, "get_request %p: bfqq %p, %d",
> -		     rq, bfqq, bfqq->ref);
> +		     rq, bfqq, atomic_read(&bfqq->ref));
>  =20
>   	rq->elv.priv[0] =3D bic;
>   	rq->elv.priv[1] =3D bfqq;
> @@ -6939,7 +6941,7 @@ static void __bfq_put_async_bfqq(struct bfq_data *b=
fqd,
>   		bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
>  =20
>   		bfq_log_bfqq(bfqd, bfqq, "put_async_bfqq: putting %p, %d",
> -			     bfqq, bfqq->ref);
> +			     bfqq, atomic_read(&bfqq->ref));
>   		bfq_put_queue(bfqq);
>   		*bfqq_ptr =3D NULL;
>   	}
> @@ -7092,7 +7094,7 @@ static int bfq_init_queue(struct request_queue *q, =
struct elevator_type *e)
>   	 * will not attempt to free it.
>   	 */
>   	bfq_init_bfqq(bfqd, &bfqd->oom_bfqq, NULL, 1, 0);
> -	bfqd->oom_bfqq.ref++;
> +	atomic_inc(&bfqd->oom_bfqq.ref);
>   	bfqd->oom_bfqq.new_ioprio =3D BFQ_DEFAULT_QUEUE_IOPRIO;
>   	bfqd->oom_bfqq.new_ioprio_class =3D IOPRIO_CLASS_BE;
>   	bfqd->oom_bfqq.entity.new_weight =3D
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 64ee618064ba..71ac0de80bb0 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -234,9 +234,9 @@ struct bfq_ttime {
>    */
>   struct bfq_queue {
>   	/* reference counter */
> -	int ref;
> +	atomic_t ref;
>   	/* counter of references from other queues for delayed stable merge */
> -	int stable_ref;
> +	atomic_t stable_ref;
>   	/* parent bfq_data */
>   	struct bfq_data *bfqd;
>  =20
> @@ -928,7 +928,7 @@ struct bfq_group {
>   	char blkg_path[128];
>  =20
>   	/* reference counter (see comments in bfq_bic_update_cgroup) */
> -	int ref;
> +	atomic_t ref;
>   	/* Is bfq_group still online? */
>   	bool online;
>  =20
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index 8fc3da4c23bb..60a9a2c1fc8d 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -512,9 +512,9 @@ static void bfq_get_entity(struct bfq_entity *entity)
>   	struct bfq_queue *bfqq =3D bfq_entity_to_bfqq(entity);
>  =20
>   	if (bfqq) {
> -		bfqq->ref++;
> +		atomic_inc(&bfqq->ref);
>   		bfq_log_bfqq(bfqq->bfqd, bfqq, "get_entity: %p %d",
> -			     bfqq, bfqq->ref);
> +			     bfqq, atomic_read(&bfqq->ref));
>   	}
>   }
>  =20
> @@ -1611,7 +1611,7 @@ bool __bfq_bfqd_reset_in_service(struct bfq_data *b=
fqd)
>   		 * reference to the queue. If this is the case, then
>   		 * bfqq gets freed here.
>   		 */
> -		int ref =3D in_serv_bfqq->ref;
> +		int ref =3D atomic_read(&in_serv_bfqq->ref);
>   		bfq_put_queue(in_serv_bfqq);
>   		if (ref =3D=3D 1)
>   			return true;
>=20

