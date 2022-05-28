From: Yu Kuai <yukuai3@huawei.com>
Subject: Re: [PATCH -next v6 2/3] block, bfq: refactor the counting of
 'num_groups_with_pending_reqs'
Date: Sat, 28 May 2022 16:39:17 +0800
Message-ID: <159f8c28-db93-6289-3df2-f88e8fbb3d32@huawei.com>
References: <20220523131818.2798712-1-yukuai3@huawei.com>
 <20220523131818.2798712-3-yukuai3@huawei.com>
 <CB855885-1E3B-486A-875F-D25F9C1DD0D0@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CB855885-1E3B-486A-875F-D25F9C1DD0D0@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/05/28 16:27, Paolo Valente =D0=B4=B5=C0:
>=20
>=20
>> Il giorno 23 mag 2022, alle ore 15:18, Yu Kuai <yukuai3@huawei.com> ha s=
critto:
>>
>> Currently, bfq can't handle sync io concurrently as long as they
>> are not issued from root group. This is because
>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>> bfq_asymmetric_scenario().
>>
>> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>>
>> Before this patch:
>> 1) root group will never be counted.
>> 2) Count if bfqg or it's child bfqgs have pending requests.
>> 3) Don't count if bfqg and it's child bfqgs complete all the requests.
>>
>> After this patch:
>> 1) root group is counted.
>> 2) Count if bfqg have at least one bfqq that is marked busy.
>> 3) Don't count if bfqg doesn't have any busy bfqqs.
>>
>> The main reason to use busy state of bfqq instead of 'pending requests'
>> is that bfqq can stay busy after dispatching the last request if idling
>> is needed for service guarantees.
>>
>> With this change, the occasion that only one group is activated can be
>> detected, and next patch will support concurrent sync io in the
>> occasion.
>>
>> This patch also rename 'num_groups_with_pending_reqs' to
>> 'num_groups_with_busy_queues'.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> ---
>> block/bfq-iosched.c | 46 ++-----------------------------------
>> block/bfq-iosched.h | 55 ++++++---------------------------------------
>> block/bfq-wf2q.c    | 19 ++++------------
>> 3 files changed, 13 insertions(+), 107 deletions(-)
>>
>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>> index e47c75f1fa0f..609b4e894684 100644
>> --- a/block/bfq-iosched.c
>> +++ b/block/bfq-iosched.c
>> @@ -844,7 +844,7 @@ static bool bfq_asymmetric_scenario(struct bfq_data =
*bfqd,
>>
>> 	return varied_queue_weights || multiple_classes_busy
>> #ifdef CONFIG_BFQ_GROUP_IOSCHED
>> -	       || bfqd->num_groups_with_pending_reqs > 0
>> +	       || bfqd->num_groups_with_busy_queues > 0
>> #endif
>> 		;
>> }
>> @@ -962,48 +962,6 @@ void __bfq_weights_tree_remove(struct bfq_data *bfq=
d,
>> void bfq_weights_tree_remove(struct bfq_data *bfqd,
>> 			     struct bfq_queue *bfqq)
>> {
>> -	struct bfq_entity *entity =3D bfqq->entity.parent;
>> -
>> -	for_each_entity(entity) {
>> -		struct bfq_sched_data *sd =3D entity->my_sched_data;
>> -
>> -		if (sd->next_in_service || sd->in_service_entity) {
>> -			/*
>> -			 * entity is still active, because either
>> -			 * next_in_service or in_service_entity is not
>> -			 * NULL (see the comments on the definition of
>> -			 * next_in_service for details on why
>> -			 * in_service_entity must be checked too).
>> -			 *
>> -			 * As a consequence, its parent entities are
>> -			 * active as well, and thus this loop must
>> -			 * stop here.
>> -			 */
>> -			break;
>> -		}
>> -
>> -		/*
>> -		 * The decrement of num_groups_with_pending_reqs is
>> -		 * not performed immediately upon the deactivation of
>> -		 * entity, but it is delayed to when it also happens
>> -		 * that the first leaf descendant bfqq of entity gets
>> -		 * all its pending requests completed. The following
>> -		 * instructions perform this delayed decrement, if
>> -		 * needed. See the comments on
>> -		 * num_groups_with_pending_reqs for details.
>> -		 */
>> -		if (entity->in_groups_with_pending_reqs) {
>> -			entity->in_groups_with_pending_reqs =3D false;
>> -			bfqd->num_groups_with_pending_reqs--;
>> -		}
>> -	}
>> -
>> -	/*
>> -	 * Next function is invoked last, because it causes bfqq to be
>> -	 * freed if the following holds: bfqq is not in service and
>> -	 * has no dispatched request. DO NOT use bfqq after the next
>> -	 * function invocation.
>> -	 */
>> 	__bfq_weights_tree_remove(bfqd, bfqq,
>> 				  &bfqd->queue_weights_tree);
>> }
>> @@ -7107,7 +7065,7 @@ static int bfq_init_queue(struct request_queue *q,=
 struct elevator_type *e)
>> 	bfqd->idle_slice_timer.function =3D bfq_idle_slice_timer;
>>
>> 	bfqd->queue_weights_tree =3D RB_ROOT_CACHED;
>> -	bfqd->num_groups_with_pending_reqs =3D 0;
>> +	bfqd->num_groups_with_busy_queues =3D 0;
>>
>> 	INIT_LIST_HEAD(&bfqd->active_list);
>> 	INIT_LIST_HEAD(&bfqd->idle_list);
>> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
>> index 3847f4ab77ac..b71a088a7f1d 100644
>> --- a/block/bfq-iosched.h
>> +++ b/block/bfq-iosched.h
>> @@ -197,9 +197,6 @@ struct bfq_entity {
>> 	/* flag, set to request a weight, ioprio or ioprio_class change  */
>> 	int prio_changed;
>>
>> -	/* flag, set if the entity is counted in groups_with_pending_reqs */
>> -	bool in_groups_with_pending_reqs;
>> -
>> 	/* last child queue of entity created (for non-leaf entities) */
>> 	struct bfq_queue *last_bfqq_created;
>> };
>> @@ -495,52 +492,14 @@ struct bfq_data {
>> 	struct rb_root_cached queue_weights_tree;
>>
>> 	/*
>> -	 * Number of groups with at least one descendant process that
>> -	 * has at least one request waiting for completion. Note that
>> -	 * this accounts for also requests already dispatched, but not
>> -	 * yet completed. Therefore this number of groups may differ
>> -	 * (be larger) than the number of active groups, as a group is
>> -	 * considered active only if its corresponding entity has
>> -	 * descendant queues with at least one request queued. This
>> -	 * number is used to decide whether a scenario is symmetric.
>> -	 * For a detailed explanation see comments on the computation
>> -	 * of the variable asymmetric_scenario in the function
>> -	 * bfq_better_to_idle().
>> -	 *
>> -	 * However, it is hard to compute this number exactly, for
>> -	 * groups with multiple descendant processes. Consider a group
>> -	 * that is inactive, i.e., that has no descendant process with
>> -	 * pending I/O inside BFQ queues. Then suppose that
>> -	 * num_groups_with_pending_reqs is still accounting for this
>> -	 * group, because the group has descendant processes with some
>> -	 * I/O request still in flight. num_groups_with_pending_reqs
>> -	 * should be decremented when the in-flight request of the
>> -	 * last descendant process is finally completed (assuming that
>> -	 * nothing else has changed for the group in the meantime, in
>> -	 * terms of composition of the group and active/inactive state of child
>> -	 * groups and processes). To accomplish this, an additional
>> -	 * pending-request counter must be added to entities, and must
>> -	 * be updated correctly. To avoid this additional field and operations,
>> -	 * we resort to the following tradeoff between simplicity and
>> -	 * accuracy: for an inactive group that is still counted in
>> -	 * num_groups_with_pending_reqs, we decrement
>> -	 * num_groups_with_pending_reqs when the first descendant
>> -	 * process of the group remains with no request waiting for
>> -	 * completion.
>> -	 *
>> -	 * Even this simpler decrement strategy requires a little
>> -	 * carefulness: to avoid multiple decrements, we flag a group,
>> -	 * more precisely an entity representing a group, as still
>> -	 * counted in num_groups_with_pending_reqs when it becomes
>> -	 * inactive. Then, when the first descendant queue of the
>> -	 * entity remains with no request waiting for completion,
>> -	 * num_groups_with_pending_reqs is decremented, and this flag
>> -	 * is reset. After this flag is reset for the entity,
>> -	 * num_groups_with_pending_reqs won't be decremented any
>> -	 * longer in case a new descendant queue of the entity remains
>> -	 * with no request waiting for completion.
>> +	 * Number of groups with at least one bfqq that is marked busy,
>> +	 * and this number is used to decide whether a scenario is symmetric.
>> +	 * Note that bfqq is busy doesn't mean that the bfqq contains requests.
>> +	 * If idling is needed for service guarantees, bfqq will stay busy
>> +	 * after dispatching the last request, see details in
>> +	 * __bfq_bfqq_expire().
>> 	 */
>> -	unsigned int num_groups_with_pending_reqs;
>> +	unsigned int num_groups_with_busy_queues;
>>
>> 	/*
>> 	 * Per-class (RT, BE, IDLE) number of bfq_queues containing
>> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
>> index d9ff33e0be38..42464e6ff40c 100644
>> --- a/block/bfq-wf2q.c
>> +++ b/block/bfq-wf2q.c
>> @@ -220,12 +220,14 @@ static bool bfq_no_longer_next_in_service(struct b=
fq_entity *entity)
>>
>> static void bfq_inc_busy_queues(struct bfq_queue *bfqq)
>> {
>> -	bfqq_group(bfqq)->busy_queues++;
>> +	if (!(bfqq_group(bfqq)->busy_queues++))
>> +		bfqq->bfqd->num_groups_with_busy_queues++;
>> }
>>
>> static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
>> {
>> -	bfqq_group(bfqq)->busy_queues--;
>> +	if (!(--bfqq_group(bfqq)->busy_queues))
>=20
> Are you sure this is correct?  You want to decrement
> num_groups_with_busy_queues if busy_queues switches from 1 to 0.  But
> if busy_queues =3D=3D 1, then !(busy_queues) is false.

Hi, Paolo

I'm sure this is correct.

if busy_queues =3D=3D 1, then !(--busy_queues) is true; while
!(busy_queues--) is false.

Thanks,
Kuai
>=20
> Paolo
>=20
>> +		bfqq->bfqd->num_groups_with_busy_queues--;
>> }
>>
>> #else /* CONFIG_BFQ_GROUP_IOSCHED */
>> @@ -1002,19 +1004,6 @@ static void __bfq_activate_entity(struct bfq_enti=
ty *entity,
>> 		entity->on_st_or_in_serv =3D true;
>> 	}
>>
>> -#ifdef CONFIG_BFQ_GROUP_IOSCHED
>> -	if (!bfq_entity_to_bfqq(entity)) { /* bfq_group */
>> -		struct bfq_group *bfqg =3D
>> -			container_of(entity, struct bfq_group, entity);
>> -		struct bfq_data *bfqd =3D bfqg->bfqd;
>> -
>> -		if (!entity->in_groups_with_pending_reqs) {
>> -			entity->in_groups_with_pending_reqs =3D true;
>> -			bfqd->num_groups_with_pending_reqs++;
>> -		}
>> -	}
>> -#endif
>> -
>> 	bfq_update_fin_time_enqueue(entity, st, backshifted);
>> }
>>
>> --=20
>> 2.31.1
>>
>=20
> .
>=20
