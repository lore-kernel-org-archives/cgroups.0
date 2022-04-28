From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next v3 1/3] block, bfq: record how many queues are busy
 in bfq_group
Date: Thu, 28 Apr 2022 09:08:14 +0800
Message-ID: <4c783fa9-f01b-1f9e-9bcb-0e26431d0d24@huawei.com>
References: <20220427124722.48465-1-yukuai3@huawei.com>
 <20220427124722.48465-2-yukuai3@huawei.com>
 <20220427125251.yl7ff4ti33w6ktrf@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220427125251.yl7ff4ti33w6ktrf@quack3.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/04/27 20:52, Jan Kara =D0=B4=B5=C0:
> On Wed 27-04-22 20:47:20, Yu Kuai wrote:
>> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
>>
>> Add a counter 'busy_queues' in bfq_group, and update it in
>> bfq_add/del_bfqq_busy().
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>=20
> ...
>=20
>> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
>> index f8eb340381cf..53826797430f 100644
>> --- a/block/bfq-wf2q.c
>> +++ b/block/bfq-wf2q.c
>> @@ -218,6 +218,14 @@ static bool bfq_no_longer_next_in_service(struct bf=
q_entity *entity)
>>   	return false;
>>   }
>>  =20
>> +static void bfq_update_busy_queues(struct bfq_queue *bfqq, bool is_add)
>> +{
>> +	if (is_add)
>> +		bfqq_group(bfqq)->busy_queues++;
>> +	else
>> +		bfqq_group(bfqq)->busy_queues--;
>> +}
>> +
>>   #else /* CONFIG_BFQ_GROUP_IOSCHED */
>=20
> I think the bool argument here unnecessarily hurts readability (it's
> difficult to see what the argument means without looking into the
> implementation). I'd rather create two functions bfq_{inc,dec}_busy_queue=
s()
> or if you really insist on a single function, we can have
> bfq_add_busy_queues() and have 'int' argument that will be +1 or -1.

Thanks for the suggestion, I'll create two functions in next iteration.
>=20
> 								Honza
>=20
