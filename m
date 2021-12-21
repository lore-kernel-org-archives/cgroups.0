From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 2/4] block, bfq: avoid moving bfqq to it's parent bfqg
Date: Tue, 21 Dec 2021 19:08:44 +0800
Message-ID: <d1c91a5f-33f3-ffad-e1ad-fb91482eb864@huawei.com>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-3-yukuai3@huawei.com>
 <20211221101659.GB24748@quack2.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211221101659.GB24748@quack2.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, fchecconi@gmail.com, avanzini.arianna@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2021/12/21 18:16, Jan Kara =D0=B4=B5=C0:
> On Tue 21-12-21 11:21:33, Yu Kuai wrote:
>> Moving bfqq to it's parent bfqg is pointless.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>=20
> Did you notice that this is happening often enough that the check is worth
> it? Where do we do this?
>=20

I noticed that this will happend when root group is offlined:

bfq_pd_offline
  bfq_put_async_queues
   __bfq_put_async_bfqq
    bfq_bfqq_move

I'm not sure if there are other situations. I think bfq_bfqq_move()
is not happening often itself, thus the checking won't affect
performance.

Thanks,
Kuai
> 								Honza
>=20
>> ---
>>   block/bfq-cgroup.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index 24a5c5329bcd..0f62546a72d4 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -645,6 +645,11 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bf=
q_queue *bfqq,
>>   		   struct bfq_group *bfqg)
>>   {
>>   	struct bfq_entity *entity =3D &bfqq->entity;
>> +	struct bfq_group *old_parent =3D bfq_group(bfqq);
>> +
>> +	/* No point to move bfqq to the same group */
>> +	if (old_parent =3D=3D bfqg)
>> +		return;
>>  =20
>>   	/*
>>   	 * Get extra reference to prevent bfqq from being freed in
>> @@ -666,7 +671,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq=
_queue *bfqq,
>>   		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
>>   	else if (entity->on_st_or_in_serv)
>>   		bfq_put_idle_entity(bfq_entity_service_tree(entity), entity);
>> -	bfqg_and_blkg_put(bfqq_group(bfqq));
>> +	bfqg_and_blkg_put(old_parent);
>>  =20
>>   	if (entity->parent &&
>>   	    entity->parent->last_bfqq_created =3D=3D bfqq)
>> --=20
>> 2.31.1
>>
