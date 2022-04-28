From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v4 1/3] block, bfq: record how many queues are busy
 in bfq_group
Date: Thu, 28 Apr 2022 19:27:28 +0800
Message-ID: <00fafd9e-5433-70d8-6493-46a2cc78ec97@huawei.com>
References: <20220428111907.3635820-1-yukuai3@huawei.com>
 <20220428111907.3635820-2-yukuai3@huawei.com>
 <20220428111800.aqfzwwii5dabx3ko@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220428111800.aqfzwwii5dabx3ko-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/04/28 19:18, Jan Kara =D0=B4=B5=C0:
> On Thu 28-04-22 19:19:05, Yu Kuai wrote:
>> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
>>
>> Add a counter 'busy_queues' in bfq_group, and update it in
>> bfq_add/del_bfqq_busy().
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Just two nits below:
>=20
>> --- a/block/bfq-wf2q.c
>> +++ b/block/bfq-wf2q.c
>> @@ -218,6 +218,16 @@ static bool bfq_no_longer_next_in_service(struct bf=
q_entity *entity)
>>   	return false;
>>   }
>>  =20
>> +static void bfq_add_busy_queues(struct bfq_queue *bfqq)
>> +{
>> +	bfqq_group(bfqq)->busy_queues++;
>> +}
>> +
>> +static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
>> +{
>> +	bfqq_group(bfqq)->busy_queues--;
>> +}
>> +
>=20
> An opposite from "decrement" is "increment", not "add". So
> bfq_add_busy_queues() should be bfq_inc_busy_queues().

You are right
>=20
>> @@ -230,6 +240,14 @@ static bool bfq_no_longer_next_in_service(struct bf=
q_entity *entity)
>>   	return true;
>>   }
>>  =20
>> +static void bfq_add_busy_queues(struct bfq_queue *bfqq)
>> +{
>> +}
>> +
>> +static void bfq_add_busy_queues(struct bfq_queue *bfqq)
>> +{
>> +}
>> +
>=20
> You have two times the same function here and you miss the other one...

oops, I forgot to compile without CONFIG_BFQ_GROUP_IOSCHED...

Thanks a lot to spolt this.
Kuai
>=20
> 								Honza
>=20
