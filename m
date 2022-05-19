From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next 7/8] block, bfq: cleanup
 bfq_bfqq_update_budg_for_activation()
Date: Thu, 19 May 2022 21:21:25 +0800
Message-ID: <6de25fae-7d36-c31c-a045-4f1668ef4ee5@huawei.com>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
 <20220514090522.1669270-8-yukuai3@huawei.com>
 <20220519111856.wvk4oetm7odnkg3w@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220519111856.wvk4oetm7odnkg3w@quack3.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/05/19 19:18, Jan Kara =D0=B4=B5=C0:
> On Sat 14-05-22 17:05:21, Yu Kuai wrote:
>> It will only be called from bfq_bfqq_handle_idle_busy_switch() in
>> specific code branch, there is no need to precaculate
>> 'bfqq_wants_to_preempt' each time bfq_bfqq_handle_idle_busy_switch()
>> is caleld.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>=20
> Please see below:
>=20
>> @@ -1816,14 +1807,6 @@ static void bfq_bfqq_handle_idle_busy_switch(stru=
ct bfq_data *bfqd,
>>   		  (bfqq->bic || RQ_BIC(rq)->stably_merged) &&
>>   		   (*interactive || soft_rt)));
>>  =20
>> -	/*
>> -	 * Using the last flag, update budget and check whether bfqq
>> -	 * may want to preempt the in-service queue.
>> -	 */
>> -	bfqq_wants_to_preempt =3D
>> -		bfq_bfqq_update_budg_for_activation(bfqd, bfqq,
>> -						    arrived_in_time);
>> -
>>   	/*
>>   	 * If bfqq happened to be activated in a burst, but has been
>>   	 * idle for much more than an interactive queue, then we
> ...
>> @@ -1918,7 +1900,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struc=
t bfq_data *bfqd,
>>   	 * (2) this switch of bfqq to busy changes the scenario.
>>   	 */
>>   	if (bfqd->in_service_queue &&
>> -	    ((bfqq_wants_to_preempt &&
>> +	    ((bfq_bfqq_update_budg_for_activation(bfqd, bfqq) &&
>>   	      bfqq->wr_coeff >=3D bfqd->in_service_queue->wr_coeff) ||
>>   	     bfq_bfqq_higher_class_or_weight(bfqq, bfqd->in_service_queue) ||
>>   	     !bfq_better_to_idle(bfqd->in_service_queue)) &&
>=20
> So these changes are actually wrong because
> bfq_bfqq_update_budg_for_activation() relies on
> bfq_bfqq_non_blocking_wait_rq() but bfq_add_bfqq_busy() clears that. And
> bfq_add_bfqq_busy() is called between the place where
> bfq_bfqq_update_budg_for_activation() was called previously and now so yo=
ur
> patch breaks this logic.

Hi,

You are right, thanks for the explanation, I'll remove this patch and
the next patch in next version.

Kuai
>=20
> 								Honza
>=20
