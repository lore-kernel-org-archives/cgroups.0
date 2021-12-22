From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] block, bfq: update pos_root for idle bfq_queue in
 bfq_bfqq_move()
Date: Wed, 22 Dec 2021 11:12:45 +0800
Message-ID: <6ca1e924-47fa-b94e-598c-69a9549eb68e@huawei.com>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-5-yukuai3@huawei.com>
 <20211221115001.GD24748@quack2.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211221115001.GD24748-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2021/12/21 19:50, Jan Kara =D0=B4=B5=C0:
> On Tue 21-12-21 11:21:35, Yu Kuai wrote:
>> During code review, we found that if bfqq is not busy in
>> bfq_bfqq_move(), bfq_pos_tree_add_move() won't be called for the bfqq,
>> thus bfqq->pos_root still points to the old bfqg. However, the ref
>> that bfqq hold for the old bfqg will be released, so it's possible
>> that the old bfqg can be freed. This is problematic because the freed
>> bfqg can still be accessed by bfqq->pos_root.
>>
>> Fix the problem by calling bfq_pos_tree_add_move() for idle bfqq
>> as well.
>>
>> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and c=
groups support")
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> I'm just wondering, how can it happen that !bfq_bfqq_busy() queue is in
> pos_tree? Because bfq_remove_request() takes care to remove bfqq from the
> pos_tree...

Hi,

It's right this is not a problem in common case. The problem seems to
relate to queue merging and task migration. Because I once reporduced
it with the same reporducer for the problem that offlined bfqg can be
inserted into service tree. The uaf is exactly in
bfq_remove_request->rb_rease(). However I didn't save the stack...

I guess this is because bfq_del_bfqq_busy() is called from
bfq_release_process_ref(), and queue merging prevert sunch bfqq to be
freed, thus such bfqq is not in service tree, and it's pos_root can
point to the old bfqg after bfq_bic_update_cgroup->bfq_bfqq_move.

I haven't confirmed this, however, this patch itself only cleared
bfqq->pos_root for idle bfqq, there should be no harm.

Thanks,
Kuai
>=20
> 								Honza
>=20
>> ---
>>   block/bfq-cgroup.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index 8e8cf6b3d946..822dd28ecf53 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -677,7 +677,6 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq=
_queue *bfqq,
>>   		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
>>   	else if (entity->on_st_or_in_serv)
>>   		bfq_put_idle_entity(bfq_entity_service_tree(entity), entity);
>> -	bfqg_and_blkg_put(old_parent);
>>  =20
>>   	if (entity->parent &&
>>   	    entity->parent->last_bfqq_created =3D=3D bfqq)
>> @@ -690,11 +689,16 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct b=
fq_queue *bfqq,
>>   	/* pin down bfqg and its associated blkg  */
>>   	bfqg_and_blkg_get(bfqg);
>>  =20
>> -	if (bfq_bfqq_busy(bfqq)) {
>> -		if (unlikely(!bfqd->nonrot_with_queueing))
>> -			bfq_pos_tree_add_move(bfqd, bfqq);
>> +	/*
>> +	 * Don't leave the pos_root to old bfqg, since the ref to old bfqg will
>> +	 * be released and the bfqg might be freed.
>> +	 */
>> +	if (unlikely(!bfqd->nonrot_with_queueing))
>> +		bfq_pos_tree_add_move(bfqd, bfqq);
>> +	bfqg_and_blkg_put(old_parent);
>> +
>> +	if (bfq_bfqq_busy(bfqq))
>>   		bfq_activate_bfqq(bfqd, bfqq);
>> -	}
>>  =20
>>   	if (!bfqd->in_service_queue && !bfqd->rq_in_driver)
>>   		bfq_schedule_dispatch(bfqd);
>> --=20
>> 2.31.1
>>
