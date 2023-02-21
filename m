From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Skip high limit check in root memcg
Date: Tue, 21 Feb 2023 22:21:45 +0800
Message-ID: <99bdfbec-2de4-b432-9649-09557d3f95d6@shopee.com>
References: <20230210094550.5125-1-haifeng.xu@shopee.com>
 <Y+uvRKo7OQ02yB4K@dhcp22.suse.cz>
 <82918a12-d83e-10c0-0e04-eec26657b699@shopee.com>
 <Y/S3GHT1P6awZaPb@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flPFw0D3KpcP6j/qLwV4RKv74RjgOZhXW58bNnl0IIg=;
        b=DshPrdq9zPn2WIl+z3nj6W4ilUqSYOm65cgTLYZoKgyRyls987vrjwB342gfw1goD5
         wuhD3QhsHkyOIgm3+aX9ZkgljdlDBITg9AC59tPuLDYtR9iTYasBr4DpVDAtKLt0qBxf
         Qpoiw1lsKXL+Gfu0D+bkyskvbz1iHA2JcVA7X21hieGXlcEueNQnbqSR+WHhiL1SiA6z
         1sIF9+FDEVnk9OG2A89vDYtMqCMT+CZF6ngCPZ+fKgcMnO9/khYb1zBz3K6Utg6dU5Xb
         EFPbhVz1EZzFwPFm2Cd7VJKmLdDBEbYmbyWC2PwUtD02HCunHu+MaLRr49YFvetzfD6P
         3fHA==
In-Reply-To: <Y/S3GHT1P6awZaPb-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/2/21 20:20, Michal Hocko wrote:
> On Tue 21-02-23 18:29:39, Haifeng Xu wrote:
>>
>>
>> On 2023/2/14 23:56, Michal Hocko wrote:
>>> On Fri 10-02-23 09:45:50, Haifeng Xu wrote:
>>>> The high limit checks the memory usage from given memcg to root memcg.
>>>> However, there is no limit in root memcg. So this check makes no sense
>>>> and we can ignore it.
>>>
>>> Is this check actually addining any benefit? Have you measured aby
>>> performance gains by this change?
>>>
>>>> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gm=
ane.org>
>>>> ---
>>>>  mm/memcontrol.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 73afff8062f9..a31a56598f29 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -2780,6 +2780,10 @@ static int try_charge_memcg(struct mem_cgroup *=
memcg, gfp_t gfp_mask,
>>>>  	do {
>>>>  		bool mem_high, swap_high;
>>>> =20
>>>> +		/* There is no need for root memcg to check high limit */
>>>> +		if (mem_cgroup_is_root(memcg))
>>>> +			break;
>>>> +
>>>>  		mem_high =3D page_counter_read(&memcg->memory) >
>>>>  			READ_ONCE(memcg->memory.high);
>>>>  		swap_high =3D page_counter_read(&memcg->swap) >
>>>> --=20
>>>> 2.25.1
>>>
>>
>> test steps:
>> 1. mkdir -p /sys/fs/cgroup/memory/test
>> 2. echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
>> 3. ./mmap_test
>>
>> The test result show that with or without the patch, the time taken is a=
lmost the same.
>=20
> This is in line with my expectation. So the question is whether the
> additional check is really worth it.=20

This patch doesn't bring any obvious benifit or harm, but the high limit ch=
eck in root memcg seems a little weird.
Maybe we can add this check=EF=BC=9FIt all depends on your viewpoint.

Thanks.
=20
