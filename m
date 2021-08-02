From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Mon, 2 Aug 2021 17:54:05 +0800
Message-ID: <0b0f943f-0ea7-b7de-f321-e38bf1089b42@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-3-linmiaohe@huawei.com> <YQNsxVPsRSBZcfGG@carbon.lan>
 <YQOhGs3k9rHx3mmT@dhcp22.suse.cz>
 <4a3c23c4-054c-2896-29c5-8cf9a4deee98@huawei.com>
 <YQeVYLP6M9tMw0P0@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YQeVYLP6M9tMw0P0-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2021/8/2 14:49, Michal Hocko wrote:
> On Sat 31-07-21 10:29:52, Miaohe Lin wrote:
>> On 2021/7/30 14:50, Michal Hocko wrote:
>>> On Thu 29-07-21 20:06:45, Roman Gushchin wrote:
>>>> On Thu, Jul 29, 2021 at 08:57:52PM +0800, Miaohe Lin wrote:
>>>>> Since percpu_charge_mutex is only used inside drain_all_stock(), we c=
an
>>>>> narrow the scope of percpu_charge_mutex by moving it here.
>>>>>
>>>>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gm=
ane.org>
>>>>> ---
>>>>>  mm/memcontrol.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>> index 6580c2381a3e..a03e24e57cd9 100644
>>>>> --- a/mm/memcontrol.c
>>>>> +++ b/mm/memcontrol.c
>>>>> @@ -2050,7 +2050,6 @@ struct memcg_stock_pcp {
>>>>>  #define FLUSHING_CACHED_CHARGE	0
>>>>>  };
>>>>>  static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
>>>>> -static DEFINE_MUTEX(percpu_charge_mutex);
>>>>> =20
>>>>>  #ifdef CONFIG_MEMCG_KMEM
>>>>>  static void drain_obj_stock(struct obj_stock *stock);
>>>>> @@ -2209,6 +2208,7 @@ static void refill_stock(struct mem_cgroup *mem=
cg, unsigned int nr_pages)
>>>>>   */
>>>>>  static void drain_all_stock(struct mem_cgroup *root_memcg)
>>>>>  {
>>>>> +	static DEFINE_MUTEX(percpu_charge_mutex);
>>>>>  	int cpu, curcpu;
>>>>
>>>> It's considered a good practice to protect data instead of code paths.=
 After
>>>> the proposed change it becomes obvious that the opposite is done here:=
 the mutex
>>>> is used to prevent a simultaneous execution of the code of the drain_a=
ll_stock()
>>>> function.
>>>
>>> The purpose of the lock was indeed to orchestrate callers more than any
>>> data structure consistency.
>>> =20
>>>> Actually we don't need a mutex here: nobody ever sleeps on it. So I'd =
replace
>>>> it with a simple atomic variable or even a single bitfield. Then the c=
hange will
>>>> be better justified, IMO.
>>>
>>> Yes, mutex can be replaced by an atomic in a follow up patch.
>>>
>>
>> Thanks for both of you. It's a really good suggestion. What do you mean =
is something like below=EF=BC=9F
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 616d1a72ece3..508a96e80980 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2208,11 +2208,11 @@ static void refill_stock(struct mem_cgroup *memc=
g, unsigned int nr_pages)
>>   */
>>  static void drain_all_stock(struct mem_cgroup *root_memcg)
>>  {
>> -       static DEFINE_MUTEX(percpu_charge_mutex);
>>         int cpu, curcpu;
>> +       static atomic_t drain_all_stocks =3D ATOMIC_INIT(-1);
>>         /* If someone's already draining, avoid adding running more work=
ers. */
>> -       if (!mutex_trylock(&percpu_charge_mutex))
>> +       if (!atomic_inc_not_zero(&drain_all_stocks))
>>                 return;
>>         /*
>>          * Notify other cpus that system-wide "drain" is running
>> @@ -2244,7 +2244,7 @@ static void drain_all_stock(struct mem_cgroup *roo=
t_memcg)
>>                 }
>>         }
>>         put_cpu();
>> -       mutex_unlock(&percpu_charge_mutex);
>> +       atomic_dec(&drain_all_stocks);
>=20
> Yes this would work. I would just s@drain_all_stocks@drainers@ or
> something similar to better express the intention.
>=20

Sounds good. Will do it in v2. Many thanks.

>>  }
>>
>>  static int memcg_hotplug_cpu_dead(unsigned int cpu)
>=20

