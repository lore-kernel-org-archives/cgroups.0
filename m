From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v2 3/3] blk-cgroup: synchronize pd_free_fn() from
 blkg_free_workfn() and blkcg_deactivate_policy()
Date: Thu, 19 Jan 2023 11:23:05 +0800
Message-ID: <9a9b6f38-9d1b-b007-96d7-2cda433763f4@huaweicloud.com>
References: <20230118123152.1926314-1-yukuai1@huaweicloud.com>
 <20230118123152.1926314-4-yukuai1@huaweicloud.com>
 <Y8gm0BVh5d83lVXN@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Y8gm0BVh5d83lVXN@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2023/01/19 1:05, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Wed, Jan 18, 2023 at 08:31:52PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently parent pd can be freed before child pd:
>>
>> t1: remove cgroup C1
>> blkcg_destroy_blkgs
>>   blkg_destroy
>>    list_del_init(&blkg->q_node)
>>    // remove blkg from queue list
>>    percpu_ref_kill(&blkg->refcnt)
>>     blkg_release
>>      call_rcu
>>
>> t2: from t1
>> __blkg_release
>>   blkg_free
>>    schedule_work
>> 			t4: deactivate policy
>> 			blkcg_deactivate_policy
>> 			 pd_free_fn
>> 			 // parent of C1 is freed first
>> t3: from t2
>>   blkg_free_workfn
>>    pd_free_fn
>>
>> If policy(for example, ioc_timer_fn() from iocost) access parent pd from
>> child pd after pd_offline_fn(), then UAF can be triggered.
>>
>> Fix the problem by delaying 'list_del_init(&blkg->q_node)' from
>> blkg_destroy() to blkg_free_workfn(), and use a new disk level mutex to
>                                              ^
>                                              using
>=20
>> protect blkg_free_workfn() and blkcg_deactivate_policy).
>    ^                                                     ^
>    synchronize?                                          ()
>=20
>> @@ -118,16 +118,26 @@ static void blkg_free_workfn(struct work_struct *w=
ork)
>>   {
>>   	struct blkcg_gq *blkg =3D container_of(work, struct blkcg_gq,
>>   					     free_work);
>> +	struct request_queue *q =3D blkg->q;
>>   	int i;
>>  =20
>> +	if (q)
>> +		mutex_lock(&q->blkcg_mutex);
>=20
> A comment explaining what the above is synchronizing would be useful.
>=20
>> +
>>   	for (i =3D 0; i < BLKCG_MAX_POLS; i++)
>>   		if (blkg->pd[i])
>>   			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
>>  =20
>>   	if (blkg->parent)
>>   		blkg_put(blkg->parent);
>> -	if (blkg->q)
>> -		blk_put_queue(blkg->q);
>> +
>> +	if (q) {
>> +		if (!list_empty(&blkg->q_node))
>=20
> We can drop the above if.
>=20
>> +			list_del_init(&blkg->q_node);
>> +		mutex_unlock(&q->blkcg_mutex);
>> +		blk_put_queue(q);
>> +	}
>> +
>>   	free_percpu(blkg->iostat_cpu);
>>   	percpu_ref_exit(&blkg->refcnt);
>>   	kfree(blkg);
>> @@ -462,9 +472,14 @@ static void blkg_destroy(struct blkcg_gq *blkg)
>>   	lockdep_assert_held(&blkg->q->queue_lock);
>>   	lockdep_assert_held(&blkcg->lock);
>>  =20
>> -	/* Something wrong if we are trying to remove same group twice */
>> -	WARN_ON_ONCE(list_empty(&blkg->q_node));
>> -	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
>> +	/*
>> +	 * blkg is removed from queue list in blkg_free_workfn(), hence this
>> +	 * function can be called from blkcg_destroy_blkgs() first, and then
>> +	 * before blkg_free_workfn(), this function can be called again in
>> +	 * blkg_destroy_all().
>=20
> How about?
>=20
> 	 * blkg stays on the queue list until blkg_free_workfn(), hence this
> 	 * function can be called from blkcg_destroy_blkgs() first and again
> 	 * from blkg_destroy_all() before blkg_free_workfn().
>=20
>> +	 */
>> +	if (hlist_unhashed(&blkg->blkcg_node))
>> +		return;
>>  =20
>>   	for (i =3D 0; i < BLKCG_MAX_POLS; i++) {
>>   		struct blkcg_policy *pol =3D blkcg_policy[i];
>> @@ -478,8 +493,11 @@ static void blkg_destroy(struct blkcg_gq *blkg)
>>  =20
>>   	blkg->online =3D false;
>>  =20
>> +	/*
>> +	 * Delay deleting list blkg->q_node to blkg_free_workfn() to synchroni=
ze
>> +	 * pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy().
>> +	 */
>=20
> So, it'd be better to add a more comprehensive comment in blkg_free_workf=
n()
> explaining why we need this synchronization and how it works and then poi=
nt
> to it from here.
>=20
> Other than comments, it looks great to me. Thanks a lot for your patience
> and seeing it through.
Thanks for the suggestions, I'll send a new patch based on your
suggestions.

Kuai
>=20

