From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 8/9] block, bfq: move forward
 __bfq_weights_tree_remove()
Date: Sat, 11 Dec 2021 10:18:53 +0800
Message-ID: <93f26416-19d9-43f6-01ad-652c1b763d09@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <20211127101132.486806-9-yukuai3@huawei.com>
 <FA78962A-DC03-4A1F-9B79-D085A4908E5E@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FA78962A-DC03-4A1F-9B79-D085A4908E5E-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2021/12/10 18:00, Paolo Valente =D0=B4=B5=C0:
>=20
>=20
>> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai <yukuai3-hv44wF8Li93QT0dZ=
R+AlfA@public.gmane.org> ha scritto:
>>
>> Prepare to decrease 'num_groups_with_pending_reqs' earlier.
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>> block/bfq-iosched.c | 13 +++++--------
>> 1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>> index e3c31db4bffb..4239b3996e23 100644
>> --- a/block/bfq-iosched.c
>> +++ b/block/bfq-iosched.c
>> @@ -882,6 +882,10 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
>> {
>> 	struct bfq_entity *entity =3D bfqq->entity.parent;
>>
>> +	bfqq->ref++;
>> +	__bfq_weights_tree_remove(bfqd, bfqq,
>> +				  &bfqd->queue_weights_tree);
>> +
>> 	for_each_entity(entity) {
>> 		struct bfq_sched_data *sd =3D entity->my_sched_data;
>>
>> @@ -916,14 +920,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
>> 		}
>> 	}
>>
>> -	/*
>> -	 * Next function is invoked last, because it causes bfqq to be
>> -	 * freed if the following holds: bfqq is not in service and
>> -	 * has no dispatched request. DO NOT use bfqq after the next
>> -	 * function invocation.
>> -	 */
>> -	__bfq_weights_tree_remove(bfqd, bfqq,
>> -				  &bfqd->queue_weights_tree);
>> +	bfq_put_queue(bfqq);
>> }
>>
>=20
> why it is not dangerous any longer to invoke __bfq_weights_tree_remove ea=
rlier, and the comment can be removed?

Hi, Paolo

Here I grab an additional ref to the bfqq, thus the bfqq is ensured not
to be free before bfq_put_queue() at the end of the function.

Maybe some comments is more appropriate.

Thanks,
Kuai
>=20
> Paolo
>=20
>> /*
>> --=20
>> 2.31.1
>>
>=20
> .
>=20
