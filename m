From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v3 4/5] blk-iocost: fix divide by 0 error in calc_lcoefs()
Date: Thu, 5 Jan 2023 09:53:38 +0800
Message-ID: <9b23b5a9-c730-1156-cd59-772f5559b4f7@huaweicloud.com>
References: <20221226085859.2701195-1-yukuai1@huaweicloud.com>
 <20221226085859.2701195-5-yukuai1@huaweicloud.com>
 <Y7X1fFO4UP7QnwkC@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y7X1fFO4UP7QnwkC@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2023/01/05 5:54, Tejun Heo =D0=B4=B5=C0:
> On Mon, Dec 26, 2022 at 04:58:58PM +0800, Yu Kuai wrote:
>> From: Li Nan <linan122@huawei.com>
>>
>> echo max of u64 to cost.model can cause divide by 0 error.
>>
>>    # echo 8:0 rbps=3D18446744073709551615 > /sys/fs/cgroup/io.cost.model
>>
>>    divide error: 0000 [#1] PREEMPT SMP
>>    RIP: 0010:calc_lcoefs+0x4c/0xc0
>>    Call Trace:
>>     <TASK>
>>     ioc_refresh_params+0x2b3/0x4f0
>>     ioc_cost_model_write+0x3cb/0x4c0
>>     ? _copy_from_iter+0x6d/0x6c0
>>     ? kernfs_fop_write_iter+0xfc/0x270
>>     cgroup_file_write+0xa0/0x200
>>     kernfs_fop_write_iter+0x17d/0x270
>>     vfs_write+0x414/0x620
>>     ksys_write+0x73/0x160
>>     __x64_sys_write+0x1e/0x30
>>     do_syscall_64+0x35/0x80
>>     entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> calc_lcoefs() uses the input value of cost.model in DIV_ROUND_UP_ULL,
>> overflow would happen if bps plus IOC_PAGE_SIZE is greater than
>> ULLONG_MAX, it can cause divide by 0 error.
>>
>> Fix the problem by setting basecost
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   block/blk-iocost.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
>> index f8726e20da20..c6b39024117b 100644
>> --- a/block/blk-iocost.c
>> +++ b/block/blk-iocost.c
>> @@ -866,9 +866,13 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 r=
andiops,
>>  =20
>>   	*page =3D *seqio =3D *randio =3D 0;
>>  =20
>> -	if (bps)
>> -		*page =3D DIV64_U64_ROUND_UP(VTIME_PER_SEC,
>> -					   DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
>> +	if (bps) {
>> +		if (bps >=3D U64_MAX - IOC_PAGE_SIZE)
>> +			*page =3D 1;
>> +		else
>> +			*page =3D DIV64_U64_ROUND_UP(VTIME_PER_SEC,
>> +					DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
>> +	}
>=20
> This is a nitpick but wouldn't something like the following be easier to
> understand?
>=20
>          if (bps) {
>                  u64 bps_pages =3D DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE);
>=20
>                  if (bps_pages)
>                          *pages =3D DIV64_U64_ROUND_UP(VTIME_PER_SEC, bps=
_pages);
>                  else
>                          *pages =3D 1;
>          }
>=20
Yes, I agree that this is better to understand. I'll send a new version.

Thanks,
Kuai

