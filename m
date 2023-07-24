From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators
 of sockmem pressure
Date: Mon, 24 Jul 2023 11:47:02 +0800
Message-ID: <58e75f44-16e3-a40a-4c8a-0f61bbf393f9@bytedance.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
 <ZLsg1wklldKkVI2Z@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690170431; x=1690775231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1NSxBI+jZ4lM78HRKxD8ibkmyQyG/FtRFP+HyoBnx5I=;
        b=PgEeS0qOI+pKcrpPsv7cx17Jlt7Uzht14nwBIdBKNMvY9lkPJv+0Kt98k1wsdnIzG9
         iSOI7qakWbJdPnM6TsHMhEEbpc1/VybplhTM0PsZyroqv8Kmm0p+by7fpC7oedDAGnFJ
         eCmTNVgTyCAu5MVVme1Ez5G8PIxUSZqLfqn3iEHdI5GWl+HVWWK3XgVHPwP99qeED/Nr
         54QvjkQaaJj8zr0ff8BGNk0KBQ5UUrnePYxFm4YzSF3r0O2Nq3CP3fITV8nYm1kwMXkc
         ro+uz9JlKWbIcp26gzgXJ+gw4DKpOys7OSBDl5v5JwqaBhyejNeuuwKnv1Em5AkWiAPb
         jwRQ==
Content-Language: en-US
In-Reply-To: <ZLsg1wklldKkVI2Z-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Mikhalitsyn <alexander-uFy+/5nkmnuaMJb+Lgu22Q@public.gmane.org>, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, David Howells <dhowel>

Hi Roman, thanks for taking time to have a look!

On 7/22/23 8:20 AM, Roman Gushchin wrote:
> On Tue, Jul 11, 2023 at 08:41:43PM +0800, Abel Wu wrote:
>> Now there are two indicators of socket memory pressure sit inside
>> struct mem_cgroup, socket_pressure and tcpmem_pressure.
> 
> Hi Abel!
> 
>> When in legacy mode aka. cgroupv1, the socket memory is charged
>> into a separate counter memcg->tcpmem rather than ->memory, so
>> the reclaim pressure of the memcg has nothing to do with socket's
>> pressure at all.
> 
> But we still might set memcg->socket_pressure and propagate the pressure,
> right?

Yes, but the pressure comes from memcg->socket_pressure does not mean
pressure in socket memory in cgroupv1, which might lead to premature
reclamation or throttling on socket memory allocation. As the following
example shows:

			->memory	->tcpmem
	limit		10G		10G
	usage		9G		4G
	pressure	true		false

the memcg's memory limits are both set to 10G, and the ->memory part
is suffering from reclaim pressure while ->tcpmem still has much room
for use. I have no idea why should treat the ->tcpmem as under pressure
in this scenario, am I missed something?

> If you're changing this, you need to provide a bit more data on why it's
> a good idea. I'm not saying the current status is perfect, but I think we need
> a bit more justification for this change.
> 
>> While for default mode, the ->tcpmem is simply
>> not used.
>>
>> So {socket,tcpmem}_pressure are only used in default/legacy mode
>> respectively. This patch fixes the pieces of code that make mixed
>> use of both.
>>
>> Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>> ---
>>   include/linux/memcontrol.h | 4 ++--
>>   mm/vmpressure.c            | 8 ++++++++
>>   2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 5818af8eca5a..5860c7f316b9 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -1727,8 +1727,8 @@ void mem_cgroup_sk_alloc(struct sock *sk);
>>   void mem_cgroup_sk_free(struct sock *sk);
>>   static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
>>   {
>> -	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
>> -		return true;
>> +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +		return !!memcg->tcpmem_pressure;
> 
> So here you can have something like
>     if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
>          do {
>              if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
>                    return true;
>          } while ((memcg = parent_mem_cgroup(memcg)));
>     } else {
> 	return !!READ_ONCE(memcg->socket_pressure);
>     }

Yes, this looks better.

> 
> And, please, add a bold comment here or nearby the socket_pressure definition
> that it has a different semantics in the legacy and default modes.

Agreed.

> 
> Overall I think it's a good idea to clean these things up and thank you
> for working on this. But I wonder if we can make the next step and leave only
> one mechanism for both cgroup v1 and v2 instead of having this weird setup
> where memcg->socket_pressure is set differently from different paths on cgroup
> v1 and v2.

There is some difficulty in unifying the mechanism for both cgroup
designs. Throttling socket memory allocation when memcg is under
pressure only makes sense when socket memory and other usages are
sharing the same limit, which is not true for cgroupv1. Thoughts?

Thanks & Best,
	Abel
