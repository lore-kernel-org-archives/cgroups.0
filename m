From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH 3/4] blk-cgroup: Add NULL check of pd_alloc_fn in
 blkcg_activate_policy
Date: Tue, 11 Oct 2022 15:53:28 +0800
Message-ID: <8de2f8d1-f3ec-4d93-f7e8-403d609ae9e7@huaweicloud.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-4-shikemeng@huawei.com>
 <Y0SAneaJadYJwAkr@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y0SAneaJadYJwAkr@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Kemeng Shi <shikemeng@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>

Hi, Tejun

=D4=DA 2022/10/11 4:29, Tejun Heo =D0=B4=B5=C0:
> On Mon, Oct 10, 2022 at 10:38:58AM +0800, Kemeng Shi wrote:
>> Function only make sure pd_alloc_fn and pd_free_fn in
>> pairs, so pd_alloc_fn could be NULL in registered blkcg_policy. Check NU=
LL
>> before use for pd_alloc_fn in blkcg_activate_policy to avoid protential
>> NULL dereference.
>>
>> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
>> ---
>>   block/blk-cgroup.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 463c568d3e86..fc083c35dc42 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -1404,6 +1404,9 @@ int blkcg_activate_policy(struct request_queue *q,
>>   	if (blkcg_policy_enabled(q, pol))
>>   		return 0;
>>  =20
>> +	if (pol->pd_alloc_fn =3D=3D NULL)
>> +		return -EINVAL;
>=20
> This isn't the only place this function is called, so the above won't
> achieve much. Given that this is rather trivially noticeable and all the
> current users do implement pd_alloc_fn, I'm not sure we need to update th=
is
> now.

It's right all the current users implement pd_alloc_fn, can we check
pd_alloc/free_fn NULL instead in blkcg_policy_register()?

Thanks,
Kuai
>=20
> Thanks.
>=20

