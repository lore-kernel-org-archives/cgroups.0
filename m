From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 09/23] kmem slab accounting basic infrastructure
Date: Wed, 2 May 2012 12:15:43 -0300
Message-ID: <4FA14F9F.10401@parallels.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1334959051-18203-10-git-send-email-glommer@parallels.com> <CABCjUKBCqBWXuyzx73y3sekNqAKpYqAhRjQDtSWF5o7qUbC-RA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKBCqBWXuyzx73y3sekNqAKpYqAhRjQDtSWF5o7qUbC-RA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


>> @@ -3951,8 +3966,26 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
>>                         break;
>>                 if (type == _MEM)
>>                         ret = mem_cgroup_resize_limit(memcg, val);
>> -               else
>> +               else if (type == _MEMSWAP)
>>                         ret = mem_cgroup_resize_memsw_limit(memcg, val);
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> +               else if (type == _KMEM) {
>> +                       ret = res_counter_set_limit(&memcg->kmem, val);
>> +                       if (ret)
>> +                               break;
>> +                       /*
>> +                        * Once enabled, can't be disabled. We could in theory
>> +                        * disable it if we haven't yet created any caches, or
>> +                        * if we can shrink them all to death.
>> +                        *
>> +                        * But it is not worth the trouble
>> +                        */
>> +                       if (!memcg->kmem_accounted&&  val != RESOURCE_MAX)
>> +                               memcg->kmem_accounted = true;
>> +               }
>> +#endif
>> +               else
>> +                       return -EINVAL;
>>                 break;
>>         case RES_SOFT_LIMIT:
>>                 ret = res_counter_memparse_write_strategy(buffer,&val);
>
> Why is RESOURCE_MAX special?

Because I am using the convention that setting it to any value different 
than that will enable accounting.
