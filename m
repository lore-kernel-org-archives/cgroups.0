From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v8 2/4] block, bfq: record how many queues have
 pending requests
Date: Wed, 1 Jun 2022 18:58:00 +0800
Message-ID: <3ab7ab6e-474d-d5d7-a1c0-f75b3b092bbe@huawei.com>
References: <20220531140858.3324294-1-yukuai3@huawei.com>
 <20220531140858.3324294-3-yukuai3@huawei.com>
 <20220601083529.oz26s6jefxz6fnyg@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220601083529.oz26s6jefxz6fnyg-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/06/01 16:35, Jan Kara =D0=B4=B5=C0:
> On Tue 31-05-22 22:08:56, Yu Kuai wrote:
>> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
>>
>> Add a counter in bfq_group, and update it while tracking if bfqq have
>> pending requests.
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Looks good, except I think that we also need to update the counters
> 'num_groups_with_pending_reqs' in bfq_move_bfqq()?
Yes, you're right. I'll do that in next version.

Thanks,
Kuai
>=20
> 								Honza
>=20
>> ---
>>   block/bfq-cgroup.c  |  1 +
>>   block/bfq-iosched.h |  1 +
>>   block/bfq-wf2q.c    | 12 ++++++++++--
>>   3 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index 09574af83566..0954a258a107 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
>>   				   */
>>   	bfqg->bfqd =3D bfqd;
>>   	bfqg->active_entities =3D 0;
>> +	bfqg->num_queues_with_pending_reqs =3D 0;
>>   	bfqg->online =3D true;
>>   	bfqg->rq_pos_tree =3D RB_ROOT;
>>   }
>> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
>> index 3b9b1a0e7c1c..a5f7c0c1a3b3 100644
>> --- a/block/bfq-iosched.h
>> +++ b/block/bfq-iosched.h
>> @@ -943,6 +943,7 @@ struct bfq_group {
>>   	struct bfq_entity *my_entity;
>>  =20
>>   	int active_entities;
>> +	int num_queues_with_pending_reqs;
>>  =20
>>   	struct rb_root rq_pos_tree;
>>  =20
>> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
>> index 12d20f26ad69..b533e17e9f0c 100644
>> --- a/block/bfq-wf2q.c
>> +++ b/block/bfq-wf2q.c
>> @@ -1651,16 +1651,24 @@ static void bfq_add_bfqq_in_groups_with_pending_=
reqs(struct bfq_queue *bfqq)
>>   {
>>   	struct bfq_entity *entity =3D &bfqq->entity;
>>  =20
>> -	if (!entity->in_groups_with_pending_reqs)
>> +	if (!entity->in_groups_with_pending_reqs) {
>>   		entity->in_groups_with_pending_reqs =3D true;
>> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
>> +		bfqq_group(bfqq)->num_queues_with_pending_reqs++;
>> +#endif
>> +	}
>>   }
>>  =20
>>   void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
>>   {
>>   	struct bfq_entity *entity =3D &bfqq->entity;
>>  =20
>> -	if (entity->in_groups_with_pending_reqs)
>> +	if (entity->in_groups_with_pending_reqs) {
>>   		entity->in_groups_with_pending_reqs =3D false;
>> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
>> +		bfqq_group(bfqq)->num_queues_with_pending_reqs--;
>> +#endif
>> +	}
>>   }
>>  =20
>>   /*
>> --=20
>> 2.31.1
>>
