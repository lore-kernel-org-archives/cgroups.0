From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [patch v11 5/6] block, bfq: cleanup bfq_weights_tree add/remove
 apis
Date: Tue, 27 Sep 2022 18:19:18 +0200
Message-ID: <6E987AC9-9EBD-4172-A440-2FC13BA9AFD1@linaro.org>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
 <20220916071942.214222-6-yukuai1@huaweicloud.com>
 <20220919084633.nmzastqkjool5jnc@quack3>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=wtuYP/U8JcCds+Y8vgYt3RNPN+IvgKtQC+pNVMQXjHw=;
        b=VPLGTAFsQ9vqWDNFPxTFeBhouiEHc5CpVWDjOnwMbJMnR2o39RyG6YtrR3o28npFwP
         RvPNVrmMcTHfxXqqprE1I5VtYa7YQ60pF98aTQ8Tb1SpBkupjZZ3QaLsxKYxN/WKSVCj
         07MJxNSBzx+dfnRsdbHVHytZBHXt3PW0m9HY68qnzjB3XE88/WUY7A5Cm2UaC45QUkq0
         bxmwyOugjFh4VMs0Pm9Fd3npFFxpLLX9ipH7sCscaAPU/MUnbSrbBpX4xo0ZwCo89NNN
         HYrWeJGzdTh3nQOQUfJhcISoeetoY9O8jd7mn23F7GWhydPmwRhsEH7Sv81uCEYHJA4V
         UG4w==
In-Reply-To: <20220919084633.nmzastqkjool5jnc@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack@suse.cz>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com



> Il giorno 19 set 2022, alle ore 10:46, Jan Kara <jack@suse.cz> ha =
scritto:
>=20
> On Fri 16-09-22 15:19:41, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>=20
>> The 'bfq_data' and 'rb_root_cached' can both be accessed through
>> 'bfq_queue', thus only pass 'bfq_queue' as parameter.
>>=20
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>=20

Thanks for keeping improving BFQ's code.

Acked-by: Paolo Valente <paolo.valente@linaro.org>

> Looks good. Feel free to add:
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
>=20
> 								Honza
>> ---
>> block/bfq-iosched.c | 19 +++++++++----------
>> block/bfq-iosched.h | 10 +++-------
>> block/bfq-wf2q.c    | 18 ++++++------------
>> 3 files changed, 18 insertions(+), 29 deletions(-)
>>=20
>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>> index 6d95b0e488a8..4ad4fa0dad4a 100644
>> --- a/block/bfq-iosched.c
>> +++ b/block/bfq-iosched.c
>> @@ -870,9 +870,9 @@ static bool bfq_asymmetric_scenario(struct =
bfq_data *bfqd,
>>  * In most scenarios, the rate at which nodes are created/destroyed
>>  * should be low too.
>>  */
>> -void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue =
*bfqq,
>> -			  struct rb_root_cached *root)
>> +void bfq_weights_tree_add(struct bfq_queue *bfqq)
>> {
>> +	struct rb_root_cached *root =3D &bfqq->bfqd->queue_weights_tree;
>> 	struct bfq_entity *entity =3D &bfqq->entity;
>> 	struct rb_node **new =3D &(root->rb_root.rb_node), *parent =3D =
NULL;
>> 	bool leftmost =3D true;
>> @@ -944,13 +944,14 @@ void bfq_weights_tree_add(struct bfq_data =
*bfqd, struct bfq_queue *bfqq,
>>  * See the comments to the function bfq_weights_tree_add() for =
considerations
>>  * about overhead.
>>  */
>> -void __bfq_weights_tree_remove(struct bfq_data *bfqd,
>> -			       struct bfq_queue *bfqq,
>> -			       struct rb_root_cached *root)
>> +void __bfq_weights_tree_remove(struct bfq_queue *bfqq)
>> {
>> +	struct rb_root_cached *root;
>> +
>> 	if (!bfqq->weight_counter)
>> 		return;
>>=20
>> +	root =3D &bfqq->bfqd->queue_weights_tree;
>> 	bfqq->weight_counter->num_active--;
>> 	if (bfqq->weight_counter->num_active > 0)
>> 		goto reset_entity_pointer;
>> @@ -967,11 +968,9 @@ void __bfq_weights_tree_remove(struct bfq_data =
*bfqd,
>>  * Invoke __bfq_weights_tree_remove on bfqq and decrement the number
>>  * of active groups for each queue's inactive parent entity.
>>  */
>> -void bfq_weights_tree_remove(struct bfq_data *bfqd,
>> -			     struct bfq_queue *bfqq)
>> +void bfq_weights_tree_remove(struct bfq_queue *bfqq)
>> {
>> -	__bfq_weights_tree_remove(bfqd, bfqq,
>> -				  &bfqd->queue_weights_tree);
>> +	__bfq_weights_tree_remove(bfqq);
>> }
>>=20
>> /*
>> @@ -6220,7 +6219,7 @@ static void bfq_completed_request(struct =
bfq_queue *bfqq, struct bfq_data *bfqd)
>> 		bfqq->budget_timeout =3D jiffies;
>>=20
>> 		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
>> -		bfq_weights_tree_remove(bfqd, bfqq);
>> +		bfq_weights_tree_remove(bfqq);
>> 	}
>>=20
>> 	now_ns =3D ktime_get_ns();
>> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
>> index 257acb54c6dc..4bb58ab0c90a 100644
>> --- a/block/bfq-iosched.h
>> +++ b/block/bfq-iosched.h
>> @@ -973,13 +973,9 @@ struct bfq_queue *bic_to_bfqq(struct bfq_io_cq =
*bic, bool is_sync);
>> void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool =
is_sync);
>> struct bfq_data *bic_to_bfqd(struct bfq_io_cq *bic);
>> void bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue =
*bfqq);
>> -void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue =
*bfqq,
>> -			  struct rb_root_cached *root);
>> -void __bfq_weights_tree_remove(struct bfq_data *bfqd,
>> -			       struct bfq_queue *bfqq,
>> -			       struct rb_root_cached *root);
>> -void bfq_weights_tree_remove(struct bfq_data *bfqd,
>> -			     struct bfq_queue *bfqq);
>> +void bfq_weights_tree_add(struct bfq_queue *bfqq);
>> +void __bfq_weights_tree_remove(struct bfq_queue *bfqq);
>> +void bfq_weights_tree_remove(struct bfq_queue *bfqq);
>> void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>> 		     bool compensate, enum bfqq_expiration reason);
>> void bfq_put_queue(struct bfq_queue *bfqq);
>> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
>> index 5e8224c96921..124aaea6196e 100644
>> --- a/block/bfq-wf2q.c
>> +++ b/block/bfq-wf2q.c
>> @@ -707,7 +707,6 @@ __bfq_entity_update_weight_prio(struct =
bfq_service_tree *old_st,
>> 		struct bfq_queue *bfqq =3D bfq_entity_to_bfqq(entity);
>> 		unsigned int prev_weight, new_weight;
>> 		struct bfq_data *bfqd =3D NULL;
>> -		struct rb_root_cached *root;
>> #ifdef CONFIG_BFQ_GROUP_IOSCHED
>> 		struct bfq_sched_data *sd;
>> 		struct bfq_group *bfqg;
>> @@ -770,19 +769,15 @@ __bfq_entity_update_weight_prio(struct =
bfq_service_tree *old_st,
>> 		 * queue, remove the entity from its old weight counter =
(if
>> 		 * there is a counter associated with the entity).
>> 		 */
>> -		if (prev_weight !=3D new_weight && bfqq) {
>> -			root =3D &bfqd->queue_weights_tree;
>> -			__bfq_weights_tree_remove(bfqd, bfqq, root);
>> -		}
>> +		if (prev_weight !=3D new_weight && bfqq)
>> +			__bfq_weights_tree_remove(bfqq);
>> 		entity->weight =3D new_weight;
>> 		/*
>> 		 * Add the entity, if it is not a weight-raised queue,
>> 		 * to the counter associated with its new weight.
>> 		 */
>> -		if (prev_weight !=3D new_weight && bfqq && =
bfqq->wr_coeff =3D=3D 1) {
>> -			/* If we get here, root has been initialized. */
>> -			bfq_weights_tree_add(bfqd, bfqq, root);
>> -		}
>> +		if (prev_weight !=3D new_weight && bfqq && =
bfqq->wr_coeff =3D=3D 1)
>> +			bfq_weights_tree_add(bfqq);
>>=20
>> 		new_st->wsum +=3D entity->weight;
>>=20
>> @@ -1687,7 +1682,7 @@ void bfq_del_bfqq_busy(struct bfq_queue *bfqq, =
bool expiration)
>> 		 * Next function is invoked last, because it causes bfqq =
to be
>> 		 * freed. DO NOT use bfqq after the next function =
invocation.
>> 		 */
>> -		bfq_weights_tree_remove(bfqd, bfqq);
>> +		bfq_weights_tree_remove(bfqq);
>> 	}
>> }
>>=20
>> @@ -1708,8 +1703,7 @@ void bfq_add_bfqq_busy(struct bfq_queue *bfqq)
>> 	if (!bfqq->dispatched) {
>> 		bfq_add_bfqq_in_groups_with_pending_reqs(bfqq);
>> 		if (bfqq->wr_coeff =3D=3D 1)
>> -			bfq_weights_tree_add(bfqd, bfqq,
>> -					     &bfqd->queue_weights_tree);
>> +			bfq_weights_tree_add(bfqq);
>> 	}
>>=20
>> 	if (bfqq->wr_coeff > 1)
>> --=20
>> 2.31.1
>>=20
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

